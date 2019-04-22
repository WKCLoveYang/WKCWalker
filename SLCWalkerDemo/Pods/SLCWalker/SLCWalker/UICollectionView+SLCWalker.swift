//
//  UICollectionView+SLCWalker.swift
//  SLCWalker
//
//  Created by WeiKunChao on 2019/4/1.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

private enum SLCCollectionReload: Int
{
    case visible = 0, fixed
}

private enum SLCCollectionTransition: Int
{
    case  none = 0, content, from
}

private var SLCCollrctionViewCompletionKey: String = "slc.collection.completion"
private var SLCCollrctionViewAnimation: String = "slc.collection.animation"
private var SLCCollrctionViewReload: String = "slc.collection.reload"
private var SLCCollrctionViewTransition: String = "slc.collection.transition"
private var SLCCollrctionViewSpring: String = "slc.collection.spring"
private var SLCCollrctionViewDuration: String = "slc.collection.duration"
private var SLCCollrctionViewDelay: String = "slc.collection.delay"
private var SLCCollrctionViewIndexPath: String = "slc.collection.indexPath"
private var SLCCollrctionViewTransitionTo: String = "slc.collection.transition.to"
private var SLCCollrctionViewTransitionAnimation: String = "slc.collection.transition.animation"
private var SLCCollrctionViewHeader: String = "slc.collection.header"
private var SLCCollrctionViewFooter: String = "slc.collection.footer"


private var collectionView_to: CGAffineTransform = CGAffineTransform.identity
private var collectionView_totalItemCount: Int = 0

extension UICollectionView
{
    private var slc_collectionView_animation: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewAnimation) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_collectionView_reload: SLCCollectionReload?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewReload) as? SLCCollectionReload
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewReload, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_collectionView_transition: SLCCollectionTransition?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewTransition) as? SLCCollectionTransition
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewTransition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_collectionView_spring: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewSpring) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewSpring, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var slc_collectionView_duration: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewDuration) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewDuration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_collectionView_delay: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewDelay) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewDelay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_collectionView_indexPath: IndexPath?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewIndexPath) as? IndexPath
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewIndexPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var slc_collectionView_transirion_to: UIView?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewTransitionTo) as? UIView
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewTransitionTo, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var slc_collectionView_transitionAnimation: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewTransitionAnimation) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewTransitionAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_collectionView_header: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewHeader) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewHeader, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var slc_collectionView_footer: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewFooter) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
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
        self.slc_collectionView_transition = SLCCollectionTransition.from
        self.slc_collectionView_transirion_to = to
        return self
    }
    
    @discardableResult func c_itemDuration(_ duration: TimeInterval) -> UICollectionView
    {
        self.slc_collectionView_duration = duration
        return self
    }
    
    @discardableResult func c_itemDelay(_ delay: TimeInterval) -> UICollectionView
    {
        self.slc_collectionView_delay = delay
        return self
    }
    
    @discardableResult func c_headerWalker(_ walker: Bool) -> UICollectionView
    {
        self.slc_collectionView_header = walker
        return self
    }
    
    @discardableResult func c_footerWalker(_ walker: Bool) -> UICollectionView
    {
        self.slc_collectionView_footer = walker
        return self
    }
    
    func reloadDataWithWalker()
    {
        self.slc_collectionView_reload = SLCCollectionReload.visible
        self.slc_startWalker()
    }
    
    func reloadDataFixedWithDancer(_ indexPath: IndexPath)
    {
        self.slc_collectionView_reload = SLCCollectionReload.fixed
        self.slc_collectionView_indexPath = indexPath
        self.slc_startWalker()
    }
    
    var c_easeLiner: UICollectionView {
        self.slc_collectionView_animation = UIView.AnimationOptions.curveLinear
        return self
    }
    
    var c_easeInOut: UICollectionView {
        self.slc_collectionView_animation = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var c_easeIn: UICollectionView {
        self.slc_collectionView_animation = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var c_easeOut: UICollectionView {
        self.slc_collectionView_animation = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    
    
    var c_transitionFlipFromLeft: UICollectionView {
        self.slc_collectionView_transition = SLCCollectionTransition.content
        self.slc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        return self
    }
    
    var c_transitionFlipFromRight: UICollectionView {
        self.slc_collectionView_transition = SLCCollectionTransition.content
        self.slc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromRight
        return self
    }
    
    var c_transitionCurlUp: UICollectionView {
        self.slc_collectionView_transition = SLCCollectionTransition.content
        self.slc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionCurlUp
        return self
    }
    
    var c_transitionCurlDown: UICollectionView {
        self.slc_collectionView_transition = SLCCollectionTransition.content
        self.slc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionCurlDown
        return self
    }
    
    var c_transitionCrossDissolve: UICollectionView {
        self.slc_collectionView_transition = SLCCollectionTransition.content
        self.slc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionCrossDissolve
        return self
    }
    
    var c_transitionFlipFromTop: UICollectionView {
        self.slc_collectionView_transition = SLCCollectionTransition.content
        self.slc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromTop
        return self
    }
    
    var c_transitionFlipFromBottom: UICollectionView {
        self.slc_collectionView_transition = SLCCollectionTransition.content
        self.slc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromBottom
        return self
    }
    
    var c_spring: UICollectionView {
        self.slc_collectionView_spring = true
        return self
    }
    
    
    var c_completion: SLCWalkerVoidCompletion {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewCompletionKey) as! SLCWalkerVoidCompletion
        }
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    

    private func slc_initP()
    {
        if self.slc_collectionView_animation == nil
        {
            self.slc_collectionView_animation = UIView.AnimationOptions.curveLinear
        }
        
        if self.slc_collectionView_reload == nil
        {
            self.slc_collectionView_reload = SLCCollectionReload.visible
        }
        
        if self.slc_collectionView_transition == nil
        {
            self.slc_collectionView_transition = SLCCollectionTransition.none
        }
        
        if self.slc_collectionView_spring == nil
        {
            self.slc_collectionView_spring = false
        }
        
        if self.slc_collectionView_duration == nil
        {
            self.slc_collectionView_duration = 0.7
        }
        
        if self.slc_collectionView_delay == nil
        {
            self.slc_collectionView_delay = 0.1
        }
        
        if self.slc_collectionView_indexPath == nil
        {
            self.slc_collectionView_indexPath = IndexPath(item: 0, section: 0)
        }
        
        if self.slc_collectionView_transirion_to == nil
        {
            self.slc_collectionView_transirion_to = UIView()
        }
        
        if self.slc_collectionView_transitionAnimation == nil
        {
            self.slc_collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        }
        
        if self.slc_collectionView_header == nil
        {
            self.slc_collectionView_header = false
        }
        
        if self.slc_collectionView_footer == nil
        {
            self.slc_collectionView_footer = false
        }
    }
    
    private func slc_startWalker()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
        {
            self.slc_initP()
            
            switch self.slc_collectionView_reload!
            {
              case SLCCollectionReload.visible:
                self.reloadData()
                self.layoutIfNeeded()
                let selections: Int = self.numberOfSections
                for index in 0..<selections
                {
                    let header: UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: index))
                    
                    let footer: UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: index))
                    
                    let numbers: Int = self.numberOfItems(inSection: index)
                    
                    let delay:TimeInterval = Double(collectionView_totalItemCount) * self.slc_collectionView_delay!
                    
                    if let h = header, self.slc_collectionView_header!
                    {
                        switch self.slc_collectionView_transition!
                        {
                            
                        case SLCCollectionTransition.none:
                            h.transform = collectionView_to
                            if self.slc_collectionView_spring!
                            {
                                UIView.animate(withDuration: self.slc_collectionView_duration!,
                                               delay: delay,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.slc_collectionView_animation!,
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
                                UIView.animate(withDuration: self.slc_collectionView_duration!,
                                               delay: delay,
                                               options: self.slc_collectionView_animation!,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { (success) in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            
                            
                        case SLCCollectionTransition.content:
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                    UIView.transition(with: h,
                                                      duration: self.slc_collectionView_duration!,
                                                      options: self.slc_collectionView_transitionAnimation!,
                                                      animations: nil, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                                        }
                                    })
                            })
                            
                        case SLCCollectionTransition.from:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                UIView.transition(from: h,
                                                  to: self.slc_collectionView_transirion_to!,
                                                  duration: self.slc_collectionView_duration!,
                                                  options: self.slc_collectionView_transitionAnimation!, completion: { (success) in
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
                            switch self.slc_collectionView_transition!
                            {
                                case SLCCollectionTransition.none:
                                value.transform = collectionView_to
                                if self.slc_collectionView_spring!
                                {
                                    UIView.animate(withDuration: self.slc_collectionView_duration!,
                                                   delay: delay,
                                                   usingSpringWithDamping: 0.85,
                                                   initialSpringVelocity: 10.0,
                                                   options: self.slc_collectionView_animation!,
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
                                    UIView.animate(withDuration: self.slc_collectionView_duration!,
                                                   delay: self.slc_collectionView_delay!,
                                                   options: self.slc_collectionView_animation!,
                                                   animations: {
                                        cell?.transform = CGAffineTransform.identity
                                    }, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                        }
                                    })
                                }
                                
                                case SLCCollectionTransition.content:
                                
                                    if let value = cell
                                    {
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                            {
                                                UIView.transition(with: value,
                                                                  duration: self.slc_collectionView_duration!,
                                                                  options: self.slc_collectionView_transitionAnimation!,
                                                                  animations: nil,
                                                                  completion: { (success) in
                                                    if let c = self.c_completion
                                                    {
                                                        c()
                                                    }
                                                })
                                        })
                                        
                                    }
                                
                                case SLCCollectionTransition.from:
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                        {
                                            UIView.transition(from: value, to: self.slc_collectionView_transirion_to!, duration: self.slc_collectionView_duration!, options: self.slc_collectionView_transitionAnimation!, completion: { (success) in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                                            })
                                    })
                            }
                            
                            collectionView_totalItemCount += 1
                        }
                        
                        if let f = footer, self.slc_collectionView_footer!
                        {
                            switch self.slc_collectionView_transition!
                            {
                            case SLCCollectionTransition.none:
                                f.transform = collectionView_to
                                if self.slc_collectionView_spring!
                                {
                                    UIView.animate(withDuration: self.slc_collectionView_duration!,
                                                   delay: delay,
                                                   usingSpringWithDamping: 0.85,
                                                   initialSpringVelocity: 10.0,
                                                   options: self.slc_collectionView_animation!,
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
                                    UIView.animate(withDuration: self.slc_collectionView_duration!,
                                                   delay: delay,
                                                   options: self.slc_collectionView_animation!,
                                                   animations: {
                                                    f.transform = CGAffineTransform.identity
                                    }, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                        }
                                    })
                                }
                                
                            case SLCCollectionTransition.content:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                    UIView.transition(with: f,
                                                      duration: self.slc_collectionView_duration!,
                                                      options: self.slc_collectionView_transitionAnimation!,
                                                      animations: nil, completion: { (success) in
                                                        if let c = self.c_completion
                                                        {
                                                            c()
                                                        }
                                    })
                                })
                                
                            case SLCCollectionTransition.from:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                    UIView.transition(from: f,
                                                      to: self.slc_collectionView_transirion_to!,
                                                      duration: self.slc_collectionView_duration!,
                                                      options: self.slc_collectionView_transitionAnimation!,
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
                
                let header: UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: self.slc_collectionView_indexPath!)
                
                let footer:UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: self.slc_collectionView_indexPath!)
                
                let cell: UICollectionViewCell? = self.cellForItem(at: self.slc_collectionView_indexPath!)
                
                if self.slc_collectionView_header! || self.slc_collectionView_footer!
                {
                    if let h = header, self.slc_collectionView_header!
                    {
                        switch self.slc_collectionView_transition!
                        {
                        case SLCCollectionTransition.none:
                            h.transform = collectionView_to
                            if self.slc_collectionView_spring!
                            {
                                UIView.animate(withDuration: self.slc_collectionView_duration!,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.slc_collectionView_animation!,
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
                                UIView.animate(withDuration: self.slc_collectionView_duration!,
                                               delay: 0,
                                               options: self.slc_collectionView_animation!,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { (success) in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            
                        case SLCCollectionTransition.content:
                            UIView.transition(with: h,
                                              duration: self.slc_collectionView_duration!,
                                              options: self.slc_collectionView_animation!,
                                              animations: nil,
                                              completion: { (success) in
                                if let c = self.c_completion
                                {
                                    c()
                                }
                            })
                            
                        case SLCCollectionTransition.from:
                            UIView.transition(from: h,
                                              to: self.slc_collectionView_transirion_to!,
                                              duration: self.slc_collectionView_duration!,
                                              options: self.slc_collectionView_transitionAnimation!,
                                              completion: { (success) in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                            })
                        }
                    }
                }
                
                if let f = footer, self.slc_collectionView_footer!
                {
                    switch self.slc_collectionView_transition!
                    {
                    case SLCCollectionTransition.none:
                        f.transform = collectionView_to
                        if self.slc_collectionView_spring!
                        {
                            UIView.animate(withDuration: self.slc_collectionView_duration!,
                                           delay: 0,
                                           usingSpringWithDamping: 0.85,
                                           initialSpringVelocity: 10.0,
                                           options: self.slc_collectionView_animation!,
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
                            UIView.animate(withDuration: self.slc_collectionView_duration!,
                                           delay: 0,
                                           options: self.slc_collectionView_animation!,
                                           animations: {
                                f.transform = CGAffineTransform.identity
                            }, completion: { (success) in
                                if let c = self.c_completion
                                {
                                    c()
                                }
                            })
                        }
                        
                    case SLCCollectionTransition.content:
                        UIView.transition(with: f,
                                          duration: self.slc_collectionView_duration!,
                                          options: self.slc_collectionView_transitionAnimation!,
                                          animations: nil,
                                          completion: { _ in
                                            if let c = self.c_completion
                                            {
                                                c()
                                            }
                        })
                        
                    case SLCCollectionTransition.from:
                        UIView.transition(from: f,
                                          to: self.slc_collectionView_transirion_to!,
                                          duration: self.slc_collectionView_duration!,
                                          options: self.slc_collectionView_transitionAnimation!,
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
                        switch self.slc_collectionView_transition!
                        {
                        case SLCCollectionTransition.none:
                            cc.transform = collectionView_to
                            if self.slc_collectionView_spring!
                            {
                                UIView.animate(withDuration: self.slc_collectionView_duration!,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.slc_collectionView_animation!,
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
                                UIView.animate(withDuration: self.slc_collectionView_duration!,
                                               delay: 0,
                                               options: self.slc_collectionView_animation!,
                                               animations: {
                                                cc.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            
                            
                        case SLCCollectionTransition.content:
                            UIView.transition(with: cc,
                                              duration: self.slc_collectionView_duration!,
                                              options: self.slc_collectionView_transitionAnimation!,
                                              animations: nil, completion: { _ in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                            })
                            
                        case SLCCollectionTransition.from:
                            UIView.transition(from: cc,
                                              to: self.slc_collectionView_transirion_to!,
                                              duration: self.slc_collectionView_duration!,
                                              options: self.slc_collectionView_transitionAnimation!,
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
