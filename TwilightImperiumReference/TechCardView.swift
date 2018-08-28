//
//  TechCardView.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/10/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

@IBDesignable
class TechCardView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prereqLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    
    convenience init(title: String, cardText: String, prereqString: String) {
        self.init(frame: .zero)
        initContent(title: title, description: cardText, prereq: prereqString)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "TechCardView", bundle: Bundle(for: TechCardView.self))
        let view = nib.instantiate(withOwner: self, options: nil).first! as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        addSubview(view)
        view.pin(toView: self)
        layer.cornerRadius = 10
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
    }
    
    private func initContent(title: String, description: String, prereq: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        prereqLabel.text = prereq
    }
    
    override var intrinsicContentSize: CGSize {
        let width = descriptionLabel.bounds.width + 16
        let height: CGFloat = titleLabel.bounds.height + descriptionLabel.bounds.height  + prereqLabel.bounds.height  + CGFloat(integerLiteral: 40)
        return CGSize(width: width, height: height)
    }
}

extension TechCardView {
    
    enum ResearchState {
        case owned, canResearch, cannotResearch
    }
    
    func setAppearance(forState state: ResearchState) {
        switch state {
        case .owned:
            statusIcon.image = UIImage(named: "beaker-check")
        case .canResearch:
            statusIcon.image = UIImage(named: "beaker")
        case .cannotResearch:
            statusIcon.image = UIImage(named: "no_research")
        }
    }
    
    func setAppearance(forTechType type: TechnologyType) {
        switch type {
        case .blue:
            backgroundColor = UIColor(red: 0.278, green: 0.561, blue: 0.812, alpha: 1.0)
        case .green:
            backgroundColor = UIColor(red: 0.375, green: 0.599, blue: 0.499, alpha: 1.0)
        case .red:
            backgroundColor = UIColor(red: 0.773, green: 0.404, blue: 0.471, alpha: 1.0)
        case .yellow:
            backgroundColor = UIColor(red: 0.925, green: 0.941, blue: 0.643, alpha: 1.0)
        case .unit:
            backgroundColor = UIColor(red: 0.886, green: 0.875, blue: 0.875, alpha: 1.0)
        }
    }
}
