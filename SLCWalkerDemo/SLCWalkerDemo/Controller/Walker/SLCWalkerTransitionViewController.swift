//
//  SLCWalkerTransitionViewController.swift
//  SLCWalkerDemo
//
//  Created by WeiKunChao on 2019/4/12.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import SLCWalker

class SLCWalkerTransitionViewController: UIViewController
{
    
    @IBOutlet weak var testView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

       
    }
    
    @IBAction func flipFromLeft(_ sender: UIButton)
    {
        testView.transitionFlipFromLeft.animate(1)
    }
    
    @IBAction func flipFromRight(_ sender: UIButton)
    {
        testView.transitionFlipFromRight.animate(1)
    }
    
    @IBAction func curlUp(_ sender: UIButton)
    {
        testView.transitionCurlUp.animate(1)
    }
    
    
    @IBAction func curlDown(_ sender: UIButton)
    {
        testView.transitionCurlDown.animate(1)
    }
    
    @IBAction func flipFromTop(_ sender: UIButton)
    {
        testView.transitionFlipFromTop.animate(1)
    }
    
    
    @IBAction func flipFromBottom(_ sender: UIButton)
    {
        testView.transitionFlipFromBottom.animate(1)
    }
}
