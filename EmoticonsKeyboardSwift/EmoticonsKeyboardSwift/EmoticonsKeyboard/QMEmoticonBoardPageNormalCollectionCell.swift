//
//  QMEmoticonBoardPageNormalCollectionCell.swift
//  EmoticonsKeyboardSwift
//
//  Created by QingMingZhang on 16/9/9.
//  Copyright © 2016年 极客栈. All rights reserved.
//

import UIKit

private let kScreenBounds = UIScreen.mainScreen().bounds
private let kScreenSize   = kScreenBounds.size
private let kScreenWidth  = kScreenSize.width
private let kScreenHeight = kScreenSize.height

private let kEmoticonCellHeight: CGFloat = 165.0

let kQMEmoticonBoardPageNormalCollectionCellReuseIdentifier = "QMEmoticonBoardPageNormalCollectionCell"

@objc protocol QMEmoticonBoardPageNormalCollectionCellDelegate: NSObjectProtocol {
    optional func didSelectedEmojiView(emojiView: QMEmoticonButton)
}

class QMEmoticonBoardPageNormalCollectionCell: UICollectionViewCell {
    
    var indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0) {
        didSet {
            configureSubviews()
        }
    }
    var images: [String] = [String]()
    var datasource: [NSDictionary] = [NSDictionary]()
    var delegate: QMEmoticonBoardPageNormalCollectionCellDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
//        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        self.contentView.subviews.forEach { $0.removeFromSuperview() }

        let lineCount: Int = 3
        var columnCount: Int = 7
//        if kScreenWidth == 320.0 {
//            columnCount = 7
//        }
//        else if kScreenWidth == 375.0 {
//            columnCount = 8
//        }
//        else if kScreenWidth == 414.0 {
//            columnCount = 9
//        }
        
        let itemWH: CGFloat = 30.0
        let edgeDistance: CGFloat = 10.0
        
        let vMargin: CGFloat = (kEmoticonCellHeight - CGFloat(lineCount)*itemWH) / CGFloat(lineCount + 1)
        let hMargin: CGFloat = (kScreenWidth - CGFloat(columnCount)*itemWH - edgeDistance*2) / CGFloat(columnCount)
        
        for i in 0 ..< lineCount {
            for j in 0 ..< columnCount {
                let btn = QMEmoticonButton(type: UIButtonType.Custom)
//                btn.backgroundColor = UIColor.yellowColor()
                btn.backgroundColor = UIColor.whiteColor()
                let btnX = CGFloat(j)*itemWH + edgeDistance + CGFloat(j)*hMargin
                let btnY = CGFloat(i)*itemWH + CGFloat(i+1)*vMargin
                btn.frame = CGRectMake(btnX, btnY, itemWH, itemWH)
                let index = columnCount * lineCount * indexPath.item + i * columnCount + j + 1 - indexPath.item * 1
                var imageName: String = "[#imgface\(index)#]"
//                if index >= images.count {
//                    break
//                }
//                let imageName: String = images[index]
                if i == 2 && j == 6 {
                    print("最后一个\(i+1) - \(j+1)")
                    imageName = "button_delete"
                    btn.isDelete = true
                }
                btn.imageName = imageName
                btn.addTarget(self, action: #selector(didSelectEmoji(_:)), forControlEvents: .TouchUpInside)
                btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
                self.contentView.addSubview(btn)
            }
        }
    }
    func didSelectEmoji(sender: QMEmoticonButton) {
        print("========")
        print("sender: \(sender)")
        print("========")
        delegate?.didSelectedEmojiView?(sender)
    }
    
}
