//
//  CALayer+WKCWalker.swift
//  WKCWalker
//
//  Created by WeiKunChao on 2019/3/25.
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


private func wkc_baseWalker(keyPath: String,
                    duration: TimeInterval,
                    repeatCount: Float,
                    delay: TimeInterval,
                    autoreverses: Bool,
                    timing: CAMediaTimingFunctionName,
                    from: Any?,
                    to: Any?) -> CABasicAnimation
{
    let base: CABasicAnimation = CABasicAnimation(keyPath: keyPath)
    base.isRemovedOnCompletion = false
    base.duration = duration
    base.repeatCount = repeatCount
    base.fillMode = CAMediaTimingFillMode.forwards
    base.beginTime = CACurrentMediaTime() + delay
    base.timingFunction = CAMediaTimingFunction(name: timing)
    base.autoreverses = autoreverses
    base.fromValue = from
    base.toValue = to
    return base
}

private func wkc_springWalker(keyPath: String,
                              duration: TimeInterval,
                              repeatCount: Float,
                              delay: TimeInterval,
                              autoreverses: Bool,
                              timing: CAMediaTimingFunctionName,
                              from: Any?,
                              to: Any?) -> CASpringAnimation
{
    let spring: CASpringAnimation = CASpringAnimation(keyPath: keyPath)
    spring.isRemovedOnCompletion = false
    spring.duration = duration
    spring.repeatCount = repeatCount
    spring.fillMode = CAMediaTimingFillMode.forwards
    spring.beginTime = CACurrentMediaTime() + delay
    spring.timingFunction = CAMediaTimingFunction(name: timing)
    spring.autoreverses = autoreverses
    spring.fromValue = from
    spring.toValue = to
    spring.mass = 1.0
    spring.stiffness = 100
    spring.damping = 10
    spring.initialVelocity = 10
    return spring
}

private func wkc_keyframeWalker(keyPath: String,
                                duration: TimeInterval,
                                repeatCount: Float,
                                delay: TimeInterval,
                                autoreverses: Bool,
                                timing: CAMediaTimingFunctionName,
                                path: CGPath?) -> CAKeyframeAnimation
{
    let keyframe: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: keyPath)
    keyframe.isRemovedOnCompletion = false
    keyframe.duration = duration
    keyframe.repeatCount = repeatCount
    keyframe.fillMode = CAMediaTimingFillMode.forwards
    keyframe.beginTime = CACurrentMediaTime() + delay
    keyframe.timingFunction = CAMediaTimingFunction(name: timing)
    keyframe.autoreverses = autoreverses
    keyframe.path = path
    return keyframe
}

private func wkc_transitionWalker(duration: TimeInterval,
                                  timing: CAMediaTimingFunctionName,
                                  type: WKCWalkerTransitionType,
                                  direction: WKCWalkerTransitionDirection,
                                  repeatCount: Float,
                                  delay: TimeInterval,
                                  autoreverses: Bool) -> CATransition
{
    let transition: CATransition = CATransition()
    transition.duration = duration
    transition.timingFunction = CAMediaTimingFunction(name: timing)
    transition.type = type
    transition.subtype = direction
    transition.repeatCount = repeatCount
    transition.beginTime = CACurrentMediaTime() + delay
    transition.autoreverses = autoreverses
    return transition
}


private var WKCWalkerCompletionKey: String = "wkc.completion"
private var WKCWalkerAnimationType: String = "wkc.layer.animationType"
private var WKCWalkerLayerTiming: String = "wkc.layer.timing"
private var WKCWalkerLayerOptions: String = "wkc.layer.options"
private var WKCWalkerLayerDelay: String = "wkc.layer.delay"
private var WKCWalkerLayerRepeat: String = "wkc.layer.repeat"
private var WKCWalkerLayerReverse: String = "wkc.layer.reverse"
private var WKCWalkerLayerIsCaanimation: String = "wkc.layer.iscaanimat"
private var WKCWalkerLayerAnimateDuration: String = "wkc.layer.duration"
private var WKCWalkerLayerKeyPath: String = "wkc.layer.keyPath"
private var WKCWalkerLayerFrom: String = "wkc.layer.from"
private var WKCWalkerLayerTo: String = "wkc.layer.to"
private var WKCWalkerLayerFrameKeyPath: String = "wkc.layer.frame.keypath"
private var WKCWalkerLayerWalker: String = "wkc.layer.walker"
private var WKCWalkerLayerTransition: String = "wkc.layer.transition"
private var WKCWalkerLayerFrameOrigin: String = "wkc.layer.frame.origin"

private let WKCWalkerKeyPathPosition: String = "position"
private let WKCWalkerKeyPathPositionX: String = "position.x"
private let WKCWalkerKeyPathPositionY: String = "position.y"
private let WKCWalkerKeyPathWidth: String = "bounds.size.width"
private let WKCWalkerKeyPathHeight: String = "bounds.size.height"
private let WKCWalkerKeyPathSize: String = "bounds.size"
private let WKCWalkerKeyPathScale: String = "transform.scale"
private let WKCWalkerKeyPathScaleX: String = "transform.scale.x"
private let WKCWalkerKeyPathScaleY: String = "transform.scale.y"
private let WKCWalkerKeyPathRotationX: String = "transform.rotation.x"
private let WKCWalkerKeyPathRotationY: String = "transform.rotation.y"
private let WKCWalkerKeyPathRotationZ: String = "transform.rotation.z"
private let WKCWalkerKeyPathBackground: String = "backgroundColor"
private let WKCWalkerKeyPathOpacity: String = "opacity"
private let WKCWalkerKeyPathCornerRadius: String = "cornerRadius"
private let WKCWalkerKeyPathStrokeEnd: String = "strokeEnd"
private let WKCWalkerKeyPathContent: String = "contents"
private let WKCWalkerKeyPathBorderWidth: String = "borderWidth"
private let WKCWalkerKeyPathShadowColor: String = "shadowColor"
private let WKCWalkerKeyPathShadowOffset: String = "shadowOffset"
private let WKCWalkerKeyPathShadowOpacity: String = "shadowOpacity"
private let WKCWalkerKeyPathShadowRadius: String = "shadowRadius"

private let UIViewWalkerKeyFrame: String = "wkc.take.frame"
private let UIViewWalkerKeyLeading: String = "wkc.take.leading"
private let UIViewWalkerKeyTraing: String = "wkc.take.traing"
private let UIViewWalkerKeyTop: String = "wkc.take.top"
private let UIViewWalkerKeyBottom: String = "wkc.take.bottom"
private let UIViewWalkerKeyWidth: String = "wkc.take.width"
private let UIViewWalkerKeyHeight: String = "wkc.take.height"
private let UIViewWalkerKeySize: String = "wkc.take.size"


private let WKCWalkerTransitionTypeFade: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "fade")
private let WKCWalkerTransitionTypePush: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "push")
private let WKCWalkerTransitionTypeReveal: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "receal")
private let WKCWalkerTransitionTypeMoveIn: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "moveIn")
private let WKCWalkerTransitionTypeCube: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "cube")
private let WKCWalkerTransitionTypeSuck: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "suckEffect")
private let WKCWalkerTransitionTypeRipple: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "rippleEffect")
private let WKCWalkerTransitionTypeCurl: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "pageCurl")
private let WKCWalkerTransitionTypeUnCurl: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "pageUnCurl")
private let WKCWalkerTransitionTypeFlip: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "oglFlip")
private let WKCWalkerTransitionTypeHollowOpen: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "cameraIrisHollowOpen")
private let WKCWalkerTransitionTypeHollowClose: WKCWalkerTransitionType = WKCWalkerTransitionType(rawValue: "cameraIrisHollowClose")


public let WKCWalkerTransitionDirectionFromRight: WKCWalkerTransitionDirection = WKCWalkerTransitionDirection(rawValue: "fromRight")
public let WKCWalkerTransitionDirectionFromLeft: WKCWalkerTransitionDirection = WKCWalkerTransitionDirection(rawValue: "fromLeft")
public let WKCWalkerTransitionDirectionFromTop: WKCWalkerTransitionDirection = WKCWalkerTransitionDirection(rawValue: "fromTop")
public let WKCWalkerTransitionDirectionFromBottom: WKCWalkerTransitionDirection = WKCWalkerTransitionDirection(rawValue: "fromBottom")
public let WKCWalkerTransitionDirectionFromMiddle: WKCWalkerTransitionDirection = WKCWalkerTransitionDirection(rawValue: "fromMiddle")

private enum WKCWalkerType: Int
{
    case base = 0, spring, path, transition
}


// MARK: privite
extension CALayer
{
    private var wkc_layer_animationType: WKCWalkerType?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerAnimationType) as? WKCWalkerType
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerAnimationType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_timing: CAMediaTimingFunctionName?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerTiming) as? CAMediaTimingFunctionName
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerTiming, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_options: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerOptions) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerOptions, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_delay: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerDelay) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerDelay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_repeat: Int?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerRepeat) as? Int
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerRepeat, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_reverse: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerReverse) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerReverse, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_iscaanimation: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerIsCaanimation) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerIsCaanimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var wkc_layer_animateDuration: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerAnimateDuration) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerAnimateDuration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_keyPath: String?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerKeyPath) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerKeyPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_from: Any?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerFrom)
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerFrom, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var wkc_layer_to: Any?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerTo)
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerTo, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var wkc_layer_frame_keypath: String?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerFrameKeyPath) as? String
        }
        
        set {
           objc_setAssociatedObject(self, &WKCWalkerLayerFrameKeyPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_walker: WKCWalker?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerWalker) as? WKCWalker
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerWalker, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_transition: WKCWalkerTransitionType?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerTransition) as? WKCWalkerTransitionType
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerTransition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_layer_frameOrigin: CGRect?
    {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerLayerFrameOrigin) as? CGRect
        }
        
        set {
            objc_setAssociatedObject(self, &WKCWalkerLayerFrameOrigin, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension CALayer: CAAnimationDelegate
{
    // MARK: MAKE 全部以中心点为依据
    // Function MAKE, based on the center.
   @discardableResult func makePosition(_ point: CGPoint) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathPosition
        self.wkc_layer_from = CGPoint(x: self.centerX, y: self.centerY)
        self.wkc_layer_to = point
        self.wkc_layer_walker = WKCWalker.makePosition
        return self
    }
    
    @discardableResult func makeX(_ x: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathPositionX
        self.wkc_layer_from = self.centerX
        self.wkc_layer_to = x
        self.wkc_layer_walker = WKCWalker.makeX
        return self
    }
    
    @discardableResult func makeY(_ y: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathPositionY
        self.wkc_layer_from = self.centerY
        self.wkc_layer_to = y
        self.wkc_layer_walker = WKCWalker.makeY
        return self
    }
    
    @discardableResult func makeWidth(_ width: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathWidth
        self.wkc_layer_from = self.width
        self.wkc_layer_to = width
        self.wkc_layer_walker = WKCWalker.makeWidth
        return self
    }
    
    @discardableResult func makeHeight(_ height: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathHeight
        self.wkc_layer_from = self.height
        self.wkc_layer_to = height
        self.wkc_layer_walker = WKCWalker.makeHeight
        return self
    }
    
    @discardableResult func makeSize(_ size: CGSize) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathSize
        self.wkc_layer_from = CGSize(width: self.width, height: self.height)
        self.wkc_layer_to = size
        self.wkc_layer_walker = WKCWalker.makeSize
        return self
    }
    
    @discardableResult func makeScale(_ scale: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathScale
        self.wkc_layer_from = 1.0
        self.wkc_layer_to = scale
        self.wkc_layer_walker = WKCWalker.makeScale
        return self
    }
    
    @discardableResult func makeScaleX(_ scaleX: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathScaleX
        self.wkc_layer_from = 1.0
        self.wkc_layer_to = scaleX
        self.wkc_layer_walker = WKCWalker.makeScaleX
        return self
    }
    
    @discardableResult func makeScaleY(_ scaleY: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathScaleY
        self.wkc_layer_from = 1.0
        self.wkc_layer_to = scaleY
        self.wkc_layer_walker = WKCWalker.makeScaleY
        return self
    }
    
    @discardableResult func makeRotationX(_ rotationX: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathRotationX
        self.wkc_layer_from = 0
        self.wkc_layer_to = rotationX
        self.wkc_layer_walker = WKCWalker.makeRotationX
        return self
    }
    
    @discardableResult func makeRotationY(_ rotationY: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathRotationY
        self.wkc_layer_from = 0
        self.wkc_layer_to = rotationY
        self.wkc_layer_walker = WKCWalker.makeRotationY
        return self
    }
    
    @discardableResult func makeRotationZ(_ rotationZ: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathRotationZ
        self.wkc_layer_from = 0
        self.wkc_layer_to = rotationZ
        self.wkc_layer_walker = WKCWalker.makeRotationZ
        return self
    }
    
    @discardableResult func makeBackground(_ background: UIColor) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathBackground
        self.wkc_layer_from = self.backgroundColor
        self.wkc_layer_to = background.cgColor
        self.wkc_layer_walker = WKCWalker.makeBackground
        return self
    }
    
    @discardableResult func makeOpacity(_ opacity: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathOpacity
        self.wkc_layer_from = self.opacity
        self.wkc_layer_to = opacity
        self.wkc_layer_walker = WKCWalker.makeOpacity
        return self
    }
    
    @discardableResult func makeCornerRadius(_ corner: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathCornerRadius
        self.wkc_layer_from = self.cornerRadius
        self.wkc_layer_to = corner
        self.wkc_layer_walker = WKCWalker.makeCornerRadius
        return self
    }
    
    @discardableResult func makeStorkeEnd(_ storleEnd: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathStrokeEnd
        self.wkc_layer_from = 0
        self.wkc_layer_to = storleEnd
        self.wkc_layer_walker = WKCWalker.makeStrokeEnd
        return self
    }
    
    @discardableResult func makeContent(_ from: Any, _ to: Any) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathContent
        self.wkc_layer_from = from
        self.wkc_layer_to = to
        self.wkc_layer_walker = WKCWalker.makeContent
        return self
    }
    
    @discardableResult func makeBorderWidth(_ borderWidth: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathBorderWidth
        self.wkc_layer_from = self.borderWidth
        self.wkc_layer_to = borderWidth
        self.wkc_layer_walker = WKCWalker.makeBorderWidth
        return self
    }
    
    @discardableResult func makeShadowColor(_ color: UIColor) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathShadowColor
        self.wkc_layer_from = self.shadowColor
        self.wkc_layer_to  = color.cgColor
        self.wkc_layer_walker = WKCWalker.makeShadowColor
        return self
    }
    
    @discardableResult func makeShadowOffset(_ shadowOffset: CGSize) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathShadowOffset
        self.wkc_layer_from = self.shadowOffset
        self.wkc_layer_to = shadowOffset
        self.wkc_layer_walker = WKCWalker.makeShadowOffset
        return self
    }
    
    @discardableResult func makeShadowOpacity(_ shadowOpacity: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathShadowOpacity
        self.wkc_layer_from = self.shadowOpacity
        self.wkc_layer_to = shadowOpacity
        self.wkc_layer_walker = WKCWalker.makeShadowOpacity
        return self
    }
    
    @discardableResult func makeShadowRadius(_ shadowRdius: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathShadowRadius
        self.wkc_layer_from = self.shadowRadius
        self.wkc_layer_to = shadowRdius
        self.wkc_layer_walker = WKCWalker.makeShadowRadius
        return self
    }
    
    
    
    
    
    
    // MARK: TAKE 全部以边界点为依据 (repeat无效)
    // Function TAKE, based on the boundary (parameter repeat is unavailable).
    @discardableResult func takeFrame(_ rect: CGRect) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyFrame
        self.wkc_layer_to = rect
        self.wkc_layer_walker = WKCWalker.takeFrame
        return self
    }
    
    @discardableResult func takeLeading(_ leading: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyLeading
        self.wkc_layer_to = leading
        self.wkc_layer_walker = WKCWalker.takeLeading
        return self
    }
    
    @discardableResult func takeTraing(_ traing: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyTraing
        self.wkc_layer_to = traing
        self.wkc_layer_walker = WKCWalker.takeTraing
        return self
    }

    @discardableResult func takeTop(_ top: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyTop
        self.wkc_layer_to = top
        self.wkc_layer_walker = WKCWalker.takeTop
        return self
    }
    
    @discardableResult func takeBottom(_ bottom: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyBottom
        self.wkc_layer_to = bottom
        self.wkc_layer_walker = WKCWalker.takeBottom
        return self
    }
    
    @discardableResult func takeWidth(_ width: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyWidth
        self.wkc_layer_to = width
        self.wkc_layer_walker = WKCWalker.takeWidth
        return self
    }
    
    @discardableResult func takeHeight(_ height:CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyHeight
        self.wkc_layer_to = height
        self.wkc_layer_walker = WKCWalker.takeHeight
        return self
    }
    
    @discardableResult func takeSize(_ size: CGSize) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeySize
        self.wkc_layer_to = size
        self.wkc_layer_walker = WKCWalker.takeSize
        return self
    }

    
    
    
    
    
    // MARK: MOVE 相对移动 (以中心点为依据)
    // Function MOVE , relative movement (based on the center).
    @discardableResult func moveX(_ x: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathPositionX
        self.wkc_layer_from = self.centerX
        self.wkc_layer_to = self.centerX + x
        self.wkc_layer_walker = WKCWalker.moveX
        return self
    }
    
    @discardableResult func moveY(_ y: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathPositionY
        self.wkc_layer_from = self.centerY
        self.wkc_layer_to = self.centerY + y
        self.wkc_layer_walker = WKCWalker.moveY
        return self
    }
    
    @discardableResult func moveXY(_ xy: CGPoint) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathPosition
        self.wkc_layer_from = CGPoint(x: self.centerX, y: self.centerY)
        self.wkc_layer_to = CGPoint(x: self.centerX + xy.x, y: self.centerY + xy.y)
        self.wkc_layer_walker = WKCWalker.moveXY
        return self
    }

    @discardableResult func moveWidth(_ width: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathWidth
        self.wkc_layer_from = self.width
        self.wkc_layer_to = self.width + width
        self.wkc_layer_walker = WKCWalker.moveWidth
        return self
    }
    
    @discardableResult func moveHeight(_ height: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathHeight
        self.wkc_layer_from = self.height
        self.wkc_layer_to = self.height + height
        self.wkc_layer_walker = WKCWalker.moveHeight
        return self
    }
    
    @discardableResult func moveSize(_ size: CGSize) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_keyPath = WKCWalkerKeyPathSize
        self.wkc_layer_from = CGSize(width: self.width, height: self.height)
        self.wkc_layer_to = CGSize(width: self.width + size.width, height: self.height + size.height)
        self.wkc_layer_walker = WKCWalker.moveSize
        return self
    }
    
    
    
    
    
    // MARK: ADD 相对移动(以边界为依据) (repeat无效)
    // Function ADD , relative movement (based on the boundary). (parameter repeat is unavailable).
    @discardableResult func addLeading(_ leading: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyLeading
        self.wkc_layer_to = self.leading + leading
        self.wkc_layer_walker = WKCWalker.addLeading
        return self
    }
    
    @discardableResult func addTraing(_ traing: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyTraing
        self.wkc_layer_to = self.traing + traing
        self.wkc_layer_walker = WKCWalker.addTraing
        return self
    }

    @discardableResult func addTop(_ top: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyTop
        self.wkc_layer_to = self.top + top
        self.wkc_layer_walker = WKCWalker.addTop
        return self
    }
    
    @discardableResult func addBottom(_ bottom: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyBottom
        self.wkc_layer_to = self.bottom + bottom
        self.wkc_layer_walker = WKCWalker.addBottom
        return self
    }
    
    @discardableResult func addWidth(_ width: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyWidth
        self.wkc_layer_to = self.width + width
        self.wkc_layer_walker = WKCWalker.addWidth
        return self
    }
    
    @discardableResult func addHeight(_ height: CGFloat) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeyHeight
        self.wkc_layer_to = self.height + height
        self.wkc_layer_walker = WKCWalker.addHeight
        return self
    }
    
    @discardableResult func addSize(_ size: CGSize) -> CALayer
    {
        self.wkc_layer_iscaanimation = false
        self.wkc_layer_frame_keypath = UIViewWalkerKeySize
        self.wkc_layer_to = CGSize(width: self.width + size.width, height: self.height + size.height)
        self.wkc_layer_walker = WKCWalker.addSize
        return self
    }
    
    
    
    
    
    // MARK: TRANSITION 转场动画
    // Transition animation
    @discardableResult func transitionDir(_ dir: WKCWalkerTransitionDirection) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_to = dir
        self.wkc_layer_animationType = WKCWalkerType.transition
        self.wkc_layer_walker = WKCWalker.transition
        return self
    }
    
    
    
    
    // MARK: PATH 轨迹动画
    // Path animation
    @discardableResult func path(_ apath: UIBezierPath) -> CALayer
    {
        self.wkc_layer_iscaanimation = true
        self.wkc_layer_to = apath.cgPath
        self.wkc_layer_animationType = WKCWalkerType.path
        self.wkc_layer_walker = WKCWalker.path
        return self
    }

    
    
    
    
    
    // MARK: 通用属性
    // Content, general propertys
    @discardableResult func delay(_ adelay: TimeInterval) -> CALayer
    {
        self.wkc_layer_delay = adelay
        return self
    }
    
    // 注: repeat对TAKE和ADD无效
    // NOTE: repeat is unavailable for TAKE and ADD
    @discardableResult func repeatNumber(_ re: Int) -> CALayer
    {
        self.wkc_layer_repeat = re
        return self
    }
    
    @discardableResult func reverses(_ isrecerses: Bool) -> CALayer
    {
        self.wkc_layer_reverse = isrecerses
        return self
    }
    
    @discardableResult func animate(_ duration: TimeInterval) -> CALayer
    {
        self.wkc_layer_animateDuration = duration
        self.wkc_startWalker()
        return self
    }
    
    
    var completion: WKCWalkerCompletion {
        get {
            return objc_getAssociatedObject(self, &WKCWalkerCompletionKey) as! WKCWalkerCompletion
        }
        set {
            objc_setAssociatedObject(self, &WKCWalkerCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    
    // MARK: 动画样式
    // animated style
    var easeInOut: CALayer {
        self.wkc_layer_timing = CAMediaTimingFunctionName.easeInEaseOut
        self.wkc_layer_options = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var easeIn: CALayer {
        self.wkc_layer_timing = CAMediaTimingFunctionName.easeIn
        self.wkc_layer_options = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var easeOut: CALayer {
        self.wkc_layer_timing = CAMediaTimingFunctionName.easeOut
        self.wkc_layer_options = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    var easeLiner: CALayer {
        self.wkc_layer_timing = CAMediaTimingFunctionName.linear
        self.wkc_layer_options = UIView.AnimationOptions.curveLinear
        return self
    }
    
    
    
    
    // MARK: 弹性
    // bounce
    var spring: CALayer {
        self.wkc_layer_animationType = WKCWalkerType.spring
        return self
    }
    
    
    
    
    // MARK: 转场动画样式 (只适用于TRANSITION, spring无效)
    // Transition animation style (only for TRANSITION, spring is unavailable)
    var transitionFade: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeFade
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionPush: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypePush
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionReveal: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeReveal
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionMoveIn: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeMoveIn
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionCube: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeCube
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionSuck: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeSuck
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionRipple: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeRipple
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionCurl: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeCurl
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionUnCurl: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeUnCurl
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionFlip: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeFlip
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionHollowOpen: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeHollowOpen
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    var transitionHollowClose: CALayer {
        self.wkc_layer_transition = WKCWalkerTransitionTypeHollowClose
        self.wkc_layer_iscaanimation = true
        return self
    }
    
    
    
    
    
    // MARK: 关联动画,then以后前一个完成后才完成第二个
    //Associated animation, after the previous one is completed, then the second animate.
    var then: CALayer {
        self.wkc_layer_delay = self.wkc_layer_animateDuration
        return self
    }
    
    
    func removeWalkers()
    {
        self.removeAllAnimations()
        if let value = self.wkc_layer_iscaanimation, value == false
        {
            let superLayer = self.superlayer
            self.removeFromSuperlayer()
            self.frame = self.wkc_layer_frameOrigin!
            superLayer?.addSublayer(self)
        }
    }
    
    
    func reloadWalker()
    {
        self.removeWalkers()
        self.wkc_startWalker()
    }
    
    
    private func wkc_initPrarms()
    {
        if self.wkc_layer_animationType == nil
        {
            self.wkc_layer_animationType = WKCWalkerType.base
        }
        
        if self.wkc_layer_timing == nil
        {
            self.wkc_layer_timing = CAMediaTimingFunctionName.linear
        }
        
        if self.wkc_layer_options == nil
        {
            self.wkc_layer_options = UIView.AnimationOptions.curveLinear
        }
        
        if self.wkc_layer_delay == nil
        {
            self.wkc_layer_delay = 0.0
        }
        
        if self.wkc_layer_repeat == nil
        {
            self.wkc_layer_repeat = 1
        }
        
        if self.wkc_layer_reverse == nil
        {
            self.wkc_layer_reverse = false
        }
        
        if self.wkc_layer_iscaanimation == nil
        {
            self.wkc_layer_iscaanimation = true
        }
        
        if self.wkc_layer_animateDuration == nil
        {
            self.wkc_layer_animateDuration = 0.25
        }
        
        if self.wkc_layer_keyPath == nil
        {
            self.wkc_layer_keyPath = WKCWalkerKeyPathPosition
        }
        
        if self.wkc_layer_frame_keypath == nil
        {
            self.wkc_layer_frame_keypath = UIViewWalkerKeyFrame
        }
        
        if self.wkc_layer_walker == nil
        {
            self.wkc_layer_walker = WKCWalker.makePosition
        }
        
        if self.wkc_layer_transition == nil
        {
            self.wkc_layer_transition = WKCWalkerTransitionType.fade
        }
        
        if self.wkc_layer_frameOrigin == nil
        {
            self.wkc_layer_frameOrigin = CGRect.zero
        }
        
    }
    
    private func wkc_startWalker()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
        {
            self.superlayer?.layoutIfNeeded()
            self.wkc_initPrarms()
            
            if self.wkc_layer_iscaanimation!
            {
                if self.wkc_layer_animationType == WKCWalkerType.base
                {
                    let base: CABasicAnimation = wkc_baseWalker(keyPath: self.wkc_layer_keyPath!,
                                                                duration: self.wkc_layer_animateDuration!,
                                                                repeatCount: Float(self.wkc_layer_repeat!),
                                                                delay: self.wkc_layer_delay!,
                                                                autoreverses: self.wkc_layer_reverse!,
                                                                timing: self.wkc_layer_timing!,
                                                                from: self.wkc_layer_from,
                                                                to: self.wkc_layer_to)
                    base.delegate = self
                    self.add(base, forKey: nil)
                }
                else if self.wkc_layer_animationType == WKCWalkerType.spring
                {
                    let sp: CASpringAnimation = wkc_springWalker(keyPath: self.wkc_layer_keyPath!,
                                                                 duration: self.wkc_layer_animateDuration!,
                                                                 repeatCount: Float(self.wkc_layer_repeat!),
                                                                 delay: self.wkc_layer_delay!,
                                                                 autoreverses: self.wkc_layer_reverse!,
                                                                 timing: self.wkc_layer_timing!,
                                                                 from: self.wkc_layer_from,
                                                                 to: self.wkc_layer_to)
                    sp.delegate = self
                    self.add(sp, forKey: nil)
                }
                else if self.wkc_layer_animationType == WKCWalkerType.path
                {
                    let keyframe: CAKeyframeAnimation = wkc_keyframeWalker(keyPath: self.wkc_layer_keyPath!,
                                                                           duration: self.wkc_layer_animateDuration!,
                                                                           repeatCount: Float(self.wkc_layer_repeat!),
                                                                           delay: self.wkc_layer_delay!,
                                                                           autoreverses: self.wkc_layer_reverse!,
                                                                           timing: self.wkc_layer_timing!,
                                                                           path: (self.wkc_layer_to as! CGPath))
                    keyframe.delegate = self
                    self.add(keyframe, forKey: nil)
                }
                else if self.wkc_layer_animationType == WKCWalkerType.transition
                {
                    let tr: CATransition = wkc_transitionWalker(duration: self.wkc_layer_animateDuration!,
                                                                timing: self.wkc_layer_timing!,
                                                                type: self.wkc_layer_transition!,
                                                                direction: (self.wkc_layer_to as! WKCWalkerTransitionDirection),
                                                                repeatCount: Float(self.wkc_layer_repeat!),
                                                                delay: self.wkc_layer_delay!,
                                                                autoreverses: self.wkc_layer_reverse!)
                    tr.delegate = self
                    self.add(tr, forKey: nil)
                }
            }
            else
            {
                self.wkc_layer_frameOrigin = self.frame
                if self.wkc_layer_reverse!
                {
                    if self.wkc_layer_options == UIView.AnimationOptions.curveEaseInOut
                    {
                        self.wkc_layer_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveEaseInOut]
                    }
                    else if self.wkc_layer_options == UIView.AnimationOptions.curveEaseIn
                    {
                        self.wkc_layer_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveEaseIn]
                    }
                    else if self.wkc_layer_options == UIView.AnimationOptions.curveEaseOut
                    {
                        self.wkc_layer_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveEaseOut]
                    }
                    else
                    {
                        self.wkc_layer_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveLinear]
                    }
                }
                
                if self.wkc_layer_animationType == WKCWalkerType.spring
                {
                    let damping: CGFloat = 0.85
                    let velocity: CGFloat = 10.0
                    
                    UIView.animate(withDuration: self.wkc_layer_animateDuration!,
                                   delay: self.wkc_layer_delay!,
                                   usingSpringWithDamping: damping,
                                   initialSpringVelocity: velocity,
                                   options: self.wkc_layer_options!,
                                   animations: {
                                    
                                    if self.wkc_layer_frame_keypath == UIViewWalkerKeyFrame
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.frame = value as! CGRect
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyLeading
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.leading = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyTraing
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.traing = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyTop
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.top = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyBottom
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.bottom = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyWidth
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.width = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyHeight
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.height = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeySize
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (value as! CGSize).width, height: (value as! CGSize).height)
                                        }
                                    }
                                    
                    }) { (success) in
                        self.wkc_resetInitParams()
                    }
                }
                else
                {
                    UIView.animate(withDuration: self.wkc_layer_animateDuration!,
                                   delay: self.wkc_layer_delay!,
                                   options: self.wkc_layer_options!,
                                   animations: {
                                    
                                    if self.wkc_layer_frame_keypath == UIViewWalkerKeyFrame
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.frame = value as! CGRect
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyLeading
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.leading = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyTraing
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.traing = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyTop
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.top = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyBottom
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.bottom = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyWidth
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.width = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeyHeight
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.height = value as! CGFloat
                                        }
                                    }
                                    else if self.wkc_layer_frame_keypath == UIViewWalkerKeySize
                                    {
                                        if let value = self.wkc_layer_to
                                        {
                                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (value as! CGSize).width, height: (value as! CGSize).height)
                                        }
                                    }
                    }) { (success) in
                        self.wkc_resetInitParams()
                    }
                }
            }
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        self.wkc_resetInitParams()
    }
    
    private func wkc_resetInitParams()
    {
        if let value = self.completion
        {
            value(self.wkc_layer_walker!)
        }
    }
}
