//
//  UITableView+SLCWalker.swift
//  SLCWalker
//
//  Created by WeiKunChao on 2019/4/1.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

private enum SLCTableViewReload: Int
{
    case visible = 0, fixed
}

private enum SLCTableViewTransition: Int
{
    case none = 0, content, from
}

private var SLCTableViewCompletionKey: String = "slc.tableView.completion"
private var SLCTableViewAnimation: String = "slc.tableView.animation"
private var SLCTableViewReloadType: String = "slc.tableView.reload"
private var SLCTableViewTransitionType: String = "slc.tableView.transition"
private var SLCTableViewSpringType: String = "slc.tableView.spring"
private var SLCTableViewDuration: String = "slc.tableView.duration"
private var SLCTableViewDelay: String = "slc.tableView.delay"
private var SLCTableViewIndexPath: String = "slc.tableView.indexPath"
private var SLCTableViewTransitionTo: String = "slc.tableView.transitionTo"
private var SLCTableViewTransitionAnimation: String = "slc.tableView.transitionAnimation"
private var SLCTableViewHeader: String = "slc.tableView.header"
private var SLCTableViewFooter: String = "slc.tableView.header"

private var tableView_to: CGAffineTransform = CGAffineTransform.identity
private var tableView_totalItemsCount: Int = 0


extension UITableView
{
    private var slc_tableView_animation: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewAnimation) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_tableView_reload: SLCTableViewReload?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewReloadType) as? SLCTableViewReload
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewReloadType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
    private var slc_tableView_transition: SLCTableViewTransition?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewTransitionType) as? SLCTableViewTransition
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewTransitionType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_tableView_spring: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewSpringType) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewSpringType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var slc_tableView_duration: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewDuration) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewDuration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_tableView_delay: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewDelay) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewDelay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_tableView_indexPath: IndexPath?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewIndexPath) as? IndexPath
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewIndexPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var slc_tableView_transitionTo: UIView?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewTransitionTo) as? UIView
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewTransitionTo, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var slc_tableView_transitionAnimation: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewTransitionAnimation) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewTransitionAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var slc_tableView_header: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewHeader) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewHeader, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var slc_tableView_footer: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewFooter) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SLCTableViewFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
}

public extension UITableView
{
    @discardableResult func t_makeScale(_ scale: CGFloat) -> UITableView
    {
        tableView_to = CGAffineTransform(scaleX: scale, y: scale)
        return self
    }
    
    @discardableResult func t_makeScaleX(_ scaleX: CGFloat) -> UITableView
    {
        tableView_to = CGAffineTransform(scaleX: scaleX, y: 1.0)
        return self
    }
    
    @discardableResult func t_makeScaleY(_ scaleY: CGFloat) -> UITableView
    {
        tableView_to = CGAffineTransform(scaleX: 1.0, y: scaleY)
        return self
    }
    
    @discardableResult func t_makeRotation(_ rotation: CGFloat) -> UITableView
    {
        tableView_to = CGAffineTransform(rotationAngle: rotation)
        return self
    }
    
    
    
    @discardableResult func t_moveX(_ x: CGFloat) -> UITableView
    {
        tableView_to = CGAffineTransform(translationX: x, y: 0)
        return self
    }
    
    @discardableResult func t_moveY(_ y: CGFloat) -> UITableView
    {
        tableView_to = CGAffineTransform(translationX: 0, y: y)
        return self
    }
    
    @discardableResult func t_moveXY(_ xy: CGPoint) -> UITableView
    {
        tableView_to = CGAffineTransform(translationX: xy.x, y: xy.y)
        return self
    }
    
    
    
    
    @discardableResult func t_transitionTo(_ to: UIView) -> UITableView
    {
        self.slc_tableView_transition = SLCTableViewTransition.from
        self.slc_tableView_transitionTo = to
        return self
    }
    
    @discardableResult func t_itemDuration(_ duration: TimeInterval) -> UITableView
    {
        self.slc_tableView_duration = duration
        return self
    }
    
    @discardableResult func t_itemDelay(_ delay: TimeInterval) -> UITableView
    {
        self.slc_tableView_delay = delay
        return self
    }
    
    
    @discardableResult func headerWalker(_ walker: Bool) -> UITableView
    {
        self.slc_tableView_header = walker
        return self
    }
    
    @discardableResult func footerWalker(_ walker: Bool) -> UITableView
    {
        self.slc_tableView_footer = walker
        return self
    }
    
    
    func reloadDataWithWalker()
    {
        self.slc_tableView_reload = SLCTableViewReload.visible
        self.slc_startWalker()
    }
    
    func reloadDataFixedWithWalker(_ indexPath: IndexPath)
    {
        self.slc_tableView_reload = SLCTableViewReload.fixed
        self.slc_tableView_indexPath = indexPath
        self.slc_startWalker()
    }
    
    
    
    
    
    var t_easeLiner: UITableView {
        self.slc_tableView_animation = UIView.AnimationOptions.curveLinear
        return self
    }
    
    var t_easeInOut: UITableView {
        self.slc_tableView_animation = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var t_easeIn: UITableView {
        self.slc_tableView_animation = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var t_easeOut: UITableView {
        self.slc_tableView_animation = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    var t_transitionFlipFromLeft: UITableView {
        self.slc_tableView_transition = SLCTableViewTransition.content
        self.slc_tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        return self
    }
    
    var t_transitionFlipFromRight: UITableView {
        self.slc_tableView_transition = SLCTableViewTransition.content
        self.slc_tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromRight
        return self
    }
    
    var t_transitionCurlUp: UITableView {
        self.slc_tableView_transition = SLCTableViewTransition.content
        self.slc_tableView_transitionAnimation = UIView.AnimationOptions.transitionCurlUp
        return self
    }
    
    var t_transitionCurDown: UITableView {
        self.slc_tableView_transition = SLCTableViewTransition.content
        self.slc_tableView_transitionAnimation = UIView.AnimationOptions.transitionCurlDown
        return self
    }
    
    var t_transitionCrossDissolve: UITableView {
        self.slc_tableView_transition = SLCTableViewTransition.content
        self.slc_tableView_transitionAnimation = UIView.AnimationOptions.transitionCrossDissolve
        return self
    }
    
    var t_transitionFlipFromTop: UITableView {
        self.slc_tableView_transition = SLCTableViewTransition.content
        self.slc_tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromTop
        return self
    }
    
    var t_transitionFlipFromBottom: UITableView {
        self.slc_tableView_transition = SLCTableViewTransition.content
        self.slc_tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromBottom
        return self
    }
    
    var t_spring: UITableView {
        self.slc_tableView_spring = true
        return self
    }
    
    var t_completion: SLCWalkerVoidCompletion {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewCompletionKey) as! SLCWalkerVoidCompletion
        }
        set {
            objc_setAssociatedObject(self, &SLCTableViewCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    

    private func slc_initParams()
    {
        if self.slc_tableView_animation == nil
        {
            self.slc_tableView_animation = UIView.AnimationOptions.curveLinear
        }
        
        if self.slc_tableView_reload == nil
        {
            self.slc_tableView_reload = SLCTableViewReload.visible
        }
        
        if self.slc_tableView_transition == nil
        {
            self.slc_tableView_transition = SLCTableViewTransition.none
        }
        
        if self.slc_tableView_spring == nil
        {
            self.slc_tableView_spring = false
        }
        
        if self.slc_tableView_duration == nil
        {
            self.slc_tableView_duration = 0.7
        }
        
        if self.slc_tableView_delay == nil
        {
            self.slc_tableView_delay = 0.1
        }
        
        if self.slc_tableView_indexPath == nil
        {
            self.slc_tableView_indexPath = IndexPath(row: 0, section: 0)
        }
        
        if self.slc_tableView_transitionTo == nil
        {
            self.slc_tableView_transitionTo = UIView()
        }
        
        if self.slc_tableView_transitionAnimation == nil
        {
            self.slc_tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        }
        
        if self.slc_tableView_header == nil
        {
            self.slc_tableView_header = false
        }
        
        if self.slc_tableView_footer == nil
        {
            self.slc_tableView_footer = false
        }
    }
    
    
    private func slc_startWalker()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
        {
            self.slc_initParams()
            
            switch self.slc_tableView_reload!
            {
            case SLCTableViewReload.visible:
                self.reloadData()
                self.layoutIfNeeded()
                
                let sections: Int = self.numberOfSections
                
                for index in 0..<sections
                {
                    let header: UITableViewHeaderFooterView? = self.headerView(forSection: index)
                    let footer: UITableViewHeaderFooterView? = self.footerView(forSection: index)
                    
                    let numbers: Int = self.numberOfRows(inSection: index)
                    
                    let delay: TimeInterval = Double(tableView_totalItemsCount) * self.slc_tableView_delay!
                    
                    if let h = header, self.slc_tableView_header!
                    {
                        switch self.slc_tableView_transition!
                        {
                        case SLCTableViewTransition.none:
                            h.transform = tableView_to
                            if self.slc_tableView_spring!
                            {
                             UIView.animate(withDuration: self.slc_tableView_duration!,
                                            delay: delay,
                                            usingSpringWithDamping: 0.85,
                                            initialSpringVelocity: 10.0,
                                            options: self.slc_tableView_animation!,
                                            animations: {
                                                h.transform = CGAffineTransform.identity
                             },
                                            completion: { _ in
                                               if let t = self.t_completion
                                               {
                                                t()
                                                }
                             })
                            }
                            else
                            {
                                UIView.animate(withDuration: self.slc_tableView_duration!,
                                               delay: delay,
                                               options: self.slc_tableView_animation!,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let t = self.t_completion
                                    {
                                        t()
                                    }
                                })
                            }
                            
                        case SLCTableViewTransition.content:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                UIView.transition(with: h,
                                                  duration: self.slc_tableView_duration!,
                                                  options: self.slc_tableView_transitionAnimation!,
                                                  animations: nil,
                                                  completion: { _ in
                                                    if let t = self.t_completion
                                                    {
                                                        t()
                                                    }
                                })
                            })
                            
                            
                        case SLCTableViewTransition.from:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                UIView.transition(from: h,
                                                  to: self.slc_tableView_transitionTo!,
                                                  duration: self.slc_tableView_duration!,
                                                  options: self.slc_tableView_transitionAnimation!,
                                                  completion: { _ in
                                                    if let t = self.t_completion
                                                    {
                                                        t()
                                                    }
                                })
                            })
                        }
                        
                        tableView_totalItemsCount += 1
                    }
                    
                    for indexRow in 0..<numbers
                    {
                        let cell: UITableViewCell? = self.cellForRow(at: IndexPath(row: indexRow, section: index))
                        if let c = cell
                        {
                            switch self.slc_tableView_transition!
                            {
                            case SLCTableViewTransition.none:
                                c.transform = tableView_to
                                if self.slc_tableView_spring!
                                {
                                    UIView.animate(withDuration: self.slc_tableView_duration!,
                                                   delay: delay,
                                                   usingSpringWithDamping: 0.85,
                                                   initialSpringVelocity: 10.0,
                                                   options: self.slc_tableView_animation!,
                                                   animations: {
                                                    c.transform = CGAffineTransform.identity
                                    }, completion: { _ in
                                        if let t = self.t_completion
                                        {
                                            t()
                                        }
                                    })
                                }
                                else
                                {
                                    UIView.animate(withDuration: self.slc_tableView_duration!,
                                                   delay: delay,
                                                   options: self.slc_tableView_animation!,
                                                   animations: {
                                                    c.transform = CGAffineTransform.identity
                                    }, completion: { _ in
                                        if let t = self.t_completion
                                        {
                                            t()
                                        }
                                    })
                                }
                                
                            case SLCTableViewTransition.content:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                        UIView.transition(with: c,
                                                          duration: self.slc_tableView_duration!,
                                                          options: self.slc_tableView_transitionAnimation!,
                                                          animations: nil,
                                                          completion: { _ in
                                                            if let t = self.t_completion
                                                            {
                                                                t()
                                                            }
                                        })
                                })
                                
                            case SLCTableViewTransition.from:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                        UIView.transition(from: c,
                                                          to: self.slc_tableView_transitionTo!,
                                                          duration: self.slc_tableView_duration!,
                                                          options: self.slc_tableView_transitionAnimation!,
                                                          completion: { _ in
                                                            if let t = self.t_completion
                                                            {
                                                                t()
                                                            }
                                        })
                                })
                            }
                        }
                        
                        tableView_totalItemsCount += 1
                    }
                    
                    
                    if let f = footer, self.slc_tableView_footer!
                    {
                        switch self.slc_tableView_transition!
                        {
                        case SLCTableViewTransition.none:
                            f.transform = tableView_to
                            if self.slc_tableView_spring!
                            {
                                UIView.animate(withDuration: self.slc_tableView_duration!,
                                               delay: delay,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.slc_tableView_animation!,
                                               animations: {
                                                f.transform = CGAffineTransform.identity
                                },
                                               completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: self.slc_tableView_duration!,
                                               delay: delay,
                                               options: self.slc_tableView_animation!,
                                               animations: {
                                                f.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let t = self.t_completion
                                    {
                                        t()
                                    }
                                })
                            }
                            
                        case SLCTableViewTransition.content:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                    UIView.transition(with: f,
                                                      duration: self.slc_tableView_duration!,
                                                      options: self.slc_tableView_transitionAnimation!,
                                                      animations: nil,
                                                      completion: { _ in
                                                        if let t = self.t_completion
                                                        {
                                                            t()
                                                        }
                                    })
                            })
                            
                            
                        case SLCTableViewTransition.from:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                    UIView.transition(from: f,
                                                      to: self.slc_tableView_transitionTo!,
                                                      duration: self.slc_tableView_duration!,
                                                      options: self.slc_tableView_transitionAnimation!,
                                                      completion: { _ in
                                                        if let t = self.t_completion
                                                        {
                                                            t()
                                                        }
                                    })
                            })
                        }
                        
                        tableView_totalItemsCount += 1
                    }
                }
                
                
            case SLCTableViewReload.fixed:
                self.reloadData()
                self.layoutIfNeeded()
                
                let header: UITableViewHeaderFooterView? = self.headerView(forSection: self.slc_tableView_indexPath!.section)
                let footer: UITableViewHeaderFooterView? = self.footerView(forSection: self.slc_tableView_indexPath!.section)
                let item: UITableViewCell? = self.cellForRow(at: self.slc_tableView_indexPath!)
                
                if self.slc_tableView_footer! || self.slc_tableView_header!
                {
                    if let h = header, self.slc_tableView_header!
                    {
                        switch self.slc_tableView_transition!
                        {
                        case SLCTableViewTransition.none:
                            h.transform = tableView_to
                            if self.slc_tableView_spring!
                            {
                                UIView.animate(withDuration: self.slc_tableView_duration!,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.slc_tableView_animation!,
                                               animations: {
                                                h.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let t = self.t_completion
                                    {
                                        t()
                                    }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: self.slc_tableView_duration!,
                                               delay: 0,
                                               options: self.slc_tableView_animation!,
                                               animations: {
                                                h.transform = CGAffineTransform.identity
                                },
                                               completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                                })
                            }
                            
                        case SLCTableViewTransition.content:
                            UIView.transition(with: h,
                                              duration: self.slc_tableView_duration!,
                                              options: self.slc_tableView_transitionAnimation!,
                                              animations: nil,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                            
                        case SLCTableViewTransition.from:
                            UIView.transition(from: h,
                                              to: self.slc_tableView_transitionTo!, duration: self.slc_tableView_duration!,
                                              options: self.slc_tableView_transitionAnimation!,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                        }
                    }
                    
                    if let f = footer, self.slc_tableView_footer!
                    {
                        switch self.slc_tableView_transition!
                        {
                        case SLCTableViewTransition.none:
                            f.transform = tableView_to
                            if self.slc_tableView_spring!
                            {
                                UIView.animate(withDuration: self.slc_tableView_duration!,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.slc_tableView_animation!,
                                               animations: {
                                                f.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let t = self.t_completion
                                    {
                                        t()
                                    }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: self.slc_tableView_duration!,
                                               delay: 0,
                                               options: self.slc_tableView_animation!,
                                               animations: {
                                                f.transform = CGAffineTransform.identity
                                },
                                               completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                                })
                            }
                            
                        case SLCTableViewTransition.content:
                            UIView.transition(with: f,
                                              duration: self.slc_tableView_duration!,
                                              options: self.slc_tableView_transitionAnimation!,
                                              animations: nil,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                            
                        case SLCTableViewTransition.from:
                            UIView.transition(from: f,
                                              to: self.slc_tableView_transitionTo!, duration: self.slc_tableView_duration!,
                                              options: self.slc_tableView_transitionAnimation!,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                        }
                    }
                }
                else
                {
                    if let i = item
                    {
                        switch self.slc_tableView_transition!
                        {
                        case SLCTableViewTransition.none:
                            i.transform = CGAffineTransform.identity
                            if self.slc_tableView_spring!
                            {
                                UIView.animate(withDuration: self.slc_tableView_duration!,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.slc_tableView_animation!,
                                               animations: {
                                                i.transform = CGAffineTransform.identity
                                },
                                               completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: self.slc_tableView_duration!,
                                               delay: 0,
                                               options: self.slc_tableView_animation!,
                                               animations: {
                                                i.transform = CGAffineTransform.identity
                                },
                                               completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                                })
                            }
                            
                        case SLCTableViewTransition.content:
                            UIView.transition(with: i,
                                              duration: self.slc_tableView_duration!,
                                              options: self.slc_tableView_transitionAnimation!,
                                              animations: nil, completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                            
                        case SLCTableViewTransition.from:
                            UIView.transition(from: i,
                                              to: self.slc_tableView_transitionTo!,
                                              duration: self.slc_tableView_duration!,
                                              options: self.slc_tableView_transitionAnimation!,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
