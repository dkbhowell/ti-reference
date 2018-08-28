//
//  UIView+.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/10/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = cornerRadius
        }
        
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = borderWidth
        }
    }
    
    
    func pin(toView view: UIView, withPadding padding: UIEdgeInsets? = nil) {
        
        var leading: CGFloat = 0
        var trailing: CGFloat = 0
        var top: CGFloat = 0
        var bottom: CGFloat = 0
        
        if let padding = padding {
            leading = padding.left
            trailing = -padding.right
            top = padding.top
            bottom = -padding.bottom
        }
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing),
            topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
        ])
    }
    
}

@IBDesignable class DesignableView: UIView { }
