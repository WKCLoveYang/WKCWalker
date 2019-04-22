//
//  UIView+SLCWalker.swift
//  SLCWalker
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

private var SLCWalkerViewCompletionKey: String = "slc.view.completion"
private var SLCWalkerViewDelay: String = "slc.view.delay"
private var SLCWalkerViewRepeat: String = "slc.view.repeat"
private var SLCWalkerViewReverse: String = "slc.view.reverse"
private var SLCWalkerViewDuration: String = "slc.view.duration"
private var SLCWalkerViewFrom: String = "slc.view.from"
private var SLCWalkerViewTo: String = "slc.view.to"
private var SLCWalkerViewTheWalker: String = "slc.view.theWalker"
private var SLCWalkerViewEaseAnimation: String = "slc.view.ease"
private var SLCWalkerViewSpring: String = "slc.view.spring"
private var SLCWalkerViewIsTransition: String = "slc.view.isTransition"
private var SLCWalkerViewTransition: String = "slc.view.transition"


private enum SLCViewEasy: Int
{
    case easeInOut = 0, easeIn, easeOut, easeLiner
}


extension UIView
{
    private var slc_view_delay: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewDelay) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewDelay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_view_repeat: Int?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewRepeat) as? Int
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewRepeat, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_view_reverse: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewReverse) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewReverse, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var slc_view_duration: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewDuration) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewDuration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_view_from: Any?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewFrom)
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewFrom, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var slc_view_to: Any?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewTo)
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewTo, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var slc_view_theWalker: SLCWalker?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewTheWalker) as? SLCWalker
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewTheWalker, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_view_ease: SLCViewEasy?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewEaseAnimation) as? SLCViewEasy
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewEaseAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_view_spring: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewSpring) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewSpring, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var slc_view_isTransition: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewIsTransition) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewIsTransition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var slc_view_transition: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewTransition) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewTransition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
}

public extension UIView
{
    // MARK: MAKE 全部以中心点为依据
    // Function MAKE, based on the center.
    @discardableResult func makeSize(_ size: CGSize) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeSize
        self.slc_view_to = size
        return self
    }
    
    @discardableResult func makePosition(_ position: CGPoint) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makePosition
        self.slc_view_to = position
        return self
    }
    
    @discardableResult func makeX(_ x: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeX
        self.slc_view_to = x
        return self
    }
    
    @discardableResult func makeY(_ y: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeY
        self.slc_view_to = y
        return self
    }
    
    @discardableResult func makeWidth(_ width: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeWidth
        self.slc_view_to = width
        return self
    }
    
    @discardableResult func makeHeight(_ height: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeHeight
        self.slc_view_to = height
        return self
    }
    
    @discardableResult func makeScale(_ scale: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeScale
        self.slc_view_to = scale
        return self
    }
    
    @discardableResult func makeScaleX(_ scaleX: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeScaleX
        self.slc_view_to = scaleX
        return self
    }
    
    @discardableResult func makeScaleY(_ scaleY: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeScaleY
        self.slc_view_to = scaleY
        return self
    }
    
    @discardableResult func makeRotationX(_ rotationX: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeRotationX
        self.slc_view_to = rotationX
        return self
    }
    
    @discardableResult func makeRotationY(_ rotationY: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeRotationY
        self.slc_view_to = rotationY
        return self
    }
    
    @discardableResult func makeRotationZ(_ rotationZ: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeRotationZ
        self.slc_view_to = rotationZ
        return self
    }
    
    @discardableResult func makeBackground(_ background: UIColor) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeBackground
        self.slc_view_to = background
        return self
    }
    
    @discardableResult func makeOpacity(_ opacity: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeOpacity
        self.slc_view_to = opacity
        return self
    }
    
    @discardableResult func makeCornerRadius(_ corner: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeCornerRadius
        self.slc_view_to = corner
        return self
    }
    
    @discardableResult func makeStorkeEnd(_ storkeEnd: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeStrokeEnd
        self.slc_view_to = storkeEnd
        return self
    }
    
    @discardableResult func makeContent(_ from: Any, _ to: Any) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeContent
        self.slc_view_from = from
        self.slc_view_to = to
        return self
    }
    
    @discardableResult func makeBorderWidth(_ borderWidth: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeBorderWidth
        self.slc_view_to = borderWidth
        return self
    }
    
    @discardableResult func makeShadowColor(_ shadowColor: UIColor) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeShadowColor
        self.slc_view_to = shadowColor
        return self
    }
    
    @discardableResult func makeShadowOffset(_ shadowOffset: CGSize) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeShadowOffset
        self.slc_view_to = shadowOffset
        return self
    }
    
    @discardableResult func makeShadowOpacity(_ shadowOpacity: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeShadowOpacity
        self.slc_view_to = shadowOpacity
        return self
    }
    
    @discardableResult func makeShadowRadius(_ shadowRadius: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.makeShadowRadius
        self.slc_view_to = shadowRadius
        return self
    }
    
    
    
    
    
    
    // MARK: TAKE 全部以边界点为依据 (repeat无效)
    // Function TAKE, based on the boundary (parameter repeat is unavailable).
    @discardableResult func takeFrame(_ rect: CGRect) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.takeFrame
        self.slc_view_to = rect
        return self
    }
    
    @discardableResult func takeLeading(_ leading: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.takeLeading
        self.slc_view_to = leading
        return self
    }
    
    @discardableResult func takeTraing(_ traing: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.takeTraing
        self.slc_view_to = traing
        return self
    }
    
    @discardableResult func takeTop(_ top: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.takeTop
        self.slc_view_to = top
        return self
    }
    
    @discardableResult func takeBottom(_ bottom: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.takeBottom
        self.slc_view_to = bottom
        return self
    }
    
    @discardableResult func takeWidth(_ width: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.takeWidth
        self.slc_view_to = width
        return self
    }
    
    @discardableResult func takeHeight(_ height: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.takeHeight
        self.slc_view_to = height
        return self
    }
    
    @discardableResult func takeSize(_ size: CGSize) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.takeSize
        self.slc_view_to = size
        return self
    }
    
    
    
    
    
    
    
    
    // MARK: MOVE 相对移动 (以中心点为依据)
    // Function MOVE , relative movement (based on the center).
    @discardableResult func moveX(_ x: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.moveX
        self.slc_view_to = x
        return self
    }
    
    @discardableResult func moveY(_ y: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.moveY
        self.slc_view_to = y
        return self
    }
    
    @discardableResult func moveXY(_ xy: CGPoint) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.moveXY
        self.slc_view_to = xy
        return self
    }
    
    @discardableResult func moveWidth(_ width: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.moveWidth
        self.slc_view_to = width
        return self
    }
    
    @discardableResult func moveHeight(_ height: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.moveHeight
        self.slc_view_to = height
        return self
    }
    
    @discardableResult func moveSize(_ size: CGSize) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.moveSize
        self.slc_view_to = size
        return self
    }
    
    
    
    
    
    
    
    // MARK: ADD 相对移动(以边界为依据) (repeat无效)
    // Function ADD , relative movement (based on the boundary). (parameter repeat is unavailable).
    @discardableResult func addLeading(_ leading: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.addLeading
        self.slc_view_to = leading
        return self
    }
    
    @discardableResult func addTraing(_ traing: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.addTraing
        self.slc_view_to = traing
        return self
    }
    
    @discardableResult func addTop(_ top: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.addTop
        self.slc_view_to = top
        return self
    }
    
    @discardableResult func addBottom(_ bottom: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.addBottom
        self.slc_view_to = bottom
        return self
    }
    
    @discardableResult func addWidth(_ width: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.addWidth
        self.slc_view_to = width
        return self
    }
    
    @discardableResult func addHeight(_ height: CGFloat) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.addHeight
        self.slc_view_to = height
        return self
    }
    
    @discardableResult func addSize(_ size: CGSize) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.addSize
        self.slc_view_to = size
        return self
    }
    
    
    
    
    
    
    // MARK: TRANSITION 转场动画
    // Transition animation
    @discardableResult func transitionDir(_ dir: SLCWalkerTransitionDirection) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.transition
        self.slc_view_to = dir
        return self
    }
    
    @discardableResult func transitionFrom(_ from: Any, _ to: Any) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.transition
        self.slc_view_from = from
        self.slc_view_to = to
        self.slc_view_isTransition! = true
        return self
    }
    
    
    
    
    
    // MARK: PATH 轨迹动画
    // Path animation
    @discardableResult func path(_ apath: UIBezierPath) -> UIView
    {
        self.slc_view_theWalker = SLCWalker.path
        self.slc_view_to = apath
        return self
    }
    
    
    
    
    
    
    
    
    // MARK: 通用属性
    // Content, general propertys
    @discardableResult func delay(_ adelay: TimeInterval) -> UIView
    {
        self.slc_view_delay = adelay
        return self
    }
    
    // 注: repeat对TAKE和ADD无效
    // NOTE: repeat is unavailable for TAKE and ADD
    @discardableResult func repeatNumber(_ re: Int) -> UIView
    {
        self.slc_view_repeat = re
        return self
    }
    
    @discardableResult func reverses(_ isrecerses: Bool) -> UIView
    {
        self.slc_view_reverse = isrecerses
        return self
    }
    
    @discardableResult func animate(_ duration: TimeInterval) -> UIView
    {
        self.slc_view_duration = duration
        self.slc_startWalker()
        return self
    }
    
    
    var completion: SLCWalkerCompletion {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewCompletionKey) as! SLCWalkerCompletion
        }
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    
    
    // MARK: 动画样式
    // animated style
    var easeInOut: UIView {
        self.slc_view_ease = SLCViewEasy.easeInOut
        self.slc_view_transition = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var easeIn: UIView {
        self.slc_view_ease = SLCViewEasy.easeIn
        self.slc_view_transition = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var easeOut: UIView {
        self.slc_view_ease = SLCViewEasy.easeOut
        self.slc_view_transition = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    var easeLiner: UIView {
        self.slc_view_ease = SLCViewEasy.easeLiner
        self.slc_view_transition = UIView.AnimationOptions.curveLinear
        return self
    }
    
    
    
    
    
    // MARK: 弹性
    // bounce
    var spring: UIView {
        self.slc_view_spring = true
        return self
    }
    
    
    
    
    // MARK: 转场动画样式 (只适用于TRANSITION, spring无效. 其他通过layer去操作)
    // Transition animation style (only for TRANSITION, spring is unavailable, Others operate through the layer)
    var transitionFlipFromLeft: UIView {
        self.slc_view_transition = UIView.AnimationOptions.transitionFlipFromLeft
        self.slc_view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionFlipFromRight: UIView {
        self.slc_view_transition = UIView.AnimationOptions.transitionFlipFromRight
        self.slc_view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionCurlUp: UIView {
        self.slc_view_transition = UIView.AnimationOptions.transitionCurlUp
        self.slc_view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionCurlDown: UIView {
        self.slc_view_transition = UIView.AnimationOptions.transitionCurlDown
        self.slc_view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionCrossDissolve: UIView {
        self.slc_view_transition = UIView.AnimationOptions.transitionCrossDissolve
        self.slc_view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionFlipFromTop: UIView {
        self.slc_view_transition = UIView.AnimationOptions.transitionFlipFromTop
        self.slc_view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionFlipFromBottom: UIView {
        self.slc_view_transition = UIView.AnimationOptions.transitionFlipFromBottom
        self.slc_view_theWalker = SLCWalker.transition
        return self
    }
    
    
    
    // MARK: 关联动画,then以后前一个完成后才完成第二个
    //Associated animation, after the previous one is completed, then the second animate.
    var then: UIView {
        self.slc_view_delay = self.slc_view_duration
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
    
    private func slc_initParms()
    {
        if self.slc_view_delay == nil
        {
            self.slc_view_delay = 0.0
        }
        
        if self.slc_view_repeat == nil
        {
            self.slc_view_repeat = 1
        }
        
        if self.slc_view_reverse == nil
        {
            self.slc_view_reverse = false
        }
        
        if self.slc_view_duration == nil
        {
            self.slc_view_duration = 0.25
        }
        
        if self.slc_view_theWalker == nil
        {
            self.slc_view_theWalker = SLCWalker.makePosition
        }
        
        if self.slc_view_ease == nil
        {
            self.slc_view_ease = SLCViewEasy.easeLiner
        }
        
        if self.slc_view_spring == nil
        {
            self.slc_view_spring = false
        }
        
        if self.slc_view_isTransition == nil
        {
            self.slc_view_isTransition = false
        }
        
        if self.slc_view_transition == nil
        {
            self.slc_view_transition = UIView.AnimationOptions.curveLinear
        }
    }
    
    private func slc_startWalker()
    {
        self.superview?.layoutIfNeeded()
        self.slc_initParms()
        
        switch self.slc_view_theWalker!
        {
        case SLCWalker.makeSize:
        
            if self.slc_view_ease! == SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease! == SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease! == SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease! == SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
        case SLCWalker.makePosition:
            
            if self.slc_view_ease! == SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease! == SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease! == SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease! == SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        case SLCWalker.makeX:
            
            if self.slc_view_ease! == SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case SLCWalker.makeY:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
           
        case SLCWalker.makeWidth:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case SLCWalker.makeHeight:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.makeScale:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.makeScaleX:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        case SLCWalker.makeScaleY:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case SLCWalker.makeRotationX:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.makeRotationY:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.makeRotationZ:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
         
        case SLCWalker.makeBackground:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case SLCWalker.makeOpacity:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.makeCornerRadius:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
            
            
        case SLCWalker.makeStrokeEnd:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
            
            
        case SLCWalker.makeContent:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to, let value2 = self.slc_view_from
                    {
                        self.layer.makeContent(value2, value).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to, let value2 = self.slc_view_from
                    {
                        self.layer.makeContent(value2, value).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to, let value2 = self.slc_view_from
                    {
                        self.layer.makeContent(value2, value).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to, let value2 = self.slc_view_from
                    {
                        self.layer.makeContent(value2, value).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to, let value2 = self.slc_view_from
                    {
                        self.layer.makeContent(value2, value).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to, let value2 = self.slc_view_from
                    {
                        self.layer.makeContent(value2, value).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to, let value2 = self.slc_view_from
                    {
                        self.layer.makeContent(value2, value).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to, let value2 = self.slc_view_from
                    {
                        self.layer.makeContent(value2, value).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
            
        case SLCWalker.makeBorderWidth:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
          
            
        case SLCWalker.makeShadowColor:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.makeShadowOffset:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case SLCWalker.makeShadowOpacity:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.makeShadowRadius:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.takeFrame:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
           
        case SLCWalker.takeLeading:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.takeTraing:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.takeTop:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        case SLCWalker.takeBottom:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.takeWidth:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.takeHeight:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.takeSize:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.moveX:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.moveY:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.moveXY:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.moveWidth:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case SLCWalker.moveHeight:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.moveSize:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.addLeading:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.addTraing:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.addTop:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.addBottom:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case SLCWalker.addWidth:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case SLCWalker.addHeight:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
            
        case SLCWalker.addSize:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeInOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeIn.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeOut.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.addSize(value as! CGSize).easeLiner.delay(self.slc_view_delay!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case SLCWalker.transition:
            
            if self.slc_view_reverse!
            {
                if self.slc_view_transition == UIView.AnimationOptions.transitionFlipFromLeft
                {
                    self.slc_view_transition = [UIView.AnimationOptions.transitionFlipFromLeft, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.slc_view_transition == UIView.AnimationOptions.transitionFlipFromRight
                {
                    self.slc_view_transition = [UIView.AnimationOptions.transitionFlipFromRight, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.slc_view_transition == UIView.AnimationOptions.transitionFlipFromTop
                {
                    self.slc_view_transition = [UIView.AnimationOptions.transitionFlipFromTop, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.slc_view_transition == UIView.AnimationOptions.transitionFlipFromBottom
                {
                    self.slc_view_transition = [UIView.AnimationOptions.transitionFlipFromBottom, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.slc_view_transition == UIView.AnimationOptions.transitionCurlUp
                {
                    self.slc_view_transition = [UIView.AnimationOptions.transitionCurlUp, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.slc_view_transition == UIView.AnimationOptions.transitionCurlDown
                {
                    self.slc_view_transition = [UIView.AnimationOptions.transitionCurlDown, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if self.slc_view_transition == UIView.AnimationOptions.transitionCrossDissolve
                {
                    self.slc_view_transition = [UIView.AnimationOptions.transitionCrossDissolve, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
            {
                if self.slc_view_isTransition!
                {
                    UIView.transition(from: self,
                                      to: self.slc_view_to as! UIView,
                                      duration: self.slc_view_duration!,
                                      options: self.slc_view_transition!,
                                      completion: { (success) in
                        self.slc_view_isTransition! = false
                        if let value = self.completion
                        {
                            value(SLCWalker.transition)
                        }
                    })
                }
                else
                {
                    UIView.transition(with: self,
                                      duration: self.slc_view_duration!,
                                      options: self.slc_view_transition!,
                                      animations: nil,
                                      completion: { (success) in
                                        self.slc_view_isTransition! = false
                                        if let value = self.completion
                                        {
                                            value(SLCWalker.transition)
                                        }
                    })
                }
            }
            
        case SLCWalker.path:
            
            if self.slc_view_ease != SLCViewEasy.easeInOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeInOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease != SLCViewEasy.easeIn
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeIn.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease! == SLCViewEasy.easeOut
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeOut.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if self.slc_view_ease! == SLCViewEasy.easeLiner
            {
                if self.slc_view_spring!
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).spring.animate(self.slc_view_duration!).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = self.slc_view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeLiner.delay(self.slc_view_delay!).repeatNumber(self.slc_view_repeat!).reverses(self.slc_view_reverse!).animate(self.slc_view_duration!).completion = { atype in
                            
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
