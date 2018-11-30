//
//  CustomCollectionViewCell.swift
//  SCCycleScrollView
//
//  Created by tongshichao on 2018/11/28.
//  Copyright © 2018 童世超. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initial() {
        imageView.frame = CGRect(x: 5, y: 5, width: self.frame.width - 10, height: self.frame.height - 10)
        titleLabel.center = imageView.center
    }
 
    private lazy var titleLabel: UILabel! = {
        let titleLabel = UILabel()
        titleLabel.text = "自定义ell"
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    private lazy var imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.orange
        contentView.addSubview(imageView)
        return imageView
    }()
}
