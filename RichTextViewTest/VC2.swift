//
//  VC@.swift
//  RichTextViewTest
//
//  Created by 최동호 on 2021/07/14.
//

import UIKit
import RichTextView
import iosMath

class VC2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        MTMathAtomFactory.addLatexSymbol("ss", value: MTMathAtomFactory.operator(withName: "한글", limits: true))
        
        MTMathAtomFactory.addLatexSymbol("qq", value: MTMathAtomFactory.operator(withName: "동호동호1", limits: true))
        
        let sampleText = """
# This is Header\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus augue est, mollis at libero ac, gravida volutpat risus. Duis vel libero eget nulla porta auctor non id eros. Quisque efficitur magna sed elit imperdiet, a dictum urna aliquam. Morbi et magna et quam aliquet commodo. Nunc semper et sem ut venenatis. Cras a velit at nunc ultrices lacinia. Pellentesque id pharetra dolor. Aenean sed ligula dolor. Donec quis vulputate velit.

Integer cursus quam et posuere faucibus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Phasellus viverra felis sed est interdum, eu dictum felis aliquam. Etiam pharetra metus ut orci pharetra rutrum. Mauris maximus sem vel suscipit porta. Integer cursus hendreri

[math] \\frac{\\ss}{\\ss abcd} [/math] Lorem ipsum dolor sit amet, 테스트 문장테스트 문장테스트 문장테스트 문장테스트 문장테스트 문장테스트 문장테스트 문장테스트 문장테스트 문장.

[math] \\frac{\\qq}{\\qq} [/math]
[math] \\frac{ab}{\\text{abc}} [/math]
[math] \\frac{2}{1} [/math]
"""
//        // [math] \\frac{\\text{멋지고 잘생겼다}}{2} \\times \\frac{2}{3} [/math]
        let richTextView = RichTextView(input: sampleText,
                                        font: UIFont.systemFont(ofSize: 15, weight: .bold),
                                        latexTextBaselineOffset: 5,
                                        frame: CGRect.zero)
        view.addSubview(richTextView)
        richTextView.sizeToFit()
        richTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-20)
        }
    }
}
