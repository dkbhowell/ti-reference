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
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var abilityStack: UIStackView!
    
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
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        view.insertSubview(blurredView, at: 0)
        blurredView.pin(toView: view)
        
        
        abilityStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        quoteLabel.text = faction.quote
        for ability in faction.abilities {
            let abilityView = AbilityView(name: ability.name, description: ability.description)
//            abilityView.invalidateIntrinsicContentSize()
            abilityStack.addArrangedSubview(abilityView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6) { [weak self] in
            guard let frame = self?.view.frame else { return }
            let yComponent = UIScreen.main.bounds.height - 300
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
        }
    }

}
