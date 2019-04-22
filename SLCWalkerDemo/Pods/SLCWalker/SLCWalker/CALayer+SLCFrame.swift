//
//  CALayer+SLCFrame.swift
//  SLCWalker
//
//  Created by WeiKunChao on 2019/3/25.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit

public extension CALayer
{
    var leading: CGFloat
    {
        get {
            return self.frame.origin.x;
        }
        
        set {
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var top: CGFloat {
        get {
            return self.frame.origin.y;
        }
        
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue - self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var traing: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        
        set {
            self.frame = CGRect(x: newValue - self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.size.height)
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: newValue)
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.width / 2.0
        }
        
        set {
            self.frame = CGRect(x: newValue - self.frame.width / 2.0, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.height / 2.0
        }
        
        set {
            self.frame = CGRect.init(x: self.frame.origin.x, y: newValue - self.frame.height / 2.0, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
}
