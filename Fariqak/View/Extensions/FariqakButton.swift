//
//  FariqakButton.swift
//  Fariqak
//
//  Created by Esslam Emad on 14/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

@IBDesignable class FariqakButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderColor: UIColor = .black{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var titleLeftPadding: CGFloat = 0.0{
        didSet{
            titleEdgeInsets.left = titleLeftPadding
        }
    }
    
    @IBInspectable var titleRightPadding: CGFloat = 0.0{
        didSet{
            titleEdgeInsets.right = titleRightPadding
        }
    }
    @IBInspectable var titleTopPadding: CGFloat = 0.0{
        didSet{
            titleEdgeInsets.top = titleTopPadding
        }
    }
    @IBInspectable var titleBottomPadding: CGFloat = 0.0{
        didSet{
            titleEdgeInsets.bottom = titleBottomPadding
        }
    }
    @IBInspectable var imageLeftPadding: CGFloat = 0.0{
        didSet{
            imageEdgeInsets.left = imageLeftPadding
        }
    }
    @IBInspectable var imageRightPadding: CGFloat = 0.0{
        didSet{
            imageEdgeInsets.right = imageRightPadding
        }
    }
    @IBInspectable var imageTopPadding: CGFloat = 0.0{
        didSet{
            imageEdgeInsets.top = imageTopPadding
        }
    }
    @IBInspectable var imageBottomPadding: CGFloat = 0.0{
        didSet{
            imageEdgeInsets.bottom = imageBottomPadding
        }
    }
    @IBInspectable var isImageRightAlligned: Bool = false
    @IBInspectable var isBackgroungColorGradient: Bool = false { didSet{ layoutSubviews()}}
    //@IBInspectable var gradientColor1 = UIColor.black.cgColor { didSet{ layoutSubviews() }}
    //@IBInspectable var gradientColor2 = UIColor.white.cgColor { didSet{ layoutSubviews() }}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isImageRightAlligned, let imageView = imageView{
            imageEdgeInsets.left = self.bounds.width - imageView.bounds.width - imageRightPadding
        }
        if isBackgroungColorGradient{
            let color1 = UIColor(red: 0.0/255.0, green: 175.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
            let color2 = UIColor(red: 0, green: 1, blue: 0, alpha: 1).cgColor
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [color1 , color2]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        layoutSubviews()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        layoutSubviews()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
