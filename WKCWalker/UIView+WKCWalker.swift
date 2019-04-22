//
//  UIView+WKCWalker.swift
//  WKCWalker
//
//  Created by WeiKunChao on 2019/3/27.
//  Copyright © 2019 SecretLisa. All rights reserved.
//
//  链式方式加载动画,以下功能以MARK为分类作划分.
//  本项目会长期维护更新.
//  (1)MAKE类,全部是以中心点为依据的动画.
//  (2)TAKE类,全部以边界点为依据.(此时暂时repeat参数是无效的,待后续处理).
//  (3)MOVE类,相对移动 (以中心点为依据).
//  (4)ADD类,相对移动(以边界为依据).
//  (5)通用是适用于所有类型的动画样式.
//  (6)不使用then参数,同时使用多个动画如makeWith(20).animate(1).makeHeight(20).animate(1)
//  会同时作用; 使用then参数时如makeWith(20).animate(1).then.makeHeight(20).animate(1)
//  会在动画widtha完成后再进行动画height
//  (7)TRANSITION 转场动画.
//
//  注: 如果没有特殊注释,则表示参数适用于所有类型.
//
//
//  The animation is loaded in a chained manner. The following functions are classified by MARK.
//  This project will maintain and update for a long time.
//  (1)MAKE, all based on the animation of the center point.
//  (2)TAKE, all based on the boundary point. (At this time, the temporary repeat parameter is invalid, to be processed later)
//  (3)MOVE, relative movement (based on the center point).
//  (4)ADD, relative movement (based on the boundary).
//  (5)Universal is for all types of animated styles.
//  (6)Do not use the then parameter and use multiple animations at the same time, Such as
//  makeWith(20).animate(1).makeHeight(20).animate(1), Will work at the same time.
//  When using the then parameter, Such as makeWith(20).animate(1).then.makeHeight(20).animate(1)
//  Will be animated height after the animation widtha is completed.
//  (7)Transition animation.
//
//  Note: If there are no special comments, the parameters apply to all types.
//
//

import UIKit
import ObjectiveC.runtime

private var WKCWalkerViewCompletionKey: String = "wkc.view.completion"
private var WKCWalkerViewDelay: String = "wkc.view.delay"
private var WKCWalkerViewRepeat: String = "wkc.view.repeat"
private var WKCWalkerViewReverse: String = "wkc.view.reverse"
private var WKCWalkerViewDuration: String = "wkc.view.duration"
private var WKCWalkerViewFrom: String = "wkc.view.from"
private var WKCWalkerViewTo: String = "wkc.view.to"
private var WKCWalkerViewTheWalker: String = "wkc.view.theWalker"
private var WKCWalkerViewEaseAnimation: String = "wkc.view.ease"
private var WKCWalkerViewSpring: String = "wkc.view.spring"
private var WKCWalkerViewIsTransition: String = "wkc.view.isTransition"
private var WKCWalkerViewTransition: String = "wkc.view.transition"


private enum WKCViewEasy: Int
{
    case easeInOut = 0, easeIn, easeOut, easeLiner
}


extension UIView
{
    private var wkc_view_delay: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewDelay) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewDelay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_view_repeat: Int?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewRepeat) as? Int
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewRepeat, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_view_reverse: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewReverse) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewReverse, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var wkc_view_duration: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewDuration) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewDuration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_view_from: Any?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewFrom)
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewFrom, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var wkc_view_to: Any?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewTo)
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewTo, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var wkc_view_theWalker: WKCWalker?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewTheWalker) as? WKCWalker
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewTheWalker, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_view_ease: WKCViewEasy?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewEaseAnimation) as? WKCViewEasy
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewEaseAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_view_spring: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewSpring) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewSpring, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var wkc_view_isTransition: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewIsTransition) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewIsTransition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var wkc_view_transition: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewTransition) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewTransition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
}

public extension UIView
{
    // MARK: MAKE 全部以中心点为依据
    // Function MAKE, based on the center.
    @discardableResult func makeSize(_ size: CGSize) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeSize
        self.wkc_view_to = size
        return self
    }
    
    @discardableResult func makePosition(_ position: CGPoint) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makePosition
        self.wkc_view_to = position
        return self
    }
    
    @discardableResult func makeX(_ x: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeX
        self.wkc_view_to = x
        return self
    }
    
    @discardableResult func makeY(_ y: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeY
        self.wkc_view_to = y
        return self
    }
    
    @discardableResult func makeWidth(_ width: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeWidth
        self.wkc_view_to = width
        return self
    }
    
    @discardableResult func makeHeight(_ height: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeHeight
        self.wkc_view_to = height
        return self
    }
    
    @discardableResult func makeScale(_ scale: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeScale
        self.wkc_view_to = scale
        return self
    }
    
    @discardableResult func makeScaleX(_ scaleX: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeScaleX
        self.wkc_view_to = scaleX
        return self
    }
    
    @discardableResult func makeScaleY(_ scaleY: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeScaleY
        self.wkc_view_to = scaleY
        return self
    }
    
    @discardableResult func makeRotationX(_ rotationX: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeRotationX
        self.wkc_view_to = rotationX
        return self
    }
    
    @discardableResult func makeRotationY(_ rotationY: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeRotationY
        self.wkc_view_to = rotationY
        return self
    }
    
    @discardableResult func makeRotationZ(_ rotationZ: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeRotationZ
        self.wkc_view_to = rotationZ
        return self
    }
    
    @discardableResult func makeBackground(_ background: UIColor) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeBackground
        self.wkc_view_to = background
        return self
    }
    
    @discardableResult func makeOpacity(_ opacity: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeOpacity
        self.wkc_view_to = opacity
        return self
    }
    
    @discardableResult func makeCornerRadius(_ corner: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeCornerRadius
        self.wkc_view_to = corner
        return self
    }
    
    @discardableResult func makeStorkeEnd(_ storkeEnd: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeStrokeEnd
        self.wkc_view_to = storkeEnd
        return self
    }
    
    @discardableResult func makeContent(_ from: Any, _ to: Any) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeContent
        self.wkc_view_from = from
        self.wkc_view_to = to
        return self
    }
    
    @discardableResult func makeBorderWidth(_ borderWidth: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeBorderWidth
        self.wkc_view_to = borderWidth
        return self
    }
    
    @discardableResult func makeShadowColor(_ shadowColor: UIColor) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeShadowColor
        self.wkc_view_to = shadowColor
        return self
    }
    
    @discardableResult func makeShadowOffset(_ shadowOffset: CGSize) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeShadowOffset
        self.wkc_view_to = shadowOffset
        return self
    }
    
    @discardableResult func makeShadowOpacity(_ shadowOpacity: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeShadowOpacity
        self.wkc_view_to = shadowOpacity
        return self
    }
    
    @discardableResult func makeShadowRadius(_ shadowRadius: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.makeShadowRadius
        self.wkc_view_to = shadowRadius
        return self
    }
    
    
    
    
    
    
    // MARK: TAKE 全部以边界点为依据 (repeat无效)
    // Function TAKE, based on the boundary (parameter repeat is unavailable).
    @discardableResult func takeFrame(_ rect: CGRect) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.takeFrame
        self.wkc_view_to = rect
        return self
    }
    
    @discardableResult func takeLeading(_ leading: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.takeLeading
        self.wkc_view_to = leading
        return self
    }
    
    @discardableResult func takeTraing(_ traing: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.takeTraing
        self.wkc_view_to = traing
        return self
    }
    
    @discardableResult func takeTop(_ top: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.takeTop
        self.wkc_view_to = top
        return self
    }
    
    @discardableResult func takeBottom(_ bottom: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.takeBottom
        self.wkc_view_to = bottom
        return self
    }
    
    @discardableResult func takeWidth(_ width: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.takeWidth
        self.wkc_view_to = width
        return self
    }
    
    @discardableResult func takeHeight(_ height: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.takeHeight
        self.wkc_view_to = height
        return self
    }
    
    @discardableResult func takeSize(_ size: CGSize) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.takeSize
        self.wkc_view_to = size
        return self
    }
    
    
    
    
    
    
    
    
    // MARK: MOVE 相对移动 (以中心点为依据)
    // Function MOVE , relative movement (based on the center).
    @discardableResult func moveX(_ x: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.moveX
        self.wkc_view_to = x
        return self
    }
    
    @discardableResult func moveY(_ y: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.moveY
        self.wkc_view_to = y
        return self
    }
    
    @discardableResult func moveXY(_ xy: CGPoint) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.moveXY
        self.wkc_view_to = xy
        return self
    }
    
    @discardableResult func moveWidth(_ width: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.moveWidth
        self.wkc_view_to = width
        return self
    }
    
    @discardableResult func moveHeight(_ height: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.moveHeight
        self.wkc_view_to = height
        return self
    }
    
    @discardableResult func moveSize(_ size: CGSize) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.moveSize
        self.wkc_view_to = size
        return self
    }
    
    
    
    
    
    
    
    // MARK: ADD 相对移动(以边界为依据) (repeat无效)
    // Function ADD , relative movement (based on the boundary). (parameter repeat is unavailable).
    @discardableResult func addLeading(_ leading: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.addLeading
        self.wkc_view_to = leading
        return self
    }
    
    @discardableResult func addTraing(_ traing: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.addTraing
        self.wkc_view_to = traing
        return self
    }
    
    @discardableResult func addTop(_ top: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.addTop
        self.wkc_view_to = top
        return self
    }
    
    @discardableResult func addBottom(_ bottom: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.addBottom
        self.wkc_view_to = bottom
        return self
    }
    
    @discardableResult func addWidth(_ width: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.addWidth
        self.wkc_view_to = width
        return self
    }
    
    @discardableResult func addHeight(_ height: CGFloat) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.addHeight
        self.wkc_view_to = height
        return self
    }
    
    @discardableResult func addSize(_ size: CGSize) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.addSize
        self.wkc_view_to = size
        return self
    }
    
    
    
    
    
    
    // MARK: TRANSITION 转场动画
    // Transition animation
    @discardableResult func transitionDir(_ dir: WKCWalkerTransitionDirection) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.transition
        self.wkc_view_to = dir
        return self
    }
    
    @discardableResult func transitionFrom(_ from: Any, _ to: Any) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.transition
        self.wkc_view_from = from
        self.wkc_view_to = to
        self.wkc_view_isTransition! = true
        return self
    }
    
    
    
    
    
    // MARK: PATH 轨迹动画
    // Path animation
    @discardableResult func path(_ apath: UIBezierPath) -> UIView
    {
        self.wkc_view_theWalker = WKCWalker.path
        self.wkc_view_to = apath
        return self
    }
    
    
    
    
    
    
    
    
    // MARK: 通用属性
    // Content, general propertys
    @discardableResult func delay(_ adelay: TimeInterval) -> UIView
    {
        self.wkc_view_delay = adelay
        return self
    }
    
    // 注: repeat对TAKE和ADD无效
    // NOTE: repeat is unavailable for TAKE and ADD
    @discardableResult func repeatNumber(_ re: Int) -> UIView
    {
        self.wkc_view_repeat = re
        return self
    }
    
    @discardableResult func reverses(_ isrecerses: Bool) -> UIView
    {
        self.wkc_view_reverse = isrecerses
        return self
    }
    
    @discardableResult func animate(_ duration: TimeInterval) -> UIView
    {
        self.wkc_view_duration = duration
        self.wkc_startWalker()
        return self
    }
    
    
    var completion: WKCWalkerCompletion {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerViewCompletionKey) as! WKCWalkerCompletion
        }
        set {
            objc_setAssociatedObject(self, &WKCWalkerViewCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    
    
    // MARK: 动画样式
    // animated style
    var easeInOut: UIView {
        self.wkc_view_ease = WKCViewEasy.easeInOut
        self.wkc_view_transition = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var easeIn: UIView {
        self.wkc_view_ease = WKCViewEasy.easeIn
        self.wkc_view_transition = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var easeOut: UIView {
        self.wkc_view_ease = WKCViewEasy.easeOut
        self.wkc_view_transition = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    var easeLiner: UIView {
        self.wkc_view_ease = WKCViewEasy.easeLiner
        self.wkc_view_transition = UIView.AnimationOptions.curveLinear
        return self
    }
    
    
    
    
    
    // MARK: 弹性
    // bounce
    var spring: UIView {
        self.wkc_view_spring = true
        return self
    }
    
    
    
    
    // MARK: 转场动画样式 (只适用于TRANSITION, spring无效. 其他通过layer去操作)
    // Transition animation style (only for TRANSITION, spring is unavailable, Others operate through the layer)
    var transitionFlipFromLeft: UIView {
        self.wkc_view_transition = UIView.AnimationOptions.transitionFlipFromLeft
        self.wkc_view_theWalker = WKCWalker.transition
        return self
    }
    
    var transitionFlipFromRight: UIView {
        self.wkc_view_transition = UIView.AnimationOptions.transitionFlipFromRight
        self.wkc_view_theWalker = WKCWalker.transition
        return self
    }
    
    var transitionCurlUp: UIView {
        self.wkc_view_transition = UIView.AnimationOptions.transitionCurlUp
        self.wkc_view_theWalker = WKCWalker.transition
        return self
    }
    
    var transitionCurlDown: UIView {
        self.wkc_view_transition = UIView.AnimationOptions.transitionCurlDown
        self.wkc_view_theWalker = WKCWalker.transition
        return self
    }
    
    var transitionCrossDissolve: UIView {
        self.wkc_view_transition = UIView.AnimationOptions.transitionCrossDissolve
        self.wkc_view_theWalker = WKCWalker.transition
        return self
    }
    
    var transitionFlipFromTop: UIView {
        self.wkc_view_transition = UIView.AnimationOptions.transitionFlipFromTop
        self.wkc_view_theWalker = WKCWalker.transition
        return self
    }
    
    var transitionFlipFromBottom: UIView {
        self.wkc_view_transition = UIView.AnimationOptions.transitionFlipFromBottom
        self.wkc_view_theWalker = WKCWalker.transition
        return self
    }
    
    
    
    // MARK: 关联动画,then以后前一个完成后才完成第二个
    //Associated animation, after the previous one is completed, then the second animate.
    var then: UIView {
        self.wkc_view_delay = self.wkc_view_duration
        return self
    }
    
    
    func removeWalkers()
    {
        self.layer.removeWalkers()
    }
    
    func reloadWalker()
    {
        self.layer.reloadWalker()
    }
    
    private func wkc_initParms()
    {
        if self.wkc_view_delay == nil
        {
            self.wkc_view_delay = 0.0
        }
        
        if self.wkc_view_repeat == nil
        {
            self.wkc_view_repeat = 1
        }
        
        if self.wkc_view_reverse == nil
        {
            self.wkc_view_reverse = false
        }
        
        if self.wkc_view_duration == nil
        {
            self.wkc_view_duration = 0.25
        }
        
        if self.wkc_view_theWalker == nil
        {
            self.wkc_view_theWalker = WKCWalker.makePosition
        }
        
        if self.wkc_view_ease == nil
        {
            self.wkc_view_ease = WKCViewEasy.easeLiner
        }
        
        if self.wkc_view_spring == nil
        {
            self.wkc_view_spring = false
        }
        
        if self.wkc_view_isTransition == nil
        {
            self.wkc_view_isTransition = false
        }
        
        if self.wkc_view_transition == nil
        {
            self.wkc_view_transition = UIView.AnimationOptions.curveLinear
        }
    }
    
    private func wkc_startWalker()
    {
        self.superview?.layoutIfNeeded()
        self.wkc_initParms()
        
        switch self.wkc_view_theWalker!
        {
        case WKCWalker.makeSize:
        
            if self.wkc_view_ease! == WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease! == WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease! == WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease! == WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
        case WKCWalker.makePosition:
            
            if self.wkc_view_ease! == WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease! == WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease! == WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease! == WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        case WKCWalker.makeX:
            
            if self.wkc_view_ease! == WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case WKCWalker.makeY:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
           
        case WKCWalker.makeWidth:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case WKCWalker.makeHeight:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.makeScale:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.makeScaleX:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        case WKCWalker.makeScaleY:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case WKCWalker.makeRotationX:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.makeRotationY:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.makeRotationZ:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
         
        case WKCWalker.makeBackground:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case WKCWalker.makeOpacity:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.makeCornerRadius:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
            
            
        case WKCWalker.makeStrokeEnd:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
            
            
        case WKCWalker.makeContent:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to, let value2 = self.wkc_view_from
                    {
                        self.layer.makeContent(value2, value).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to, let value2 = self.wkc_view_from
                    {
                        self.layer.makeContent(value2, value).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to, let value2 = self.wkc_view_from
                    {
                        self.layer.makeContent(value2, value).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to, let value2 = self.wkc_view_from
                    {
                        self.layer.makeContent(value2, value).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to, let value2 = self.wkc_view_from
                    {
                        self.layer.makeContent(value2, value).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to, let value2 = self.wkc_view_from
                    {
                        self.layer.makeContent(value2, value).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to, let value2 = self.wkc_view_from
                    {
                        self.layer.makeContent(value2, value).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to, let value2 = self.wkc_view_from
                    {
                        self.layer.makeContent(value2, value).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
            
        case WKCWalker.makeBorderWidth:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
          
            
        case WKCWalker.makeShadowColor:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.makeShadowOffset:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case WKCWalker.makeShadowOpacity:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.makeShadowRadius:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.takeFrame:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
           
        case WKCWalker.takeLeading:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.takeTraing:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.takeTop:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        case WKCWalker.takeBottom:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.takeWidth:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.takeHeight:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.takeSize:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.moveX:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.moveY:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.moveXY:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.moveWidth:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case WKCWalker.moveHeight:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.moveSize:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.addLeading:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.addTraing:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.addTop:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.addBottom:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case WKCWalker.addWidth:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case WKCWalker.addHeight:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
            
        case WKCWalker.addSize:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeInOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeIn.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeOut.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeLiner.delay(self.wkc_view_delay!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case WKCWalker.transition:
            
            if self.wkc_view_reverse!
            {
                if self.wkc_view_transition == UIView.AnimationOptions.transitionFlipFromLeft
                {
                    self.wkc_view_transition = [UIView.AnimationOptions.transitionFlipFromLeft, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.wkc_view_transition == UIView.AnimationOptions.transitionFlipFromRight
                {
                    self.wkc_view_transition = [UIView.AnimationOptions.transitionFlipFromRight, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.wkc_view_transition == UIView.AnimationOptions.transitionFlipFromTop
                {
                    self.wkc_view_transition = [UIView.AnimationOptions.transitionFlipFromTop, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.wkc_view_transition == UIView.AnimationOptions.transitionFlipFromBottom
                {
                    self.wkc_view_transition = [UIView.AnimationOptions.transitionFlipFromBottom, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.wkc_view_transition == UIView.AnimationOptions.transitionCurlUp
                {
                    self.wkc_view_transition = [UIView.AnimationOptions.transitionCurlUp, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.wkc_view_transition == UIView.AnimationOptions.transitionCurlDown
                {
                    self.wkc_view_transition = [UIView.AnimationOptions.transitionCurlDown, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.wkc_view_transition == UIView.AnimationOptions.transitionCrossDissolve
                {
                    self.wkc_view_transition = [UIView.AnimationOptions.transitionCrossDissolve, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
            {
                if self.wkc_view_isTransition!
                {
                    UIView.transition(from: self,
                                      to: self.wkc_view_to as! UIView,
                                      duration: self.wkc_view_duration!,
                                      options: self.wkc_view_transition!,
                                      completion: { (success) in
                        self.wkc_view_isTransition! = false
                        if let value = self.completion
                        {
                            value(WKCWalker.transition)
                        }
                    })
                }
                else
                {
                    UIView.transition(with: self,
                                      duration: self.wkc_view_duration!,
                                      options: self.wkc_view_transition!,
                                      animations: nil,
                                      completion: { (success) in
                                        self.wkc_view_isTransition! = false
                                        if let value = self.completion
                                        {
                                            value(WKCWalker.transition)
                                        }
                    })
                }
            }
            
        case WKCWalker.path:
            
            if self.wkc_view_ease != WKCViewEasy.easeInOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeInOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease != WKCViewEasy.easeIn
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeIn.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease! == WKCViewEasy.easeOut
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeOut.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.wkc_view_ease! == WKCViewEasy.easeLiner
            {
                if self.wkc_view_spring!
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).spring.animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.wkc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeLiner.delay(self.wkc_view_delay!).repeatNumber(self.wkc_view_repeat!).reverses(self.wkc_view_reverse!).animate(self.wkc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        }
    }
}
