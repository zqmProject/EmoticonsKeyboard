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
        
        do{
            var str = self.text
            let pattern = "\\[#imgface\\d+#]$"
            let regex = try NSRegularExpression(pattern: pattern, options:NSRegularExpressionOptions.CaseInsensitive)
            let res = regex.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
            if res.count > 0 {
                str = (str as NSString).stringByReplacingCharactersInRange(res[res.count-1].range, withString: "") as String
                self.text = str
                delegate?.textViewDidChange?(self)
                print("delete: \(str)")
            }
            else {
                
                super.deleteBackward()
                
            }
            
        }catch{
            super.deleteBackward()
            print(error)
        }

        
        
    }
    
}
