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
    
    var cellType: CycleScrollViewCellStyle?
    
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
            titleLabel.frame.origin.x = titleLeftMargin ?? 0
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
    
    var image: Any? {
        didSet {

            guard let imageObj = image else {
                imageView.image = placeholderImage
                return
            }
            
            if imageObj is String {
                
                let imageString = imageObj as! String
                
                if imageString.contains("http") { //网络图片
                    let url = URL(string: imageString)
                    imageView.kf.setImage(with: url, placeholder: placeholderImage)
                } else if !imageString.isEmpty, let image = UIImage(named: imageString) { //其它图片（暂指本地图片）
                    imageView.image = image
                } else {
                    imageView.image = placeholderImage
                }
                
            } else if imageObj is UIImage {
                imageView.image = imageObj as? UIImage
            } else {
                imageView.image = placeholderImage
            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let type = cellType else { return }
        
        switch type {
        case .image:
            imageView.frame = self.bounds
        case .title:
            bannerView.frame = self.bounds
            titleLabel.frame = CGRect(x: titleLeftMargin ?? 0, y: bannerView.frame.origin.y, width: self.frame.width - (titleLeftMargin ?? 0), height: bannerView.frame.height)
        case .mix:
            bannerView.frame = CGRect(x: 0, y: self.frame.height - 40, width: self.frame.width, height: 40)
            imageView.frame = self.bounds
            titleLabel.frame = CGRect(x: titleLeftMargin ?? 0, y: bannerView.frame.origin.y, width: self.frame.width - (titleLeftMargin ?? 0), height: bannerView.frame.height)
        default:
            break
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    private func initial() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - GET
    
    private lazy var bannerView: UIView = {
        let bannerView = UIView()
        bannerView.backgroundColor = UIColor.black
        bannerView.alpha = 0.5
        contentView.addSubview(bannerView)
        return bannerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        return imageView
    }()
    
}
