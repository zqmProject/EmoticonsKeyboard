//
//  EmoticonsKeyboard.swift
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
private let kEmoticonsKeyBoardFrame = CGRectMake(0, 0, kScreenWidth, 224.0)

@objc protocol QMEmoticonsKeyboardDelegate: NSObjectProtocol {
    optional func emoticonsKeyboard(keyboard: QMEmoticonsKeyboard, didSelectedEmojiView: QMEmoticonButton)
}

class QMEmoticonsKeyboard: UIView, UICollectionViewDelegate, UICollectionViewDataSource, QMEmoticonBoardPageNormalCollectionCellDelegate {

    
    var delegate: QMEmoticonsKeyboardDelegate? = nil
    
    let section0 = [
        ["icon": "[#imgface1#]", "name": ""],
        ["icon": "[#imgface2#]", "name": ""],
        ["icon": "[#imgface3#]", "name": ""],
        ["icon": "[#imgface4#]", "name": ""],
        ["icon": "[#imgface5#]", "name": ""],
        ["icon": "[#imgface6#]", "name": ""],
        ["icon": "[#imgface7#]", "name": ""],
        ["icon": "[#imgface8#]", "name": ""],
        ["icon": "[#imgface9#]", "name": ""],
        ["icon": "[#imgface10#]", "name": ""],
        ["icon": "[#imgface11#]", "name": ""],
        ["icon": "[#imgface12#]", "name": ""],
        ["icon": "[#imgface13#]", "name": ""],
        ["icon": "[#imgface14#]", "name": ""],
        ["icon": "[#imgface15#]", "name": ""],
        ["icon": "[#imgface16#]", "name": ""],
        ["icon": "[#imgface17#]", "name": ""],
        ["icon": "[#imgface18#]", "name": ""],
        ["icon": "[#imgface19#]", "name": ""],
        ["icon": "[#imgface20#]", "name": ""],
        ["icon": "[#imgface21#]", "name": ""],
        ["icon": "[#imgface22#]", "name": ""],
        ["icon": "[#imgface23#]", "name": ""],
        ["icon": "[#imgface24#]", "name": ""],
        ["icon": "[#imgface25#]", "name": ""],
        ["icon": "[#imgface26#]", "name": ""],
        ["icon": "[#imgface27#]", "name": ""],
        ["icon": "[#imgface28#]", "name": ""],
        ["icon": "[#imgface29#]", "name": ""],
        ["icon": "[#imgface30#]", "name": ""],
        ["icon": "[#imgface31#]", "name": ""],
        ["icon": "[#imgface32#]", "name": ""],
        ["icon": "[#imgface33#]", "name": ""],
        ["icon": "[#imgface34#]", "name": ""],
        ["icon": "[#imgface35#]", "name": ""],
        ["icon": "[#imgface36#]", "name": ""],
        ["icon": "[#imgface37#]", "name": ""],
        ["icon": "[#imgface38#]", "name": ""],
        ["icon": "[#imgface39#]", "name": ""],
        ["icon": "[#imgface40#]", "name": ""],
        ["icon": "[#imgface41#]", "name": ""],
        ["icon": "[#imgface42#]", "name": ""],
        ["icon": "[#imgface43#]", "name": ""],
        ["icon": "[#imgface44#]", "name": ""],
        ["icon": "[#imgface45#]", "name": ""],
        ["icon": "[#imgface46#]", "name": ""],
        ["icon": "[#imgface47#]", "name": ""],
        ["icon": "[#imgface48#]", "name": ""],
        ["icon": "[#imgface49#]", "name": ""],
        ["icon": "[#imgface50#]", "name": ""],
        ["icon": "[#imgface51#]", "name": ""],
        ["icon": "[#imgface52#]", "name": ""],
        ["icon": "[#imgface53#]", "name": ""],
        ["icon": "[#imgface54#]", "name": ""],
        ["icon": "[#imgface55#]", "name": ""],
        ["icon": "[#imgface56#]", "name": ""],
        ["icon": "[#imgface57#]", "name": ""],
        ["icon": "[#imgface58#]", "name": ""],
        ["icon": "[#imgface59#]", "name": ""],
        ["icon": "[#imgface60#]", "name": ""],
        ["icon": "[#imgface61#]", "name": ""],
        ["icon": "[#imgface62#]", "name": ""],
        ["icon": "[#imgface63#]", "name": ""],
        ["icon": "[#imgface64#]", "name": ""],
        ["icon": "[#imgface65#]", "name": ""],
        ["icon": "[#imgface66#]", "name": ""],
        ["icon": "[#imgface67#]", "name": ""],
        ["icon": "[#imgface68#]", "name": ""],
        ["icon": "[#imgface69#]", "name": ""],
        ["icon": "[#imgface70#]", "name": ""],
        ["icon": "[#imgface71#]", "name": ""],
        ["icon": "[#imgface72#]", "name": ""],
        ["icon": "[#imgface73#]", "name": ""],
        ["icon": "[#imgface74#]", "name": ""],
        ["icon": "[#imgface75#]", "name": ""],
        ["icon": "[#imgface76#]", "name": ""],
        ["icon": "[#imgface77#]", "name": ""],
        ["icon": "[#imgface78#]", "name": ""],
        ["icon": "[#imgface79#]", "name": ""],
        ["icon": "[#imgface80#]", "name": ""]
        ]
    
    var dataSources:[AnyObject] = [AnyObject]()
    
    
    static let instance: QMEmoticonsKeyboard = {
        let kb = QMEmoticonsKeyboard(frame: kEmoticonsKeyBoardFrame)
        return kb
    }()
    
    var textView: UITextView? = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        var string = ""
//        for index in 1 ..< 81 {
//            string += "[\"icon\": \"[#imgface\(index)#]\", \"name\": \"\"],\n"
//        }
//        print(string)
        self.dataSources.append(["datasource": section0, "title": "自定义"])
        self.configureSubviews()
    }
    
    lazy var collectionView: UICollectionView = {
    
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(kScreenWidth, 165.0)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.scrollDirection = .Horizontal
        let clv = UICollectionView(frame: CGRectMake(0, 0, kScreenWidth, 165.0), collectionViewLayout: flowLayout)
        clv.backgroundColor = UIColor.whiteColor()
        clv.pagingEnabled = true
        clv.showsVerticalScrollIndicator = true
        clv.showsHorizontalScrollIndicator = false
        clv.delegate = self
        clv.dataSource = self
        
        
        clv.registerClass(QMEmoticonBoardPageNormalCollectionCell.self, forCellWithReuseIdentifier: kQMEmoticonBoardPageNormalCollectionCellReuseIdentifier)
        return clv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        self.addSubview(collectionView)
    }
    
    
    // MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSources.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let lineCount: Int = 3
        var columnCount: Int = 8
        if kScreenWidth == 320.0 {
            columnCount = 7
        }
        else if kScreenWidth == 375.0 {
            columnCount = 8
        }
        else if kScreenWidth == 414.0 {
            columnCount = 9
        }
        let s0 = dataSources[section] as! NSDictionary
        let count = (s0["datasource"] as! [AnyObject]).count ?? 0
        return count / (lineCount * columnCount) + (count % (lineCount * columnCount) > 0 ? 1: 0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kQMEmoticonBoardPageNormalCollectionCellReuseIdentifier, forIndexPath: indexPath) as! QMEmoticonBoardPageNormalCollectionCell
        cell.indexPath = indexPath
        let datasource = dataSources[indexPath.section] as! NSDictionary
        let sss = (datasource["datasource"] as! [NSDictionary])
//        cell.images =
        print(sss)
        cell.delegate = self
        return cell
    }
    
    // MARK: - QMEmoticonBoardPageNormalCollectionCellDelegate    
    func didSelectedEmojiView(emojiView: QMEmoticonButton) {
        delegate?.emoticonsKeyboard?(self, didSelectedEmojiView: emojiView)
    }
    
    
    // MARK: -
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
