//
//  FlagshipView.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/27/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

@IBDesignable
class FlagshipView: UIView {
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costValueLabel: UILabel!
    @IBOutlet weak var combatValueLabel: UILabel!
    @IBOutlet weak var moveValueLabel: UILabel!
    @IBOutlet weak var capacityValueLabel: UILabel!
    @IBOutlet weak var costValueContainer: UIView!
    @IBOutlet weak var combatValueContainer: UIView!
    @IBOutlet weak var moveValueContainer: UIView!
    @IBOutlet weak var capacityValueContainer: UIView!
    @IBOutlet weak var costAttrContainer: UIView!
    @IBOutlet weak var combatAttrContainer: UIView!
    @IBOutlet weak var moveAttrContainer: UIView!
    @IBOutlet weak var capacityAttrContainer: UIView!
    
    
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
        let nib = UINib(nibName: "FlagshipView", bundle: Bundle(for: FlagshipView.self))
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        nibView.translatesAutoresizingMaskIntoConstraints = false
        nibView.backgroundColor = UIColor.clear
        addSubview(nibView)
        nibView.pin(toView: self)
        
        [costAttrContainer, combatAttrContainer, moveAttrContainer, capacityAttrContainer].forEach {
            $0!.layer.cornerRadius = 10
            $0!.clipsToBounds = true
            $0?.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        }
    }

}
