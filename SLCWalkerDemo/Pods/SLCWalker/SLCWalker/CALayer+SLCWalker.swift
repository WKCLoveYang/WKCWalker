//
//  CALayer+SLCWalker.swift
//  SLCWalker
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


private func slc_baseWalker(keyPath: String,
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

private func slc_springWalker(keyPath: String,
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

private func slc_keyframeWalker(keyPath: String,
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

private func slc_transitionWalker(duration: TimeInterval,
                                  timing: CAMediaTimingFunctionName,
                                  type: SLCWalkerTransitionType,
                                  direction: SLCWalkerTransitionDirection,
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


private var SLCWalkerCompletionKey: String = "slc.completion"
private var SLCWalkerAnimationType: String = "slc.layer.animationType"
private var SLCWalkerLayerTiming: String = "slc.layer.timing"
private var SLCWalkerLayerOptions: String = "slc.layer.options"
private var SLCWalkerLayerDelay: String = "slc.layer.delay"
private var SLCWalkerLayerRepeat: String = "slc.layer.repeat"
private var SLCWalkerLayerReverse: String = "slc.layer.reverse"
private var SLCWalkerLayerIsCaanimation: String = "slc.layer.iscaanimat"
private var SLCWalkerLayerAnimateDuration: String = "slc.layer.duration"
private var SLCWalkerLayerKeyPath: String = "slc.layer.keyPath"
private var SLCWalkerLayerFrom: String = "slc.layer.from"
private var SLCWalkerLayerTo: String = "slc.layer.to"
private var SLCWalkerLayerFrameKeyPath: String = "slc.layer.frame.keypath"
private var SLCWalkerLayerWalker: String = "slc.layer.walker"
private var SLCWalkerLayerTransition: String = "slc.layer.transition"
private var SLCWalkerLayerFrameOrigin: String = "slc.layer.frame.origin"

private let SLCWalkerKeyPathPosition: String = "position"
private let SLCWalkerKeyPathPositionX: String = "position.x"
private let SLCWalkerKeyPathPositionY: String = "position.y"
private let SLCWalkerKeyPathWidth: String = "bounds.size.width"
private let SLCWalkerKeyPathHeight: String = "bounds.size.height"
private let SLCWalkerKeyPathSize: String = "bounds.size"
private let SLCWalkerKeyPathScale: String = "transform.scale"
private let SLCWalkerKeyPathScaleX: String = "transform.scale.x"
private let SLCWalkerKeyPathScaleY: String = "transform.scale.y"
private let SLCWalkerKeyPathRotationX: String = "transform.rotation.x"
private let SLCWalkerKeyPathRotationY: String = "transform.rotation.y"
private let SLCWalkerKeyPathRotationZ: String = "transform.rotation.z"
private let SLCWalkerKeyPathBackground: String = "backgroundColor"
private let SLCWalkerKeyPathOpacity: String = "opacity"
private let SLCWalkerKeyPathCornerRadius: String = "cornerRadius"
private let SLCWalkerKeyPathStrokeEnd: String = "strokeEnd"
private let SLCWalkerKeyPathContent: String = "contents"
private let SLCWalkerKeyPathBorderWidth: String = "borderWidth"
private let SLCWalkerKeyPathShadowColor: String = "shadowColor"
private let SLCWalkerKeyPathShadowOffset: String = "shadowOffset"
private let SLCWalkerKeyPathShadowOpacity: String = "shadowOpacity"
private let SLCWalkerKeyPathShadowRadius: String = "shadowRadius"

private let UIViewWalkerKeyFrame: String = "slc.take.frame"
private let UIViewWalkerKeyLeading: String = "slc.take.leading"
private let UIViewWalkerKeyTraing: String = "slc.take.traing"
private let UIViewWalkerKeyTop: String = "slc.take.top"
private let UIViewWalkerKeyBottom: String = "slc.take.bottom"
private let UIViewWalkerKeyWidth: String = "slc.take.width"
private let UIViewWalkerKeyHeight: String = "slc.take.height"
private let UIViewWalkerKeySize: String = "slc.take.size"


private let SLCWalkerTransitionTypeFade: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "fade")
private let SLCWalkerTransitionTypePush: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "push")
private let SLCWalkerTransitionTypeReveal: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "receal")
private let SLCWalkerTransitionTypeMoveIn: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "moveIn")
private let SLCWalkerTransitionTypeCube: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "cube")
private let SLCWalkerTransitionTypeSuck: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "suckEffect")
private let SLCWalkerTransitionTypeRipple: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "rippleEffect")
private let SLCWalkerTransitionTypeCurl: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "pageCurl")
private let SLCWalkerTransitionTypeUnCurl: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "pageUnCurl")
private let SLCWalkerTransitionTypeFlip: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "oglFlip")
private let SLCWalkerTransitionTypeHollowOpen: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "cameraIrisHollowOpen")
private let SLCWalkerTransitionTypeHollowClose: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "cameraIrisHollowClose")


public let SLCWalkerTransitionDirectionFromRight: SLCWalkerTransitionDirection = SLCWalkerTransitionDirection(rawValue: "fromRight")
public let SLCWalkerTransitionDirectionFromLeft: SLCWalkerTransitionDirection = SLCWalkerTransitionDirection(rawValue: "fromLeft")
public let SLCWalkerTransitionDirectionFromTop: SLCWalkerTransitionDirection = SLCWalkerTransitionDirection(rawValue: "fromTop")
public let SLCWalkerTransitionDirectionFromBottom: SLCWalkerTransitionDirection = SLCWalkerTransitionDirection(rawValue: "fromBottom")
public let SLCWalkerTransitionDirectionFromMiddle: SLCWalkerTransitionDirection = SLCWalkerTransitionDirection(rawValue: "fromMiddle")

private enum SLCWalkerType: Int
{
    case base = 0, spring, path, transition
}


// MARK: privite
extension CALayer
{
    private var slc_layer_animationType: SLCWalkerType?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerAnimationType) as? SLCWalkerType
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerAnimationType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_timing: CAMediaTimingFunctionName?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerTiming) as? CAMediaTimingFunctionName
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerTiming, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_options: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerOptions) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerOptions, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_delay: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerDelay) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerDelay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_repeat: Int?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerRepeat) as? Int
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerRepeat, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_reverse: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerReverse) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerReverse, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_iscaanimation: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerIsCaanimation) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerIsCaanimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var slc_layer_animateDuration: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerAnimateDuration) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerAnimateDuration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_keyPath: String?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerKeyPath) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerKeyPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_from: Any?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerFrom)
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerFrom, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var slc_layer_to: Any?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerTo)
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerTo, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var slc_layer_frame_keypath: String?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerFrameKeyPath) as? String
        }
        
        set {
           objc_setAssociatedObject(self, &SLCWalkerLayerFrameKeyPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_walker: SLCWalker?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerWalker) as? SLCWalker
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerWalker, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_transition: SLCWalkerTransitionType?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerTransition) as? SLCWalkerTransitionType
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerTransition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_layer_frameOrigin: CGRect?
    {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerLayerFrameOrigin) as? CGRect
        }
        
        set {
            objc_setAssociatedObject(self, &SLCWalkerLayerFrameOrigin, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension CALayer: CAAnimationDelegate
{
    // MARK: MAKE 全部以中心点为依据
    // Function MAKE, based on the center.
   @discardableResult func makePosition(_ point: CGPoint) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathPosition
        self.slc_layer_from = CGPoint(x: self.centerX, y: self.centerY)
        self.slc_layer_to = point
        self.slc_layer_walker = SLCWalker.makePosition
        return self
    }
    
    @discardableResult func makeX(_ x: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathPositionX
        self.slc_layer_from = self.centerX
        self.slc_layer_to = x
        self.slc_layer_walker = SLCWalker.makeX
        return self
    }
    
    @discardableResult func makeY(_ y: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathPositionY
        self.slc_layer_from = self.centerY
        self.slc_layer_to = y
        self.slc_layer_walker = SLCWalker.makeY
        return self
    }
    
    @discardableResult func makeWidth(_ width: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathWidth
        self.slc_layer_from = self.width
        self.slc_layer_to = width
        self.slc_layer_walker = SLCWalker.makeWidth
        return self
    }
    
    @discardableResult func makeHeight(_ height: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathHeight
        self.slc_layer_from = self.height
        self.slc_layer_to = height
        self.slc_layer_walker = SLCWalker.makeHeight
        return self
    }
    
    @discardableResult func makeSize(_ size: CGSize) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathSize
        self.slc_layer_from = CGSize(width: self.width, height: self.height)
        self.slc_layer_to = size
        self.slc_layer_walker = SLCWalker.makeSize
        return self
    }
    
    @discardableResult func makeScale(_ scale: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathScale
        self.slc_layer_from = 1.0
        self.slc_layer_to = scale
        self.slc_layer_walker = SLCWalker.makeScale
        return self
    }
    
    @discardableResult func makeScaleX(_ scaleX: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathScaleX
        self.slc_layer_from = 1.0
        self.slc_layer_to = scaleX
        self.slc_layer_walker = SLCWalker.makeScaleX
        return self
    }
    
    @discardableResult func makeScaleY(_ scaleY: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathScaleY
        self.slc_layer_from = 1.0
        self.slc_layer_to = scaleY
        self.slc_layer_walker = SLCWalker.makeScaleY
        return self
    }
    
    @discardableResult func makeRotationX(_ rotationX: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathRotationX
        self.slc_layer_from = 0
        self.slc_layer_to = rotationX
        self.slc_layer_walker = SLCWalker.makeRotationX
        return self
    }
    
    @discardableResult func makeRotationY(_ rotationY: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathRotationY
        self.slc_layer_from = 0
        self.slc_layer_to = rotationY
        self.slc_layer_walker = SLCWalker.makeRotationY
        return self
    }
    
    @discardableResult func makeRotationZ(_ rotationZ: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathRotationZ
        self.slc_layer_from = 0
        self.slc_layer_to = rotationZ
        self.slc_layer_walker = SLCWalker.makeRotationZ
        return self
    }
    
    @discardableResult func makeBackground(_ background: UIColor) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathBackground
        self.slc_layer_from = self.backgroundColor
        self.slc_layer_to = background.cgColor
        self.slc_layer_walker = SLCWalker.makeBackground
        return self
    }
    
    @discardableResult func makeOpacity(_ opacity: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathOpacity
        self.slc_layer_from = self.opacity
        self.slc_layer_to = opacity
        self.slc_layer_walker = SLCWalker.makeOpacity
        return self
    }
    
    @discardableResult func makeCornerRadius(_ corner: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathCornerRadius
        self.slc_layer_from = self.cornerRadius
        self.slc_layer_to = corner
        self.slc_layer_walker = SLCWalker.makeCornerRadius
        return self
    }
    
    @discardableResult func makeStorkeEnd(_ storleEnd: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathStrokeEnd
        self.slc_layer_from = 0
        self.slc_layer_to = storleEnd
        self.slc_layer_walker = SLCWalker.makeStrokeEnd
        return self
    }
    
    @discardableResult func makeContent(_ from: Any, _ to: Any) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathContent
        self.slc_layer_from = from
        self.slc_layer_to = to
        self.slc_layer_walker = SLCWalker.makeContent
        return self
    }
    
    @discardableResult func makeBorderWidth(_ borderWidth: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathBorderWidth
        self.slc_layer_from = self.borderWidth
        self.slc_layer_to = borderWidth
        self.slc_layer_walker = SLCWalker.makeBorderWidth
        return self
    }
    
    @discardableResult func makeShadowColor(_ color: UIColor) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathShadowColor
        self.slc_layer_from = self.shadowColor
        self.slc_layer_to  = color.cgColor
        self.slc_layer_walker = SLCWalker.makeShadowColor
        return self
    }
    
    @discardableResult func makeShadowOffset(_ shadowOffset: CGSize) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathShadowOffset
        self.slc_layer_from = self.shadowOffset
        self.slc_layer_to = shadowOffset
        self.slc_layer_walker = SLCWalker.makeShadowOffset
        return self
    }
    
    @discardableResult func makeShadowOpacity(_ shadowOpacity: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathShadowOpacity
        self.slc_layer_from = self.shadowOpacity
        self.slc_layer_to = shadowOpacity
        self.slc_layer_walker = SLCWalker.makeShadowOpacity
        return self
    }
    
    @discardableResult func makeShadowRadius(_ shadowRdius: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathShadowRadius
        self.slc_layer_from = self.shadowRadius
        self.slc_layer_to = shadowRdius
        self.slc_layer_walker = SLCWalker.makeShadowRadius
        return self
    }
    
    
    
    
    
    
    // MARK: TAKE 全部以边界点为依据 (repeat无效)
    // Function TAKE, based on the boundary (parameter repeat is unavailable).
    @discardableResult func takeFrame(_ rect: CGRect) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyFrame
        self.slc_layer_to = rect
        self.slc_layer_walker = SLCWalker.takeFrame
        return self
    }
    
    @discardableResult func takeLeading(_ leading: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyLeading
        self.slc_layer_to = leading
        self.slc_layer_walker = SLCWalker.takeLeading
        return self
    }
    
    @discardableResult func takeTraing(_ traing: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyTraing
        self.slc_layer_to = traing
        self.slc_layer_walker = SLCWalker.takeTraing
        return self
    }

    @discardableResult func takeTop(_ top: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyTop
        self.slc_layer_to = top
        self.slc_layer_walker = SLCWalker.takeTop
        return self
    }
    
    @discardableResult func takeBottom(_ bottom: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyBottom
        self.slc_layer_to = bottom
        self.slc_layer_walker = SLCWalker.takeBottom
        return self
    }
    
    @discardableResult func takeWidth(_ width: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyWidth
        self.slc_layer_to = width
        self.slc_layer_walker = SLCWalker.takeWidth
        return self
    }
    
    @discardableResult func takeHeight(_ height:CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyHeight
        self.slc_layer_to = height
        self.slc_layer_walker = SLCWalker.takeHeight
        return self
    }
    
    @discardableResult func takeSize(_ size: CGSize) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeySize
        self.slc_layer_to = size
        self.slc_layer_walker = SLCWalker.takeSize
        return self
    }

    
    
    
    
    
    // MARK: MOVE 相对移动 (以中心点为依据)
    // Function MOVE , relative movement (based on the center).
    @discardableResult func moveX(_ x: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathPositionX
        self.slc_layer_from = self.centerX
        self.slc_layer_to = self.centerX + x
        self.slc_layer_walker = SLCWalker.moveX
        return self
    }
    
    @discardableResult func moveY(_ y: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathPositionY
        self.slc_layer_from = self.centerY
        self.slc_layer_to = self.centerY + y
        self.slc_layer_walker = SLCWalker.moveY
        return self
    }
    
    @discardableResult func moveXY(_ xy: CGPoint) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathPosition
        self.slc_layer_from = CGPoint(x: self.centerX, y: self.centerY)
        self.slc_layer_to = CGPoint(x: self.centerX + xy.x, y: self.centerY + xy.y)
        self.slc_layer_walker = SLCWalker.moveXY
        return self
    }

    @discardableResult func moveWidth(_ width: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathWidth
        self.slc_layer_from = self.width
        self.slc_layer_to = self.width + width
        self.slc_layer_walker = SLCWalker.moveWidth
        return self
    }
    
    @discardableResult func moveHeight(_ height: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathHeight
        self.slc_layer_from = self.height
        self.slc_layer_to = self.height + height
        self.slc_layer_walker = SLCWalker.moveHeight
        return self
    }
    
    @discardableResult func moveSize(_ size: CGSize) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_keyPath = SLCWalkerKeyPathSize
        self.slc_layer_from = CGSize(width: self.width, height: self.height)
        self.slc_layer_to = CGSize(width: self.width + size.width, height: self.height + size.height)
        self.slc_layer_walker = SLCWalker.moveSize
        return self
    }
    
    
    
    
    
    // MARK: ADD 相对移动(以边界为依据) (repeat无效)
    // Function ADD , relative movement (based on the boundary). (parameter repeat is unavailable).
    @discardableResult func addLeading(_ leading: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyLeading
        self.slc_layer_to = self.leading + leading
        self.slc_layer_walker = SLCWalker.addLeading
        return self
    }
    
    @discardableResult func addTraing(_ traing: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyTraing
        self.slc_layer_to = self.traing + traing
        self.slc_layer_walker = SLCWalker.addTraing
        return self
    }

    @discardableResult func addTop(_ top: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyTop
        self.slc_layer_to = self.top + top
        self.slc_layer_walker = SLCWalker.addTop
        return self
    }
    
    @discardableResult func addBottom(_ bottom: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyBottom
        self.slc_layer_to = self.bottom + bottom
        self.slc_layer_walker = SLCWalker.addBottom
        return self
    }
    
    @discardableResult func addWidth(_ width: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyWidth
        self.slc_layer_to = self.width + width
        self.slc_layer_walker = SLCWalker.addWidth
        return self
    }
    
    @discardableResult func addHeight(_ height: CGFloat) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeyHeight
        self.slc_layer_to = self.height + height
        self.slc_layer_walker = SLCWalker.addHeight
        return self
    }
    
    @discardableResult func addSize(_ size: CGSize) -> CALayer
    {
        self.slc_layer_iscaanimation = false
        self.slc_layer_frame_keypath = UIViewWalkerKeySize
        self.slc_layer_to = CGSize(width: self.width + size.width, height: self.height + size.height)
        self.slc_layer_walker = SLCWalker.addSize
        return self
    }
    
    
    
    
    
    // MARK: TRANSITION 转场动画
    // Transition animation
    @discardableResult func transitionDir(_ dir: SLCWalkerTransitionDirection) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_to = dir
        self.slc_layer_animationType = SLCWalkerType.transition
        self.slc_layer_walker = SLCWalker.transition
        return self
    }
    
    
    
    
    // MARK: PATH 轨迹动画
    // Path animation
    @discardableResult func path(_ apath: UIBezierPath) -> CALayer
    {
        self.slc_layer_iscaanimation = true
        self.slc_layer_to = apath.cgPath
        self.slc_layer_animationType = SLCWalkerType.path
        self.slc_layer_walker = SLCWalker.path
        return self
    }

    
    
    
    
    
    // MARK: 通用属性
    // Content, general propertys
    @discardableResult func delay(_ adelay: TimeInterval) -> CALayer
    {
        self.slc_layer_delay = adelay
        return self
    }
    
    // 注: repeat对TAKE和ADD无效
    // NOTE: repeat is unavailable for TAKE and ADD
    @discardableResult func repeatNumber(_ re: Int) -> CALayer
    {
        self.slc_layer_repeat = re
        return self
    }
    
    @discardableResult func reverses(_ isrecerses: Bool) -> CALayer
    {
        self.slc_layer_reverse = isrecerses
        return self
    }
    
    @discardableResult func animate(_ duration: TimeInterval) -> CALayer
    {
        self.slc_layer_animateDuration = duration
        self.slc_startWalker()
        return self
    }
    
    
    var completion: SLCWalkerCompletion {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerCompletionKey) as! SLCWalkerCompletion
        }
        set {
            objc_setAssociatedObject(self, &SLCWalkerCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    
    // MARK: 动画样式
    // animated style
    var easeInOut: CALayer {
        self.slc_layer_timing = CAMediaTimingFunctionName.easeInEaseOut
        self.slc_layer_options = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var easeIn: CALayer {
        self.slc_layer_timing = CAMediaTimingFunctionName.easeIn
        self.slc_layer_options = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var easeOut: CALayer {
        self.slc_layer_timing = CAMediaTimingFunctionName.easeOut
        self.slc_layer_options = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    var easeLiner: CALayer {
        self.slc_layer_timing = CAMediaTimingFunctionName.linear
        self.slc_layer_options = UIView.AnimationOptions.curveLinear
        return self
    }
    
    
    
    
    // MARK: 弹性
    // bounce
    var spring: CALayer {
        self.slc_layer_animationType = SLCWalkerType.spring
        return self
    }
    
    
    
    
    // MARK: 转场动画样式 (只适用于TRANSITION, spring无效)
    // Transition animation style (only for TRANSITION, spring is unavailable)
    var transitionFade: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeFade
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionPush: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypePush
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionReveal: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeReveal
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionMoveIn: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeMoveIn
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionCube: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeCube
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionSuck: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeSuck
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionRipple: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeRipple
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionCurl: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeCurl
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionUnCurl: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeUnCurl
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionFlip: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeFlip
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionHollowOpen: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeHollowOpen
        self.slc_layer_iscaanimation = true
        return self
    }
    
    var transitionHollowClose: CALayer {
        self.slc_layer_transition = SLCWalkerTransitionTypeHollowClose
        self.slc_layer_iscaanimation = true
        return self
    }
    
    
    
    
    
    // MARK: 关联动画,then以后前一个完成后才完成第二个
    //Associated animation, after the previous one is completed, then the second animate.
    var then: CALayer {
        self.slc_layer_delay = self.slc_layer_animateDuration
        return self
    }
    
    
    func removeWalkers()
    {
        self.removeAllAnimations()
        if let value = self.slc_layer_iscaanimation, value == false 
        {
            let superLayer = self.superlayer
            self.removeFromSuperlayer()
            self.frame = self.slc_layer_frameOrigin!
            superLayer?.addSublayer(self)
        }
    }
    
    
    func reloadWalker()
    {
        self.removeWalkers()
        self.slc_startWalker()
    }
    
    
    private func slc_initPrarms()
    {
        if self.slc_layer_animationType == nil
        {
            self.slc_layer_animationType = SLCWalkerType.base
        }
        
        if self.slc_layer_timing == nil
        {
            self.slc_layer_timing = CAMediaTimingFunctionName.linear
        }
        
        if self.slc_layer_options == nil
        {
            self.slc_layer_options = UIView.AnimationOptions.curveLinear
        }
        
        if self.slc_layer_delay == nil
        {
            self.slc_layer_delay = 0.0
        }
        
        if self.slc_layer_repeat == nil
        {
            self.slc_layer_repeat = 1
        }
        
        if self.slc_layer_reverse == nil
        {
            self.slc_layer_reverse = false
        }
        
        if self.slc_layer_iscaanimation == nil
        {
            self.slc_layer_iscaanimation = true
        }
        
        if self.slc_layer_animateDuration == nil
        {
            self.slc_layer_animateDuration = 0.25
        }
        
        if self.slc_layer_keyPath == nil
        {
            self.slc_layer_keyPath = SLCWalkerKeyPathPosition
        }
        
        if self.slc_layer_frame_keypath == nil
        {
            self.slc_layer_frame_keypath = UIViewWalkerKeyFrame
        }
        
        if self.slc_layer_walker == nil
        {
            self.slc_layer_walker = SLCWalker.makePosition
        }
        
        if self.slc_layer_transition == nil
        {
            self.slc_layer_transition = SLCWalkerTransitionType.fade
        }
        
        if self.slc_layer_frameOrigin == nil
        {
            self.slc_layer_frameOrigin = CGRect.zero
        }
        
    }
    
    private func slc_startWalker()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
        {
            self.superlayer?.layoutIfNeeded()
            self.slc_initPrarms()
            
            if self.slc_layer_iscaanimation!
            {
                if self.slc_layer_animationType == SLCWalkerType.base
                {
                    let base: CABasicAnimation = slc_baseWalker(keyPath: self.slc_layer_keyPath!,
                                                                duration: self.slc_layer_animateDuration!,
                                                                repeatCount: Float(self.slc_layer_repeat!),
                                                                delay: self.slc_layer_delay!,
                                                                autoreverses: self.slc_layer_reverse!,
                                                                timing: self.slc_layer_timing!,
                                                                from: self.slc_layer_from,
                                                                to: self.slc_layer_to)
                    base.delegate = self
                    self.add(base, forKey: nil)
                }
                else if self.slc_layer_animationType == SLCWalkerType.spring
                {
                    let sp: CASpringAnimation = slc_springWalker(keyPath: self.slc_layer_keyPath!,
                                                                 duration: self.slc_layer_animateDuration!,
                                                                 repeatCount: Float(self.slc_layer_repeat!),
                                                                 delay: self.slc_layer_delay!,
                                                                 autoreverses: self.slc_layer_reverse!,
                                                                 timing: self.slc_layer_timing!,
                                                                 from: self.slc_layer_from,
                                                                 to: self.slc_layer_to)
                    sp.delegate = self
                    self.add(sp, forKey: nil)
                }
                else if self.slc_layer_animationType == SLCWalkerType.path
                {
                    let keyframe: CAKeyframeAnimation = slc_keyframeWalker(keyPath: self.slc_layer_keyPath!,
                                                                           duration: self.slc_layer_animateDuration!,
                                                                           repeatCount: Float(self.slc_layer_repeat!),
                                                                           delay: self.slc_layer_delay!,
                                                                           autoreverses: self.slc_layer_reverse!,
                                                                           timing: self.slc_layer_timing!,
                                                                           path: (self.slc_layer_to as! CGPath))
                    keyframe.delegate = self
                    self.add(keyframe, forKey: nil)
                }
                else if self.slc_layer_animationType == SLCWalkerType.transition
                {
                    let tr: CATransition = slc_transitionWalker(duration: self.slc_layer_animateDuration!,
                                                                timing: self.slc_layer_timing!,
                                                                type: self.slc_layer_transition!,
                                                                direction: (self.slc_layer_to as! SLCWalkerTransitionDirection),
                                                                repeatCount: Float(self.slc_layer_repeat!),
                                                                delay: self.slc_layer_delay!,
                                                                autoreverses: self.slc_layer_reverse!)
                    tr.delegate = self
                    self.add(tr, forKey: nil)
                }
            }
            else
            {
                self.slc_layer_frameOrigin = self.frame
                if self.slc_layer_reverse!
                {
                    if self.slc_layer_options == UIView.AnimationOptions.curveEaseInOut
                    {
                        self.slc_layer_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveEaseInOut]
                    }
                    else if self.slc_layer_options == UIView.AnimationOptions.curveEaseIn
                    {
                        self.slc_layer_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveEaseIn]
                    }
                    else if self.slc_layer_options == UIView.AnimationOptions.curveEaseOut
                    {
                        self.slc_layer_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveEaseOut]
                    }
                    else
                    {
                        self.slc_layer_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveLinear]
                    }
                }
                
                if self.slc_layer_animationType == SLCWalkerType.spring
                {
                    let damping: CGFloat = 0.85
                    let velocity: CGFloat = 10.0
                    
                    UIView.animate(withDuration: self.slc_layer_animateDuration!,
                                   delay: self.slc_layer_delay!,
                                   usingSpringWithDamping: damping,
                                   initialSpringVelocity: velocity,
                                   options: self.slc_layer_options!,
                                   animations: {
                                    
                                    if self.slc_layer_frame_keypath == UIViewWalkerKeyFrame
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.frame = value as! CGRect
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyLeading
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.leading = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyTraing
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.traing = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyTop
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.top = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyBottom
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.bottom = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyWidth
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.width = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyHeight
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.height = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeySize
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (value as! CGSize).width, height: (value as! CGSize).height)
                                        }
                                    }
                                    
                    }) { (success) in
                        self.slc_resetInitParams()
                    }
                }
                else
                {
                    UIView.animate(withDuration: self.slc_layer_animateDuration!,
                                   delay: self.slc_layer_delay!,
                                   options: self.slc_layer_options!,
                                   animations: {
                                    
                                    if self.slc_layer_frame_keypath == UIViewWalkerKeyFrame
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.frame = value as! CGRect
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyLeading
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.leading = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyTraing
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.traing = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyTop
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.top = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyBottom
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.bottom = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyWidth
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.width = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeyHeight
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.height = value as! CGFloat
                                        }
                                    }
                                    else if self.slc_layer_frame_keypath == UIViewWalkerKeySize
                                    {
                                        if let value = self.slc_layer_to
                                        {
                                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (value as! CGSize).width, height: (value as! CGSize).height)
                                        }
                                    }
                    }) { (success) in
                        self.slc_resetInitParams()
                    }
                }
            }
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        self.slc_resetInitParams()
    }
    
    private func slc_resetInitParams()
    {
        if let value = self.completion
        {
            value(self.slc_layer_walker!)
        }
    }
}
