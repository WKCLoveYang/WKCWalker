//
//  SLCWalkerPathViewController.swift
//  SLCWalkerDemo
//
//  Created by WeiKunChao on 2019/4/12.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import SLCWalker

class SLCWalkerPathViewController: UIViewController
{
    
    private lazy var beizierPath: UIBezierPath = {
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 100))
        path.addLine(to: CGPoint(x: 80, y: 200))
        path.addLine(to: CGPoint(x: 150, y: 100))
        path.addLine(to: CGPoint(x: 300, y: 300))
        path.close()
        return path
    }()
    
    private lazy var shapeLayer: CAShapeLayer = {
        let shape: CAShapeLayer = CAShapeLayer()
        shape.strokeColor = UIColor.green.cgColor
        shape.lineWidth = 2
        shape.path = self.beizierPath.cgPath
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }()
    
    private lazy var testView: UIView = {
        let test: UIView = UIView(frame: CGRect(x: 0, y: 100, width: 50, height: 50))
        test.backgroundColor = UIColor.red
        return test
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.view.layer.addSublayer(shapeLayer)
        self.view.addSubview(testView)
        
        self.testView.path(self.beizierPath).repeatNumber(SLCWalkerMax).reverses(true).animate(1)
    }
    
}
