//
//  QMInputBar.swift
//  EmoticonsKeyboardSwift
//
//  Created by QingMingZhang on 16/9/9.
//  Copyright © 2016年 极客栈. All rights reserved.
//

import UIKit


private let kScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
private let kScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height


private let kPaddingTop: CGFloat = 8.0
private let kPaddingLeft: CGFloat = 13.0
private let kPaddingRight: CGFloat = 13.0

/// InputBar默认宽度
private let kInputBarDefaultWidth: CGFloat = kScreenWidth
/// InputBar默认高度
private let kInputBarDefaultHeight: CGFloat = 50.0

/// 输入框Y偏移量 0.0 替换成需要的值
private let kInputBarDefaultEdgeInsetTop: CGFloat = 0.0 - kInputBarDefaultHeight
private let kInputBarDefaultFrame: CGRect = CGRectMake(0, kScreenHeight - kInputBarDefaultEdgeInsetTop - kInputBarDefaultHeight , kScreenWidth, kInputBarDefaultHeight)

private let kLineViewHeght: CGFloat = 0.5
/// 顶部分割线
private let kTopLineViewFrame: CGRect = CGRectMake(0, 0, kScreenWidth, kLineViewHeght)
/// 底部分割线
private let kBottomLineViewFrame: CGRect = CGRectMake(0, kInputBarDefaultHeight - kLineViewHeght, kScreenWidth, kLineViewHeght)


/// 表情切换按钮宽
private let kEmojiButtonWidth: CGFloat = 33.0
/// 表情切换按钮高
private let kEmojiButtonHeight: CGFloat = 33.0
/// 表情切换按钮Frame
private let kEmojiButtonFrame: CGRect = CGRectMake(kPaddingLeft, kPaddingTop + kLineViewHeght, kEmojiButtonWidth, kEmojiButtonHeight)

/// 发送按钮宽度
private let kSendButtonWidth: CGFloat = 50.0
/// 发送按钮高度
private let kSendButtonHeight: CGFloat = 33.0

private let kSendButtonX: CGFloat = kScreenWidth - kPaddingRight - kSendButtonWidth

private let kSendButtonFrame: CGRect = CGRectMake(kSendButtonX, kPaddingTop + kLineViewHeght, kSendButtonWidth, kSendButtonHeight)


private let kTextViewX: CGFloat = kPaddingLeft + kEmojiButtonWidth + 10.0
private let kTextViewY: CGFloat = kPaddingTop + kLineViewHeght
private let kTextViewWidth: CGFloat = kScreenWidth - kTextViewX - 10.0 - kSendButtonWidth - kPaddingRight
private let kTextViewHeight: CGFloat = 33.0
private let kTextViewFrame: CGRect = CGRectMake(kTextViewX, kTextViewY, kTextViewWidth, kTextViewHeight)
private let kPlaceholderLabelFrame: CGRect = CGRectMake(kTextViewX + 5.0, kTextViewY, kTextViewWidth - 5.0, kTextViewHeight)


private let kEmoticonCellWH: CGFloat = 32.0
private let kEmoticonCellWidth: CGFloat = 32.0
private let kEmoticonCellHeight: CGFloat = 32.0


@objc protocol QMInputBarDelegate: NSObjectProtocol {
    optional func inputBar(inputBar: QMInputBar, didOnClickSendButton sendButton: UIButton)
}

class QMInputBar: UIView, UITextViewDelegate, QMEmoticonsKeyboardDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var delegate: QMInputBarDelegate? = nil
    
    /// 单例
    static let instance: QMInputBar = {
        let bar = QMInputBar(frame: kInputBarDefaultFrame)
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        self.addSubview(vTopLine)
        self.addSubview(emojiButton)
        
        self.addSubview(textView)
        self.addSubview(placeholderLabel)
        self.addSubview(sendButton)
        
        self.addSubview(vBottomLine)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {

        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            
            var keyboardHeight: CGFloat = endFrame?.size.height ?? 0.0
            
            var edgeInsetTop: CGFloat = 0.0
            
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                keyboardHeight = 0.0
                edgeInsetTop = kInputBarDefaultEdgeInsetTop
            } else {
                keyboardHeight = endFrame?.size.height ?? 0.0
                edgeInsetTop = 0.0
            }
            var f = self.frame
            f.origin.y = kScreenHeight - edgeInsetTop - kInputBarDefaultHeight - keyboardHeight
            
            
            UIView.animateWithDuration(duration,
                                       delay: NSTimeInterval(0),
                                       options: animationCurve,
                                       animations: {
                                            self.frame = f
                                        
                                       },
                                       completion: nil)
        }
    }
    

    
    /// 输入框占位符
    var placeholder: String? = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    var text: String! = "" {
        didSet {
            if text != "" {
                placeholderLabel.hidden = true
                sendButton.enabled = true
            }
            else {
                placeholderLabel.hidden = false
                sendButton.enabled = false
            }
            textView.text = text
        }
    }
    
    var returnKeyType: UIReturnKeyType = .Send {
        didSet {
            textView.returnKeyType = returnKeyType
        }
    }
    
    // MARK: - UI相关
    
    /// 顶部分割线
    private let vTopLine: UIView = {
        let v = UIView(frame: kTopLineViewFrame)
        v.backgroundColor = UIColor.lightGrayColor()
        return v
    }()
    
    /// 底部分割线
    private let vBottomLine: UIView = {
        let v = UIView(frame: kBottomLineViewFrame)
        v.backgroundColor = UIColor.lightGrayColor()
        return v
    }()
    
    /// 点击发送按钮
    private var onClickSendHandler: ((Void) -> Void)? = nil
    
    private var inputBarSizeChangedHandler: ((Void) -> Void)? = nil
    
    private lazy var emojiButton: UIButton = {
        let btn = UIButton(frame: kEmojiButtonFrame)
        
        btn.setImage(UIImage(named: "button_keyboard_emoji"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "button_keyboard_normal"), forState: UIControlState.Selected)
        
        btn.addTarget(self, action: #selector(changeKeyboard(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    
    func changeKeyboard(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected == true {
            print("切换到表情键盘")
            let kb = keyboard
            kb.delegate = self
            textView.inputView = kb
        }
        else {
            print("切换到系统键盘")
            textView.inputView = nil
            // textView.becomeFirstResponder()
            
        }
        textView.reloadInputViews()
    }
    private var keyboard: QMEmoticonsKeyboard = {
        let keyboard = QMEmoticonsKeyboard.instance
//        keyboard.delegate = self
        return QMEmoticonsKeyboard.instance
        
    }()
    
    
    // MARK: - QMEmoticonsKeyboardDelegate
    func emoticonsKeyboard(keyboard: QMEmoticonsKeyboard, didSelectedEmojiView emojiView: QMEmoticonButton) {
        if emojiView.isDelete {
            do{
                var str = textView.text;
                let pattern = "\\[#imgface\\d+#]$";
                let regex = try NSRegularExpression(pattern: pattern, options:NSRegularExpressionOptions.CaseInsensitive)
                let res = regex.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
                if res.count > 0 {
                    str = (str as NSString).stringByReplacingCharactersInRange(res[res.count-1].range, withString: "") as String
                }
                else {
                    print("没有")
                    var string = str as NSString
                    
                    if string.length > 0 {
                        string = string.substringToIndex(string.length-1)
                    }
                    str = string as String

                }
                textView.text = str
                text = str
                print("str: \(str), text: \(text), textView.text: \(textView.text)")
            }catch{
                print(error)
            }

        }
        else {
            textView.text = textView.text + emojiView.imageName
            text = textView.text
        }
        
        
    }
    

    
    private lazy var placeholderLabel: UILabel = {
        let lbl = UILabel(frame: kPlaceholderLabelFrame)
        lbl.font = UIFont.systemFontOfSize(14.0)
        lbl.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        return lbl
    }()
    
    lazy var textView: UITextView = {
        let ttv: UITextView = UITextView(frame: kTextViewFrame)
        ttv.delegate = self
        ttv.returnKeyType = .Send
        ttv.scrollEnabled = false
        ttv.showsVerticalScrollIndicator = false
        ttv.font = UIFont.systemFontOfSize(14.0)
        ttv.enablesReturnKeyAutomatically = true
        ttv.textColor = UIColor(red: 102.0/225.0, green: 102.0/225.0, blue: 102.0/225.0, alpha: 1.0)
        return ttv
    }()
    
    private lazy var sendButton: UIButton = {
        let btn = UIButton(frame: kSendButtonFrame)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        btn.setTitle("发送", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "button_send_enable"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "button_send_disable"), forState: .Selected)
        btn.addTarget(self, action: #selector(onClickSendButton(_:)), forControlEvents: .TouchUpInside)
        btn.enabled = false
        return btn
    }()
    
    /**
     点击发送按钮
     */
    func onClickSendButton(sender: UIButton) {
        delegate?.inputBar?(self, didOnClickSendButton: sender)
    }
    
//    // MARK: - UIKeyInput
//    func deleteBackward() {
//        // TODO:
//    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        text = textView.text
        let maxTextViewHeight: CGFloat = kTextViewHeight * 4
        let textViewFrame = textView.frame
        var constraintSize = CGSizeMake(textViewFrame.size.width, CGFloat.max)
        var textViewSize = textView.sizeThatFits(constraintSize)
        let textViewHeight = textViewSize.height
//        if textViewSize.height <= maxTextViewHeight {
//            textViewSize.height = textViewFrame.size.height
//        }
//        else {
            if textViewSize.height >= maxTextViewHeight {
                textViewSize.height = maxTextViewHeight
                textView.scrollEnabled = true
            }
            else {
                textView.scrollEnabled = false
            }
//        }
        textView.frame = CGRectMake(textViewFrame.origin.x, textViewFrame.origin.y, textViewFrame.size.width, textViewSize.height)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        else {
            return true
        }
    }
}
