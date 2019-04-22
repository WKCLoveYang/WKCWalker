//
//  UITableView+WKCWalker.swift
//  WKCWalker
//
//  Created by WeiKunChao on 2019/4/1.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

private enum WKCTableViewReload: Int
{
    case visible = 0, fixed
}

private enum WKCTableViewTransition: Int
{
    case none = 0, content, from
}

private var WKCTableViewCompletionKey: String = "wkc.tableView.completion"
private var WKCTableViewAnimation: String = "wkc.tableView.animation"
private var WKCTableViewReloadType: String = "wkc.tableView.reload"
private var WKCTableViewTransitionType: String = "wkc.tableView.transition"
private var WKCTableViewSpringType: String = "wkc.tableView.spring"
private var WKCTableViewDuration: String = "wkc.tableView.duration"
private var WKCTableViewDelay: String = "wkc.tableView.delay"
private var WKCTableViewIndexPath: String = "wkc.tableView.indexPath"
private var WKCTableViewTransitionTo: String = "wkc.tableView.transitionTo"
private var WKCTableViewTransitionAnimation: String = "wkc.tableView.transitionAnimation"
private var WKCTableViewHeader: String = "wkc.tableView.header"
private var WKCTableViewFooter: String = "wkc.tableView.header"

private var tableView_to: CGAffineTransform = CGAffineTransform.identity
private var tableView_totalItemsCount: Int = 0


extension UITableView
{
    private var wkc_tableView_animation: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewAnimation) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_tableView_reload: WKCTableViewReload?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewReloadType) as? WKCTableViewReload
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewReloadType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
    private var wkc_tableView_transition: WKCTableViewTransition?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewTransitionType) as? WKCTableViewTransition
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewTransitionType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_tableView_spring: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewSpringType) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewSpringType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var wkc_tableView_duration: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewDuration) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewDuration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_tableView_delay: TimeInterval?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewDelay) as? TimeInterval
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewDelay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_tableView_indexPath: IndexPath?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewIndexPath) as? IndexPath
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewIndexPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var wkc_tableView_transitionTo: UIView?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewTransitionTo) as? UIView
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewTransitionTo, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var wkc_tableView_transitionAnimation: UIView.AnimationOptions?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewTransitionAnimation) as? UIView.AnimationOptions
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewTransitionAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var wkc_tableView_header: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewHeader) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewHeader, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var wkc_tableView_footer: Bool?
    {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewFooter) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &WKCTableViewFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
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
        self.wkc_tableView_transition = WKCTableViewTransition.from
        self.wkc_tableView_transitionTo = to
        return self
    }
    
    @discardableResult func t_itemDuration(_ duration: TimeInterval) -> UITableView
    {
        self.wkc_tableView_duration = duration
        return self
    }
    
    @discardableResult func t_itemDelay(_ delay: TimeInterval) -> UITableView
    {
        self.wkc_tableView_delay = delay
        return self
    }
    
    
    @discardableResult func headerWalker(_ walker: Bool) -> UITableView
    {
        self.wkc_tableView_header = walker
        return self
    }
    
    @discardableResult func footerWalker(_ walker: Bool) -> UITableView
    {
        self.wkc_tableView_footer = walker
        return self
    }
    
    
    func reloadDataWithWalker()
    {
        self.wkc_tableView_reload = WKCTableViewReload.visible
        self.wkc_startWalker()
    }
    
    func reloadDataFixedWithWalker(_ indexPath: IndexPath)
    {
        self.wkc_tableView_reload = WKCTableViewReload.fixed
        self.wkc_tableView_indexPath = indexPath
        self.wkc_startWalker()
    }
    
    
    
    
    
    var t_easeLiner: UITableView {
        self.wkc_tableView_animation = UIView.AnimationOptions.curveLinear
        return self
    }
    
    var t_easeInOut: UITableView {
        self.wkc_tableView_animation = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var t_easeIn: UITableView {
        self.wkc_tableView_animation = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var t_easeOut: UITableView {
        self.wkc_tableView_animation = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    var t_transitionFlipFromLeft: UITableView {
        self.wkc_tableView_transition = WKCTableViewTransition.content
        self.wkc_tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        return self
    }
    
    var t_transitionFlipFromRight: UITableView {
        self.wkc_tableView_transition = WKCTableViewTransition.content
        self.wkc_tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromRight
        return self
    }
    
    var t_transitionCurlUp: UITableView {
        self.wkc_tableView_transition = WKCTableViewTransition.content
        self.wkc_tableView_transitionAnimation = UIView.AnimationOptions.transitionCurlUp
        return self
    }
    
    var t_transitionCurDown: UITableView {
        self.wkc_tableView_transition = WKCTableViewTransition.content
        self.wkc_tableView_transitionAnimation = UIView.AnimationOptions.transitionCurlDown
        return self
    }
    
    var t_transitionCrossDissolve: UITableView {
        self.wkc_tableView_transition = WKCTableViewTransition.content
        self.wkc_tableView_transitionAnimation = UIView.AnimationOptions.transitionCrossDissolve
        return self
    }
    
    var t_transitionFlipFromTop: UITableView {
        self.wkc_tableView_transition = WKCTableViewTransition.content
        self.wkc_tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromTop
        return self
    }
    
    var t_transitionFlipFromBottom: UITableView {
        self.wkc_tableView_transition = WKCTableViewTransition.content
        self.wkc_tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromBottom
        return self
    }
    
    var t_spring: UITableView {
        self.wkc_tableView_spring = true
        return self
    }
    
    var t_completion: WKCWalkerVoidCompletion {
        get {
            return objc_getAssociatedObject(self, &WKCTableViewCompletionKey) as! WKCWalkerVoidCompletion
        }
        set {
            objc_setAssociatedObject(self, &WKCTableViewCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    

    private func wkc_initParams()
    {
        if self.wkc_tableView_animation == nil
        {
            self.wkc_tableView_animation = UIView.AnimationOptions.curveLinear
        }
        
        if self.wkc_tableView_reload == nil
        {
            self.wkc_tableView_reload = WKCTableViewReload.visible
        }
        
        if self.wkc_tableView_transition == nil
        {
            self.wkc_tableView_transition = WKCTableViewTransition.none
        }
        
        if self.wkc_tableView_spring == nil
        {
            self.wkc_tableView_spring = false
        }
        
        if self.wkc_tableView_duration == nil
        {
            self.wkc_tableView_duration = 0.7
        }
        
        if self.wkc_tableView_delay == nil
        {
            self.wkc_tableView_delay = 0.1
        }
        
        if self.wkc_tableView_indexPath == nil
        {
            self.wkc_tableView_indexPath = IndexPath(row: 0, section: 0)
        }
        
        if self.wkc_tableView_transitionTo == nil
        {
            self.wkc_tableView_transitionTo = UIView()
        }
        
        if self.wkc_tableView_transitionAnimation == nil
        {
            self.wkc_tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        }
        
        if self.wkc_tableView_header == nil
        {
            self.wkc_tableView_header = false
        }
        
        if self.wkc_tableView_footer == nil
        {
            self.wkc_tableView_footer = false
        }
    }
    
    
    private func wkc_startWalker()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
        {
            self.wkc_initParams()
            
            switch self.wkc_tableView_reload!
            {
            case WKCTableViewReload.visible:
                self.reloadData()
                self.layoutIfNeeded()
                
                let sections: Int = self.numberOfSections
                
                for index in 0..<sections
                {
                    let header: UITableViewHeaderFooterView? = self.headerView(forSection: index)
                    let footer: UITableViewHeaderFooterView? = self.footerView(forSection: index)
                    
                    let numbers: Int = self.numberOfRows(inSection: index)
                    
                    let delay: TimeInterval = Double(tableView_totalItemsCount) * self.wkc_tableView_delay!
                    
                    if let h = header, self.wkc_tableView_header!
                    {
                        switch self.wkc_tableView_transition!
                        {
                        case WKCTableViewTransition.none:
                            h.transform = tableView_to
                            if self.wkc_tableView_spring!
                            {
                             UIView.animate(withDuration: self.wkc_tableView_duration!,
                                            delay: delay,
                                            usingSpringWithDamping: 0.85,
                                            initialSpringVelocity: 10.0,
                                            options: self.wkc_tableView_animation!,
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
                                UIView.animate(withDuration: self.wkc_tableView_duration!,
                                               delay: delay,
                                               options: self.wkc_tableView_animation!,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let t = self.t_completion
                                    {
                                        t()
                                    }
                                })
                            }
                            
                        case WKCTableViewTransition.content:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                UIView.transition(with: h,
                                                  duration: self.wkc_tableView_duration!,
                                                  options: self.wkc_tableView_transitionAnimation!,
                                                  animations: nil,
                                                  completion: { _ in
                                                    if let t = self.t_completion
                                                    {
                                                        t()
                                                    }
                                })
                            })
                            
                            
                        case WKCTableViewTransition.from:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                UIView.transition(from: h,
                                                  to: self.wkc_tableView_transitionTo!,
                                                  duration: self.wkc_tableView_duration!,
                                                  options: self.wkc_tableView_transitionAnimation!,
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
                            switch self.wkc_tableView_transition!
                            {
                            case WKCTableViewTransition.none:
                                c.transform = tableView_to
                                if self.wkc_tableView_spring!
                                {
                                    UIView.animate(withDuration: self.wkc_tableView_duration!,
                                                   delay: delay,
                                                   usingSpringWithDamping: 0.85,
                                                   initialSpringVelocity: 10.0,
                                                   options: self.wkc_tableView_animation!,
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
                                    UIView.animate(withDuration: self.wkc_tableView_duration!,
                                                   delay: delay,
                                                   options: self.wkc_tableView_animation!,
                                                   animations: {
                                                    c.transform = CGAffineTransform.identity
                                    }, completion: { _ in
                                        if let t = self.t_completion
                                        {
                                            t()
                                        }
                                    })
                                }
                                
                            case WKCTableViewTransition.content:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                        UIView.transition(with: c,
                                                          duration: self.wkc_tableView_duration!,
                                                          options: self.wkc_tableView_transitionAnimation!,
                                                          animations: nil,
                                                          completion: { _ in
                                                            if let t = self.t_completion
                                                            {
                                                                t()
                                                            }
                                        })
                                })
                                
                            case WKCTableViewTransition.from:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                        UIView.transition(from: c,
                                                          to: self.wkc_tableView_transitionTo!,
                                                          duration: self.wkc_tableView_duration!,
                                                          options: self.wkc_tableView_transitionAnimation!,
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
                    
                    
                    if let f = footer, self.wkc_tableView_footer!
                    {
                        switch self.wkc_tableView_transition!
                        {
                        case WKCTableViewTransition.none:
                            f.transform = tableView_to
                            if self.wkc_tableView_spring!
                            {
                                UIView.animate(withDuration: self.wkc_tableView_duration!,
                                               delay: delay,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.wkc_tableView_animation!,
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
                                UIView.animate(withDuration: self.wkc_tableView_duration!,
                                               delay: delay,
                                               options: self.wkc_tableView_animation!,
                                               animations: {
                                                f.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let t = self.t_completion
                                    {
                                        t()
                                    }
                                })
                            }
                            
                        case WKCTableViewTransition.content:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                    UIView.transition(with: f,
                                                      duration: self.wkc_tableView_duration!,
                                                      options: self.wkc_tableView_transitionAnimation!,
                                                      animations: nil,
                                                      completion: { _ in
                                                        if let t = self.t_completion
                                                        {
                                                            t()
                                                        }
                                    })
                            })
                            
                            
                        case WKCTableViewTransition.from:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                    UIView.transition(from: f,
                                                      to: self.wkc_tableView_transitionTo!,
                                                      duration: self.wkc_tableView_duration!,
                                                      options: self.wkc_tableView_transitionAnimation!,
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
                
                
            case WKCTableViewReload.fixed:
                self.reloadData()
                self.layoutIfNeeded()
                
                let header: UITableViewHeaderFooterView? = self.headerView(forSection: self.wkc_tableView_indexPath!.section)
                let footer: UITableViewHeaderFooterView? = self.footerView(forSection: self.wkc_tableView_indexPath!.section)
                let item: UITableViewCell? = self.cellForRow(at: self.wkc_tableView_indexPath!)
                
                if self.wkc_tableView_footer! || self.wkc_tableView_header!
                {
                    if let h = header, self.wkc_tableView_header!
                    {
                        switch self.wkc_tableView_transition!
                        {
                        case WKCTableViewTransition.none:
                            h.transform = tableView_to
                            if self.wkc_tableView_spring!
                            {
                                UIView.animate(withDuration: self.wkc_tableView_duration!,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.wkc_tableView_animation!,
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
                                UIView.animate(withDuration: self.wkc_tableView_duration!,
                                               delay: 0,
                                               options: self.wkc_tableView_animation!,
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
                            
                        case WKCTableViewTransition.content:
                            UIView.transition(with: h,
                                              duration: self.wkc_tableView_duration!,
                                              options: self.wkc_tableView_transitionAnimation!,
                                              animations: nil,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                            
                        case WKCTableViewTransition.from:
                            UIView.transition(from: h,
                                              to: self.wkc_tableView_transitionTo!, duration: self.wkc_tableView_duration!,
                                              options: self.wkc_tableView_transitionAnimation!,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                        }
                    }
                    
                    if let f = footer, self.wkc_tableView_footer!
                    {
                        switch self.wkc_tableView_transition!
                        {
                        case WKCTableViewTransition.none:
                            f.transform = tableView_to
                            if self.wkc_tableView_spring!
                            {
                                UIView.animate(withDuration: self.wkc_tableView_duration!,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.wkc_tableView_animation!,
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
                                UIView.animate(withDuration: self.wkc_tableView_duration!,
                                               delay: 0,
                                               options: self.wkc_tableView_animation!,
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
                            
                        case WKCTableViewTransition.content:
                            UIView.transition(with: f,
                                              duration: self.wkc_tableView_duration!,
                                              options: self.wkc_tableView_transitionAnimation!,
                                              animations: nil,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                            
                        case WKCTableViewTransition.from:
                            UIView.transition(from: f,
                                              to: self.wkc_tableView_transitionTo!, duration: self.wkc_tableView_duration!,
                                              options: self.wkc_tableView_transitionAnimation!,
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
                        switch self.wkc_tableView_transition!
                        {
                        case WKCTableViewTransition.none:
                            i.transform = CGAffineTransform.identity
                            if self.wkc_tableView_spring!
                            {
                                UIView.animate(withDuration: self.wkc_tableView_duration!,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: self.wkc_tableView_animation!,
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
                                UIView.animate(withDuration: self.wkc_tableView_duration!,
                                               delay: 0,
                                               options: self.wkc_tableView_animation!,
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
                            
                        case WKCTableViewTransition.content:
                            UIView.transition(with: i,
                                              duration: self.wkc_tableView_duration!,
                                              options: self.wkc_tableView_transitionAnimation!,
                                              animations: nil, completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                            
                        case WKCTableViewTransition.from:
                            UIView.transition(from: i,
                                              to: self.wkc_tableView_transitionTo!,
                                              duration: self.wkc_tableView_duration!,
                                              options: self.wkc_tableView_transitionAnimation!,
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
