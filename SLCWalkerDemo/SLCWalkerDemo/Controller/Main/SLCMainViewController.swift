//
//  ViewController.swift
//  SLCWalkerDemo
//
//  Created by WeiKunChao on 2019/4/11.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit

class SLCMainViewController: UIViewController
{

    private lazy var dataSource: Array<SLCMainModel> = {
        let array: Array<SLCMainModel> = Array<SLCMainModel>()
        return array
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.itemSize = SLCMainCollectionViewCell.itemSize
        let c: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.backgroundView = nil
        c.backgroundColor = nil
        c.showsVerticalScrollIndicator = false
        c.showsHorizontalScrollIndicator = false
        c.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)
        c.register(SLCMainCollectionViewCell.self,
                   forCellWithReuseIdentifier: "cell")
        c.delegate = self
        c.dataSource = self
        return c
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        slc_initDataSource()
        slc_setupSubviewsLayout()
    }

    private func slc_initDataSource()
    {
        let make: SLCMainModel = slc_createAData("Make",
                                                 "Function MAKE, based on the center",
                                                 "main_bg_make.jpg")
        
        let take: SLCMainModel = slc_createAData("Take",
                                                 "Function TAKE, based on the boundary (parameter repeat is unavailable)",
                                                 "main_bg_take.jpg")
        
        let move: SLCMainModel = slc_createAData("Move",
                                                 "Function MOVE , relative movement (based on the center)",
                                                 "main_bg_move.jpg")
        
        let add: SLCMainModel = slc_createAData("Add",
                                                 "Function ADD , relative movement (based on the boundary). (parameter repeat is unavailable)",
                                                 "main_bg_add.jpg")
        
        let path: SLCMainModel = slc_createAData("Path",
                                                "Path animation",
                                                "main_bg_path.jpg")
        
        let transition: SLCMainModel = slc_createAData("Transition",
                                                 "Transition animation",
                                                 "main_bg_tra.jpg")
        
        let collec: SLCMainModel = slc_createAData("CollectionView",
                                                       "CollectionView animation",
                                                       "main_bg_make.jpg")
        
        let table: SLCMainModel = slc_createAData("TableView",
                                                   "TableView animation",
                                                   "main_bg_take.jpg")
        
        dataSource.append(make)
        dataSource.append(take)
        dataSource.append(move)
        dataSource.append(add)
        dataSource.append(path)
        dataSource.append(transition)
        dataSource.append(collec)
        dataSource.append(table)
    }
    
    private func slc_createAData(_ title: String,
                                 _ detail: String,
                                 _ imageStr:String) -> SLCMainModel
    {
        let model: SLCMainModel = SLCMainModel()
        model.title = title
        model.detail = detail
        model.imageStr = imageStr
        return model
    }
    
    private func slc_setupSubviewsLayout()
    {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}


extension SLCMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: SLCMainCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SLCMainCollectionViewCell
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let model: SLCMainModel = dataSource[indexPath.row]
        switch model.title
        {
        case "Path":
            let path: SLCWalkerPathViewController = SLCWalkerPathViewController()
            navigationController?.pushViewController(path, animated: true)
            
        case "Transition":
            let transition: SLCWalkerTransitionViewController = SLCWalkerTransitionViewController()
            navigationController?.pushViewController(transition, animated: true)
            
        case "CollectionView":
            let collection: SLCWalkerCollectionViewController = SLCWalkerCollectionViewController()
            navigationController?.pushViewController(collection, animated: true)
            
        case "TableView":
            let table: SLCWalkerTableViewController = SLCWalkerTableViewController()
            navigationController?.pushViewController(table, animated: true)

        default:
            let normal: SLCWalkerNormalViewController = SLCWalkerNormalViewController(title: model.title)
            navigationController?.pushViewController(normal, animated: true)
            
            break
        }
    }
}
