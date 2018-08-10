//
//  TechCardView.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/10/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

class TechCardView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prereqLabel: UILabel!
    
    let title: String
    let cardText: String
    let prereqString: String
    
    init(title: String, cardText: String, prereqString: String) {
        self.title = title
        self.cardText = cardText
        self.prereqString = prereqString
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        commonInit()
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "TechCardView", bundle: Bundle(for: TechCardView.self))
        let view = nib.instantiate(withOwner: self, options: nil).first! as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.pin(toView: self)
    }
    
    private func initViews() {
        titleLabel.text = title
        descriptionLabel.text = cardText
        prereqLabel.text = prereqString
    }
}
