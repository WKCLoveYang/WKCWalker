//
//  SLCWalkerItemCell.swift
//  SLCWalkerDemo
//
//  Created by WeiKunChao on 2019/4/11.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import SLCWalker


class SLCWalkerItemCell: UICollectionViewCell
{
    static var itemSize: CGSize {
        let width: CGFloat = floor((UIScreen.main.bounds.width - 20 * 2 - 10 * 2) / 3.0)
        return CGSize(width: width, height: width)
    }
    
    private lazy var testView: UIView = {
        let test: UIView = UIView()
        test.backgroundColor = UIColor.red
        return test
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        contentView.layer.borderWidth = 2
        
        contentView.addSubview(testView)
        
        testView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 50, height: 50))
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var walker: SLCWalker? {
        willSet {
            if let n = newValue {
                switch n
                {
                case .makeSize:
                    testView.makeSize(CGSize(width: 80, height: 80)).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makePosition:
                    testView.makePosition(CGPoint(x: 25, y: 25)).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeX:
                    testView.makeX(80).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeY:
                    testView.makeY(80).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeWidth:
                    testView.makeWidth(80).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeHeight:
                    testView.makeHeight(80).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeScale:
                    testView.makeScale(0.5).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeScaleX:
                    testView.makeScaleX(0.5).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeScaleY:
                    testView.makeScaleY(0.5).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeRotationX:
                    testView.makeRotationX(CGFloat.pi * 2).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeRotationY:
                    testView.makeRotationY(CGFloat.pi * 2).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeRotationZ:
                    testView.makeRotationZ(CGFloat.pi * 2).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeBackground:
                    testView.makeBackground(UIColor.blue).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeOpacity:
                    testView.makeOpacity(0.2).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeCornerRadius:
                    testView.makeCornerRadius(8).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .makeBorderWidth:
                    testView.makeBorderWidth(5).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                    
                    
                case .takeFrame:
                    testView.takeFrame(CGRect(x: 20, y: 20, width: 30, height: 30)).reverses(true).animate(1)
                case .takeLeading:
                    testView.takeLeading(0).reverses(true).animate(1)
                case .takeTraing:
                    testView.takeTraing(50).reverses(true).animate(1)
                case .takeTop:
                    testView.takeTop(50).reverses(true).animate(1)
                case .takeBottom:
                    testView.takeBottom(80).reverses(true).animate(1)
                case .takeWidth:
                    testView.takeWidth(80).reverses(true).animate(1)
                case .takeHeight:
                    testView.takeHeight(80).reverses(true).animate(1)
                case .takeSize:
                    testView.takeSize(CGSize(width: 80, height: 80)).reverses(true).animate(1)
                    
                    
                case .moveX:
                    testView.moveX(-20).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .moveY:
                    testView.moveY(-20).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .moveXY:
                    testView.moveXY(CGPoint(x: -20, y: -20)).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .moveWidth:
                    testView.moveWidth(-20).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .moveHeight:
                    testView.moveHeight(-20).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                case .moveSize:
                    testView.moveSize(CGSize(width: -20, height: -20)).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
                    
                case .addLeading:
                    testView.addLeading(-20).reverses(true).animate(1)
                case .addTraing:
                    testView.addTraing(-20).reverses(true).animate(1)
                case .addTop:
                    testView.addTop(-20).reverses(true).animate(1)
                case .addBottom:
                    testView.addBottom(-20).reverses(true).animate(1)
                case .addWidth:
                    testView.addWidth(-20).reverses(true).animate(1)
                case .addHeight:
                    testView.addHeight(-20).reverses(true).animate(1)
                case .addSize:
                    testView.addSize(CGSize(width: -20, height: -20)).reverses(true).animate(1)
                    
                    
                default:
                    break
                }
            }
        }
    }
}
