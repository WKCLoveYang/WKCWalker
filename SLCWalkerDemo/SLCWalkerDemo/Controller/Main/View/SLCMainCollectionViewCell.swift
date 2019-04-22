//
//  SLCMainCollectionViewCell.swift
//  SLCWalkerDemo
//
//  Created by WeiKunChao on 2019/4/11.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import SnapKit

class SLCMainCollectionViewCell: UICollectionViewCell
{
    static var itemSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20 * 2, height: 180)
    }
    
    private lazy var bgImageView: UIImageView = {
        let bg: UIImageView = UIImageView()
        bg.contentMode = UIView.ContentMode.scaleAspectFill
        return bg
    }()
    
    private lazy var detailLabel: UILabel = {
        let detaik: UILabel = UILabel()
        detaik.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        detaik.numberOfLines = 0
        detaik.textColor = UIColor.white
        return detaik
    }()
    
    private lazy var titleLabel: UILabel = {
        let title: UILabel = UILabel()
        title.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        title.textColor = UIColor.white
        return title
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(bgImageView)
        contentView.addSubview(detailLabel)
        contentView.addSubview(titleLabel)
        
        bgImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        detailLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.bottom.equalToSuperview().offset(-15)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalTo(detailLabel.snp.top).offset(-5)
        }
    }
    
    
    var model: SLCMainModel? {
        willSet {
            if let n = newValue {
                titleLabel.text = n.title
                detailLabel.text = n.detail
                bgImageView.image = UIImage(named: n.imageStr)
            }
        }
    }

    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
