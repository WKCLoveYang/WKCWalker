//
//  SLCWalkerNormalViewController.swift
//  SLCWalkerDemo
//
//  Created by WeiKunChao on 2019/4/12.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import SLCWalker

private func slc_makeDataSource() -> Array<SLCWalker>
{
    return [.makeSize, .makePosition, .makeX, .makeY, .makeWidth, .makeHeight, .makeScale, .makeScaleX, .makeScaleY, .makeRotationX, .makeRotationY, .makeRotationZ, .makeBackground, .makeOpacity, .makeCornerRadius, .makeBorderWidth]
}

private func slc_takeDataSource() -> Array<SLCWalker>
{
    return [.takeFrame, .takeLeading, .takeTraing, .takeTop, .takeBottom, .takeWidth, .takeHeight, .takeSize]
}


private func slc_moveDataSource() -> Array<SLCWalker>
{
    return [.moveX, .moveY, .moveXY, .moveWidth, .moveHeight, .moveSize]
}

private func slc_addDataSource() -> Array<SLCWalker>
{
    return [.addTraing, .addTraing, .addTop, .addBottom, .addWidth, .addHeight, .addSize]
}

class SLCWalkerNormalViewController: UIViewController
{
    
    convenience init(title: String)
    {
        self.init()
        mTitle = title
    }
    
    private var mTitle: String!
    
    private var dataSource: Array<SLCWalker>!
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing  = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = SLCWalkerItemCell.itemSize
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundView = nil
        collectionView.backgroundColor = nil
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView .register(SLCWalkerItemCell.self, forCellWithReuseIdentifier: "cell")
        
        return collectionView
    }()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = mTitle
        
        if mTitle == "Make"
        {
            dataSource = slc_makeDataSource()
        }
        else if mTitle == "Take"
        {
            dataSource = slc_takeDataSource()
        }
        else if mTitle == "Move"
        {
            dataSource = slc_moveDataSource()
        }
        else if mTitle == "Add"
        {
            dataSource = slc_addDataSource()
        }
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}


extension SLCWalkerNormalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: SLCWalkerItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SLCWalkerItemCell
        cell.walker = dataSource[indexPath.row]
        return cell
    }
}
