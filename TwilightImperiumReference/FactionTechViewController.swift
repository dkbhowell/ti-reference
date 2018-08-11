//
//  FactionTechViewController.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/10/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

class FactionTechViewController: UIViewController {
    
    let faction: Faction
    
    init(faction: Faction) {
        self.faction = faction
        super.init(nibName: nil, bundle: Bundle(for: FactionTechViewController.self))
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let techs = faction.factionTechs
        let firstFactionCard = TechCardView(title: techs[0].name, cardText: techs[0].cardText, prereqString: techs[0].prereqString)
        firstFactionCard.setAppearance(forTechType: techs[0].type)
        let secondFactionCard = TechCardView(title: techs[1].name, cardText: techs[1].cardText, prereqString: techs[1].prereqString)
        secondFactionCard.setAppearance(forTechType: techs[1].type)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 10
        
        let doneButton = UIButton(type: .custom)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        containerView.addSubview(firstFactionCard)
        containerView.addSubview(secondFactionCard)
        containerView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            firstFactionCard.topAnchor.constraint(equalToSystemSpacingBelow: containerView.topAnchor, multiplier: 1),
            firstFactionCard.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 1),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: firstFactionCard.trailingAnchor, multiplier: 1),
            secondFactionCard.topAnchor.constraint(equalToSystemSpacingBelow: firstFactionCard.bottomAnchor, multiplier: 1),
            secondFactionCard.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 1),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: secondFactionCard.trailingAnchor, multiplier: 1),
            doneButton.topAnchor.constraint(equalToSystemSpacingBelow: secondFactionCard.bottomAnchor, multiplier: 1.5),
            doneButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            containerView.bottomAnchor.constraint(equalToSystemSpacingBelow: doneButton.bottomAnchor, multiplier: 1.5)
        ])
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
