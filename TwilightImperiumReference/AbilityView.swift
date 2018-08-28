//
//  AbilityView.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/27/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

@IBDesignable
class AbilityView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    convenience init(name: String, description: String) {
        self.init(frame: .zero)
        nameLabel.text = name
        descriptionLabel.text = description
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 10
        clipsToBounds = true
        let nib = UINib(nibName: "AbilityView", bundle: Bundle(for: AbilityView.self))
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        nibView.backgroundColor = UIColor.clear
        nibView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nibView)
        nibView.pin(toView: self)
    }
    
    override var intrinsicContentSize: CGSize {
        let width: CGFloat = max(nameLabel.bounds.width, descriptionLabel.bounds.width)
        let height: CGFloat = nameLabel.bounds.height + descriptionLabel.bounds.height + 24
        return CGSize(width: width, height: height)
    }

}
