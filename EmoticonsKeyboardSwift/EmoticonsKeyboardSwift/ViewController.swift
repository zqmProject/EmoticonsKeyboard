//
//  ViewController.swift
//  EmoticonsKeyboardSwift
//
//  Created by QingMingZhang on 16/9/9.
//  Copyright © 2016年 极客栈. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(QMInputBar.instance)
        QMInputBar.instance.placeholder = "请输入..."
        
        let ttv = UITextView(frame: CGRectMake(50, 50, 100, 100))
        ttv.backgroundColor = UIColor.yellowColor()
        QMInputBar.instance.textView = ttv
        self.view.addSubview(ttv)
        let v = UIView(frame: CGRectMake(0, 0, 0, 100))
        v.backgroundColor = UIColor.yellowColor()
//        let kb = QMEmoticonsKeyboard.instance
//        ttv.inputView = kb
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }


}

