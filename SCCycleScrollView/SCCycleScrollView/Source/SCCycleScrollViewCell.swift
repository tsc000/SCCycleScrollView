//
//  SCCycleScrollViewCell.swift
//  SCCycleScrollView
//
//  Created by 童世超 on 2017/6/19.
//  Copyright © 2017年 童世超. All rights reserved.
//

import UIKit
import Kingfisher

class SCCycleScrollViewCell: UICollectionViewCell {
    
    var placeholderImage: UIImage?
    
    var cellType: CycleScrollViewCellType?
    
    var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    var titleLeftMargin: CGFloat? {
        didSet {
            titleLabel.frame.origin.x = titleLeftMargin!
        }
    }
    
    var titleContainerBackgroundColor: UIColor? {
        didSet {
            bannerView.backgroundColor = titleContainerBackgroundColor
        }
    }
    
    var titleContainerAlpha: CGFloat = 0.5 {
        didSet {
            bannerView.alpha = titleContainerAlpha
        }
    }
    
    var title: String? {
        didSet {
            if let title = title, !title.isEmpty {
                
                bannerView.isHidden = false
                
                titleLabel.text = title
            } else {
                bannerView.isHidden = true
                
                titleLabel.text = ""
            }
        }
    }
    
    var image: String? {
        didSet {
            
            if let imageString = image, !imageString.isEmpty {
                
                //网络图片
                if imageString.contains("http") {
                    let url = URL(string: imageString)
                    
                    imageView?.kf.setImage(with: url, placeholder: placeholderImage)
                } else { //其它图片（暂指本地图片）
                    imageView.image = UIImage(named: imageString)
                }
                
                
            } else {
                imageView.image = placeholderImage
            }
            
        }
    }
    
    private var bannerView: UIView!
    
    private var titleLabel: UILabel!
    
    private weak var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let type = cellType else { return }
        
        switch type {
        case .Image:
            
            bannerView.frame = CGRect(x: 0, y: self.frame.height - 40, width: self.frame.width, height: 40)
            
            imageView.frame = self.bounds
            
        case .OnlyTitle:
            
            bannerView.frame = self.bounds
            
        }
        
        titleLabel.frame = CGRect(x: titleLeftMargin ?? 0, y: bannerView.frame.origin.y, width: self.frame.width - (titleLeftMargin ?? 0), height: bannerView.frame.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initial()
    }
    
    private func setupUI() {
        setupImageView()
        
        setupTitle()
    }
    
    private func initial() {
        
        setupUI()
    }
    
    private func setupImageView() {
        let imageView = UIImageView()
        
        contentView.addSubview(imageView)
        
        self.imageView = imageView
    }
    
    private func setupTitle() {
        bannerView = UIView()
        
        bannerView.backgroundColor = UIColor.black
        
        bannerView.alpha = 0.5
        
        titleLabel = UILabel()
  
        titleLabel.textAlignment = .left
        
        [bannerView, titleLabel].forEach(contentView.addSubview(_:))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
