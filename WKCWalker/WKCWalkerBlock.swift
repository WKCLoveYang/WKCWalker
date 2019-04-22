//
//  WKCWalkerBlock.swift
//  WKCWalker
//
//  Created by WeiKunChao on 2019/3/25.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit

public let WKCWalkerMax: Int = Int.max

public enum WKCWalker: Int
{
    case makeSize = 0,
    makePosition,
    makeX,
    makeY,
    makeWidth,
    makeHeight,
    makeScale,
    makeScaleX,
    makeScaleY,
    makeRotationX,
    makeRotationY,
    makeRotationZ,
    makeBackground,
    makeOpacity,
    makeCornerRadius,
    makeStrokeEnd,
    makeContent,
    makeBorderWidth,
    makeShadowColor,
    makeShadowOffset,
    makeShadowOpacity,
    makeShadowRadius,
    
    takeFrame,
    takeLeading,
    takeTraing,
    takeTop,
    takeBottom,
    takeWidth,
    takeHeight,
    takeSize,
    
    moveX,
    moveY,
    moveXY,
    moveWidth,
    moveHeight,
    moveSize,
    
    addLeading,
    addTraing,
    addTop,
    addBottom,
    addWidth,
    addHeight,
    addSize,
    
    transition,
    path
}

public typealias WKCWalkerTransitionDirection = CATransitionSubtype
public typealias WKCWalkerTransitionType = CATransitionType

public typealias WKCWalkerCompletion = ((WKCWalker) -> Void)?
public typealias WKCWalkerVoidCompletion = (() -> Void)?



