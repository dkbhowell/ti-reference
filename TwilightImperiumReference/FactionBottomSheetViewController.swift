//
//  FactionBottomSheetViewController.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/27/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

class FactionBottomSheetViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var quoteLabelContainer: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var abilityStack: UIStackView!
    @IBOutlet weak var panIndicator: UIView!
    @IBOutlet weak var factionTechStack: UIStackView!
    @IBOutlet weak var flagshipView: FlagshipView!
    
    // MARK: Properties
    let faction: Faction
    let blurredView: UIVisualEffectView
    
    init(faction: Faction) {
        self.faction = faction
        let blurEffect = UIBlurEffect(style: .light)
        blurredView = UIVisualEffectView(effect: blurEffect)
        blurredView.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: "FactionBottomSheetViewController", bundle: Bundle(for: FactionBottomSheetViewController.self))
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // prepare background
        panIndicator.layer.cornerRadius = 4
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        view.insertSubview(blurredView, at: 0)
        blurredView.pin(toView: view)
        
        
        abilityStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        quoteLabel.text = faction.quote
        for ability in faction.abilities {
            let abilityView = AbilityView(name: ability.name, description: ability.description)
            abilityView.backgroundColor = UIColor.white.withAlphaComponent(0.45)
            abilityStack.addArrangedSubview(abilityView)
        }
        
        factionTechStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for facTech in faction.factionTechs {
            let techCard = TechCardView(title: facTech.name, cardText: facTech.description, prereqString: facTech.prereqString)
            techCard.setAppearance(forTechType: facTech.type)
            factionTechStack.addArrangedSubview(techCard)
        }
        quoteLabelContainer.backgroundColor = UIColor.white.withAlphaComponent(0.45)
        quoteLabelContainer.layer.cornerRadius = 10
        
        // add pan gesture recognizer
        let panRec = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized))
        view.addGestureRecognizer(panRec)
        
        // configure flagship
        flagshipView.setName(faction.flagship.name)
        flagshipView.setCost(8)
        flagshipView.setCombat(faction.flagship.hitValue)
        flagshipView.setCapacity(faction.flagship.capacity)
        flagshipView.setDescriptino(faction.flagship.ability)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6) { [weak self] in
            guard let frame = self?.view.frame else { return }
            let yComponent = UIScreen.main.bounds.height - 300
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
        }
    }
    
    @objc private func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: self.view)
        let y = self.view.frame.minY
        let newFrame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
//        if newFrame.minY >= 0 {
//            self.view.frame = newFrame
//        }
        self.view.frame = newFrame
        gestureRecognizer.setTranslation(.zero, in: self.view)
    }

}
