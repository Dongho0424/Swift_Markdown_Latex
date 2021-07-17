//
//  ViewController.swift
//  RichTextViewTest
//
//  Created by 최동호 on 2021/07/14.
//

import UIKit
import RichTextView
import SnapKit
import iosMath
import RxSwift
import RxCocoa
import Alamofire

class ViewController: UIViewController {
    
    let d = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchExp(with: "https://u9lxtdgwsh.execute-api.ap-northeast-2.amazonaws.com/dev/markdown/2")
            .subscribe(onNext: { str in
                let sampleText = self.convert(str: str)

                let richTextView = RichTextView(input: sampleText,
                                                font: UIFont.systemFont(ofSize: 15, weight: .medium),
                                                latexTextBaselineOffset: 5,
                                                frame: CGRect.zero)

                self.view.addSubview(richTextView)
                richTextView.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.top.equalToSuperview().offset(60)
                    make.right.equalToSuperview().offset(-20)
                }
                
            }, onError: { err in
                NSLog(err.localizedDescription)
            })
            .disposed(by: d)
        
    }
    
    func fetchExp(with urlString: String) -> Observable<String> {
        return Observable.create { observer in
            
            AF.request(urlString).responseString { res in
                
                switch res.result {
                case .success(let str):
                    observer.onNext(str)
                    observer.onCompleted()
                case .failure(let err):
                    observer.onError(err)
                }
            }
            return Disposables.create()
        }
    }
    
    // O(n^2)
    func convert(str: String) -> String {
        
        let tag1 = "[math]"
        let tag2 = "[/math]"
        
        var convertedString = str
        var indexList: [String.Index] = []
        for index in convertedString.indices {
            if convertedString[index] == "$" {
                indexList.append(index)
            }
        }
        
        if indexList.count % 2 != 0 {
            fatalError()
        }

        var i = 0
        while true {
            if i == indexList.count { break }
            for index in convertedString.indices {
                if convertedString[index] == "$" {
                    // $ -> tag1
                    if i % 2 == 0 {
                        convertedString.remove(at: index)
                        convertedString.insert(contentsOf: tag1, at: index)
                    } else { // $ -> tag2
                        convertedString.remove(at: index)
                        convertedString.insert(contentsOf: tag2, at: index)
                    }
                    i += 1
                    break
                }
            }
        }
        
        var asciiNum = 96
        while let inText = convertedString.getSubstring(inBetween: "text{", and: "}") {
            asciiNum += 1
            let symbol = String(UnicodeScalar(UInt8(asciiNum))) + String(UnicodeScalar(UInt8(asciiNum)))
            let lowerIndex = convertedString.range(of: "\\text{")?.lowerBound
            
            let upperIndex = convertedString.range(of: "}", range: lowerIndex!..<convertedString.endIndex)?.lowerBound
            
            convertedString.removeSubrange(lowerIndex!...upperIndex!)
            
            convertedString.insert(contentsOf: "\\\(symbol) ", at: lowerIndex!)
            
            MTMathAtomFactory.addLatexSymbol("\(symbol)", value: MTMathAtomFactory.operator(withName: "\(inText)", limits: true))
            
        }
        
        return convertedString
    }
}
