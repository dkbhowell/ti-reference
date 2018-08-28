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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var costValueLabel: UILabel!
    @IBOutlet private weak var combatValueLabel: UILabel!
    @IBOutlet private weak var moveValueLabel: UILabel!
    @IBOutlet private weak var capacityValueLabel: UILabel!
    
    
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
    }
    
    func setName(_ name: String) {
        titleLabel.text = name
    }
    func setDescriptino(_ desc: String) {
        descriptionLabel.text = desc
    }
    func setCost(_ cost: Int) {
        costValueLabel.text = "\(cost)"
    }
    func setCombat(_ combat: Int) {
        combatValueLabel.text = "\(combat)"
    }
    func setCapacity(_ cap: Int) {
        capacityValueLabel.text = "\(cap)"
    }

}
