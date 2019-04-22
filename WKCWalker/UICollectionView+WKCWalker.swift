//
//  UICollectionView+WKCWalker.swift
//  WKCWalker
//
//  Created by WeiKunChao on 2019/4/1.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

private enum WKCCollectionReload: Int
{
    case visible = 0, fixed
}

private enum WKCCollectionTransition: Int
{
    case  none = 0, content, from
}

private var WKCCollrctionViewCompletionKey: String = "wkc.collection.completion"
private var WKCCollrctionViewAnimation: String = "wkc.collection.animation"
private var WKCCollrctionViewReload: String = "wkc.collection.reload"
private var WKCCollrctionViewTransition: String = "wkc.collection.transition"
private var WKCCollrctionViewSpring: String = "wkc.collection.spring"
private var WKCCollrctionViewDuration: String = "wkc.collection.duration"
private var WKCCollrctionViewDelay: String = "wkc.collection.delay"
private var WKCCollrctionViewIndexPath: String = "wkc.collection.indexPath"
private var WKCCollrctionViewTransitionTo: String = "wkc.collection.transition.to"
private var WKCCollrctionViewTransitionAnimation: String = "wkc.collection.transition.animation"
private var WKCCollrctionViewHeader: String = "wkc.collection.header"
private var WKCCollrctionViewFooter: String = "wkc.collection.footer"


private var collectionView_to: CGAffineTransform = CGAffineTransform.identity
private var collectionView_totalItemCount: Int = 0

extension UICollectionView
{
    private var wkc_collectionView_animation: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewAnimation) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_collectionView_reload: WKCCollectionReload?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewReload) as? WKCCollectionReload
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewReload, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_collectionView_transition: WKCCollectionTransition?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewTransition) as? WKCCollectionTransition
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewTransition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_collectionView_spring: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewSpring) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewSpring, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var wkc_collectionView_duration: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewDuration) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewDuration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_collectionView_delay: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewDelay) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewDelay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_collectionView_indexPath: IndexPath?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewIndexPath) as? IndexPath
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewIndexPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var wkc_collectionView_transirion_to: UIView?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewTransitionTo) as? UIView
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewTransitionTo, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var wkc_collectionView_transitionAnimation: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewTransitionAnimation) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewTransitionAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_collectionView_header: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewHeader) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewHeader, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var wkc_collectionView_footer: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewFooter) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}


public extension UICollectionView
{

    // MARK: -MAKE
    @discardableResult func c_makeScale(_ scale: CGFloat) -> UICollectionView
    {
        collectionView_to = CGAffineTransform(scaleX: scale, y: scale)
        return self
    }
    
    @discardableResult func c_makeScaleX(_ scaleX: CGFloat) -> UICollectionView
    {
        collectionView_to = CGAffineTransform(scaleX: scaleX, y: 1.0)
        return self
    }
    
    @discardableResult func c_makeScaleY(_ scaleY: CGFloat) -> UICollectionView
    {
        collectionView_to = CGAffineTransform(scaleX: 1.0, y: scaleY)
        return self
    }
    
    @discardableResult func c_makeRotation(_ rotation: CGFloat) -> UICollectionView
    {
        collectionView_to = CGAffineTransform(rotationAngle: rotation)
        return self
    }
    
    @discardableResult func c_moveX(_ x: CGFloat) -> UICollectionView
    {
        collectionView_to = CGAffineTransform(translationX: x, y: 0)
        return self
    }
    
    @discardableResult func c_moveY(_ y: CGFloat) -> UICollectionView
    {
        collectionView_to = CGAffineTransform(translationX: 0, y: y)
        return self
    }
    
    @discardableResult func c_moveXY(_ xy: CGPoint) -> UICollectionView
    {
        collectionView_to = CGAffineTransform(translationX: xy.x, y: xy.y)
        return self
    }
    
    @discardableResult func c_transitionTo(_ to: UIView) -> UICollectionView
    {
        self.wkc_collectionView_transition = WKCCollectionTransition.from
        self.wkc_collectionView_transirion_to = to
        return self
    }
    
    @discardableResult func c_itemDuration(_ duration: TimeInterval) -> UICollectionView
    {
        self.wkc_collectionView_duration = duration
        return self
    }
    
    @discardableResult func c_itemDelay(_ delay: TimeInterval) -> UICollectionView
    {
        self.wkc_collectionView_delay = delay
        return self
    }
    
    @discardableResult func c_headerWalker(_ walker: Bool) -> UICollectionView
    {
        self.wkc_collectionView_header = walker
        return self
    }
    
    @discardableResult func c_footerWalker(_ walker: Bool) -> UICollectionView
    {
        self.wkc_collectionView_footer = walker
        return self
    }
    
    func reloadDataWithWalker()
    {
        self.wkc_collectionView_reload = WKCCollectionReload.visible
        self.wkc_startWalker()
    }
    
    func reloadDataFixedWithDancer(_ indexPath: IndexPath)
    {
        self.wkc_collectionView_reload = WKCCollectionReload.fixed
        self.wkc_collectionView_indexPath = indexPath
        self.wkc_startWalker()
    }
    
    var c_easeLiner: UICollectionView {
        self.wkc_collectionView_animation = UIView.AnimationOptions.curveLinear
        return self
    }
    
    var c_easeInOut: UICollectionView {
        self.wkc_collectionView_animation = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var c_easeIn: UICollectionView {
        self.wkc_collectionView_animation = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var c_easeOut: UICollectionView {
        self.wkc_collectionView_animation = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    
    
    var c_transitionFlipFromLeft: UICollectionView {
        self.wkc_collectionView_transition = WKCCollectionTransition.content
        self.wkc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        return self
    }
    
    var c_transitionFlipFromRight: UICollectionView {
        self.wkc_collectionView_transition = WKCCollectionTransition.content
        self.wkc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromRight
        return self
    }
    
    var c_transitionCurlUp: UICollectionView {
        self.wkc_collectionView_transition = WKCCollectionTransition.content
        self.wkc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionCurlUp
        return self
    }
    
    var c_transitionCurlDown: UICollectionView {
        self.wkc_collectionView_transition = WKCCollectionTransition.content
        self.wkc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionCurlDown
        return self
    }
    
    var c_transitionCrossDissolve: UICollectionView {
        self.wkc_collectionView_transition = WKCCollectionTransition.content
        self.wkc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionCrossDissolve
        return self
    }
    
    var c_transitionFlipFromTop: UICollectionView {
        self.wkc_collectionView_transition = WKCCollectionTransition.content
        self.wkc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromTop
        return self
    }
    
    var c_transitionFlipFromBottom: UICollectionView {
        self.wkc_collectionView_transition = WKCCollectionTransition.content
        self.wkc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromBottom
        return self
    }
    
    var c_spring: UICollectionView {
        self.wkc_collectionView_spring = true
        return self
    }
    
    
    var c_completion: WKCWalkerVoidCompletion {
        get {
            return objc_getAssociatedObject(self, &WKCCollrctionViewCompletionKey) as! WKCWalkerVoidCompletion
        }
        set {
            objc_setAssociatedObject(self, &WKCCollrctionViewCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    

    private func wkc_initP()
    {
        if self.wkc_collectionView_animation == nil
        {
            self.wkc_collectionView_animation = UIView.AnimationOptions.curveLinear
        }
        
        if self.wkc_collectionView_reload == nil
        {
            self.wkc_collectionView_reload = WKCCollectionReload.visible
        }
        
        if self.wkc_collectionView_transition == nil
        {
            self.wkc_collectionView_transition = WKCCollectionTransition.none
        }
        
        if self.wkc_collectionView_spring == nil
        {
            self.wkc_collectionView_spring = false
        }
        
        if self.wkc_collectionView_duration == nil
        {
            self.wkc_collectionView_duration = 0.7
        }
        
        if self.wkc_collectionView_delay == nil
        {
            self.wkc_collectionView_delay = 0.1
        }
        
        if self.wkc_collectionView_indexPath == nil
        {
            self.wkc_collectionView_indexPath = IndexPath(item: 0, section: 0)
        }
        
        if self.wkc_collectionView_transirion_to == nil
        {
            self.wkc_collectionView_transirion_to = UIView()
        }
        
        if self.wkc_collectionView_transitionAnimation == nil
        {
            self.wkc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        }
        
        if self.wkc_collectionView_header == nil
        {
            self.wkc_collectionView_header = false
        }
        
        if self.wkc_collectionView_footer == nil
        {
            self.wkc_collectionView_footer = false
        }
    }
    
    private func wkc_startWalker()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
        {
            self.wkc_initP()
            
            switch self.wkc_collectionView_reload!
            {
              case WKCCollectionReload.visible:
                self.reloadData()
                self.layoutIfNeeded()
                let selections: Int = self.numberOfSections
                for index in 0..<selections
                {
                    let header: UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: index))
                    
                    let footer: UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: index))
                    
                    let numbers: Int = self.numberOfItems(inSection: index)
                    
                    let delay:TimeInterval = Double(collectionView_totalItemCount) * self.wkc_collectionView_delay!
                    
                    if let h = header, self.wkc_collectionView_header!
                    {
                        switch self.wkc_collectionView_transition!
                        {
                            
                        case WKCCollectionTransition.none:
                            h.transform = collectionView_to
                            if self.wkc_collectionView_spring!
                            {
                                UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                               delay: delay,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.wkc_collectionView_animation!,
                                               animations: {
                                h.transform = CGAffineTransform.identity
                                }, completion: { (success) in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                               delay: delay,
                                               options: self.wkc_collectionView_animation!,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { (success) in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            
                            
                        case WKCCollectionTransition.content:
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                    UIView.transition(with: h,
                                                      duration: self.wkc_collectionView_duration!,
                                                      options: self.wkc_collectionView_transitionAnimation!,
                                                      animations: nil, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                                        }
                                    })
                            })
                            
                        case WKCCollectionTransition.from:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                UIView.transition(from: h,
                                                  to: self.wkc_collectionView_transirion_to!,
                                                  duration: self.wkc_collectionView_duration!,
                                                  options: self.wkc_collectionView_transitionAnimation!, completion: { (success) in
                                                    if let c = self.c_completion
                                                    {
                                                        c()
                                                    }
                                })
                            })
                        }
                        
                        collectionView_totalItemCount += 1
                    }
                    
                    
                    for indexRow in 0..<numbers
                    {
                        let cell: UICollectionViewCell? = self.cellForItem(at: IndexPath(item: indexRow, section: index))
                        
                        if let value = cell
                        {
                            switch self.wkc_collectionView_transition!
                            {
                                case WKCCollectionTransition.none:
                                value.transform = collectionView_to
                                if self.wkc_collectionView_spring!
                                {
                                    UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                                   delay: delay,
                                                   usingSpringWithDamping: 0.85,
                                                   initialSpringVelocity: 10.0,
                                                   options: self.wkc_collectionView_animation!,
                                                   animations: {
                                        cell?.transform = CGAffineTransform.identity
                                    }, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                        }
                                    })
                                }
                                else
                                {
                                    UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                                   delay: self.wkc_collectionView_delay!,
                                                   options: self.wkc_collectionView_animation!,
                                                   animations: {
                                        cell?.transform = CGAffineTransform.identity
                                    }, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                        }
                                    })
                                }
                                
                                case WKCCollectionTransition.content:
                                
                                    if let value = cell
                                    {
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                            {
                                                UIView.transition(with: value,
                                                                  duration: self.wkc_collectionView_duration!,
                                                                  options: self.wkc_collectionView_transitionAnimation!,
                                                                  animations: nil,
                                                                  completion: { (success) in
                                                    if let c = self.c_completion
                                                    {
                                                        c()
                                                    }
                                                })
                                        })
                                        
                                    }
                                
                                case WKCCollectionTransition.from:
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                        {
                                            UIView.transition(from: value, to: self.wkc_collectionView_transirion_to!, duration: self.wkc_collectionView_duration!, options: self.wkc_collectionView_transitionAnimation!, completion: { (success) in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                                            })
                                    })
                            }
                            
                            collectionView_totalItemCount += 1
                        }
                        
                        if let f = footer, self.wkc_collectionView_footer!
                        {
                            switch self.wkc_collectionView_transition!
                            {
                            case WKCCollectionTransition.none:
                                f.transform = collectionView_to
                                if self.wkc_collectionView_spring!
                                {
                                    UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                                   delay: delay,
                                                   usingSpringWithDamping: 0.85,
                                                   initialSpringVelocity: 10.0,
                                                   options: self.wkc_collectionView_animation!,
                                                   animations: {
                                        f.transform = CGAffineTransform.identity
                                    }, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                        }
                                    })
                                }
                                else
                                {
                                    UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                                   delay: delay,
                                                   options: self.wkc_collectionView_animation!,
                                                   animations: {
                                                    f.transform = CGAffineTransform.identity
                                    }, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                        }
                                    })
                                }
                                
                            case WKCCollectionTransition.content:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                    UIView.transition(with: f,
                                                      duration: self.wkc_collectionView_duration!,
                                                      options: self.wkc_collectionView_transitionAnimation!,
                                                      animations: nil, completion: { (success) in
                                                        if let c = self.c_completion
                                                        {
                                                            c()
                                                        }
                                    })
                                })
                                
                            case WKCCollectionTransition.from:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                    UIView.transition(from: f,
                                                      to: self.wkc_collectionView_transirion_to!,
                                                      duration: self.wkc_collectionView_duration!,
                                                      options: self.wkc_collectionView_transitionAnimation!,
                                                      completion: { (success) in
                                                        if let c = self.c_completion
                                                        {
                                                            c()
                                                        }
                                    })
                                })
                            }
                        }
                        
                        collectionView_totalItemCount += 1
                    }
                    
                }
            default:
                self.reloadData()
                self.layoutIfNeeded()
                
                let header: UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: self.wkc_collectionView_indexPath!)
                
                let footer:UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: self.wkc_collectionView_indexPath!)
                
                let cell: UICollectionViewCell? = self.cellForItem(at: self.wkc_collectionView_indexPath!)
                
                if self.wkc_collectionView_header! || self.wkc_collectionView_footer!
                {
                    if let h = header, self.wkc_collectionView_header!
                    {
                        switch self.wkc_collectionView_transition!
                        {
                        case WKCCollectionTransition.none:
                            h.transform = collectionView_to
                            if self.wkc_collectionView_spring!
                            {
                                UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.wkc_collectionView_animation!,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { (success) in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                               delay: 0,
                                               options: self.wkc_collectionView_animation!,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { (success) in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            
                        case WKCCollectionTransition.content:
                            UIView.transition(with: h,
                                              duration: self.wkc_collectionView_duration!,
                                              options: self.wkc_collectionView_animation!,
                                              animations: nil,
                                              completion: { (success) in
                                if let c = self.c_completion
                                {
                                    c()
                                }
                            })
                            
                        case WKCCollectionTransition.from:
                            UIView.transition(from: h,
                                              to: self.wkc_collectionView_transirion_to!,
                                              duration: self.wkc_collectionView_duration!,
                                              options: self.wkc_collectionView_transitionAnimation!,
                                              completion: { (success) in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                            })
                        }
                    }
                }
                
                if let f = footer, self.wkc_collectionView_footer!
                {
                    switch self.wkc_collectionView_transition!
                    {
                    case WKCCollectionTransition.none:
                        f.transform = collectionView_to
                        if self.wkc_collectionView_spring!
                        {
                            UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                           delay: 0,
                                           usingSpringWithDamping: 0.85,
                                           initialSpringVelocity: 10.0,
                                           options: self.wkc_collectionView_animation!,
                                           animations: {
                                            f.transform = CGAffineTransform.identity
                            }, completion: { (success) in
                                if let c = self.c_completion
                                {
                                    c()
                                }
                            })
                        }
                        else
                        {
                            UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                           delay: 0,
                                           options: self.wkc_collectionView_animation!,
                                           animations: {
                                f.transform = CGAffineTransform.identity
                            }, completion: { (success) in
                                if let c = self.c_completion
                                {
                                    c()
                                }
                            })
                        }
                        
                    case WKCCollectionTransition.content:
                        UIView.transition(with: f,
                                          duration: self.wkc_collectionView_duration!,
                                          options: self.wkc_collectionView_transitionAnimation!,
                                          animations: nil,
                                          completion: { _ in
                                            if let c = self.c_completion
                                            {
                                                c()
                                            }
                        })
                        
                    case WKCCollectionTransition.from:
                        UIView.transition(from: f,
                                          to: self.wkc_collectionView_transirion_to!,
                                          duration: self.wkc_collectionView_duration!,
                                          options: self.wkc_collectionView_transitionAnimation!,
                                          completion: { _ in
                                            if let c = self.c_completion
                                            {
                                                c()
                                            }
                        })
                        
                    }
                }
                else
                {
                    if let cc = cell
                    {
                        switch self.wkc_collectionView_transition!
                        {
                        case WKCCollectionTransition.none:
                            cc.transform = collectionView_to
                            if self.wkc_collectionView_spring!
                            {
                                UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.wkc_collectionView_animation!,
                                               animations: {
                                                cc.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: self.wkc_collectionView_duration!,
                                               delay: 0,
                                               options: self.wkc_collectionView_animation!,
                                               animations: {
                                                cc.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            
                            
                        case WKCCollectionTransition.content:
                            UIView.transition(with: cc,
                                              duration: self.wkc_collectionView_duration!,
                                              options: self.wkc_collectionView_transitionAnimation!,
                                              animations: nil, completion: { _ in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                            })
                            
                        case WKCCollectionTransition.from:
                            UIView.transition(from: cc,
                                              to: self.wkc_collectionView_transirion_to!,
                                              duration: self.wkc_collectionView_duration!,
                                              options: self.wkc_collectionView_transitionAnimation!,
                                              completion: { _ in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                            })
                            
                        }
                    }
                }
                
                
                break
            }
        }
    }
}
