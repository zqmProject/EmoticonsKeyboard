//
//  QMEmoticonTextView.swift
//  EmoticonsKeyboardSwift
//
//  Created by QingMingZhang on 16/9/10.
//  Copyright © 2016年 极客栈. All rights reserved.
//

import UIKit

@objc protocol QMEmoticonTextViewDelegate: UITextViewDelegate {
    optional func textViewDidDeleteBackward(textView: UITextView)
}

class QMEmoticonTextView: UITextView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var emotionTextViewDelegate: QMEmoticonTextViewDelegate? = nil

    override func deleteBackward() {
        if false {
            
        }
        super.deleteBackward()
    }
    
}
