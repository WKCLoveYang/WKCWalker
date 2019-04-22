//
//  SLCLaunchViewController.swift
//  SLCWalkerDemo
//
//  Created by WeiKunChao on 2019/4/11.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import Foundation

class SLCLaunchViewController: UIViewController
{
   
    override var preferredStatusBarStyle: UIStatusBarStyle
        {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            let delegate: SLCAppDelegate = UIApplication.shared.delegate as! SLCAppDelegate
            delegate.window?.rootViewController = UINavigationController(rootViewController: SLCMainViewController())
        }
    }
}
