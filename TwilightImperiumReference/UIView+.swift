//
//  UIView+.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/10/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

extension UIView {
    
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
