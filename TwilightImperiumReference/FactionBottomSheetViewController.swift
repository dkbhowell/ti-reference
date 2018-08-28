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
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Properties
    let faction: Faction
    let blurredView: UIVisualEffectView
    var hiddenConstraint: NSLayoutConstraint!
    var compactConstraint: NSLayoutConstraint!
    var expandedConstraint: NSLayoutConstraint!
    
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
        panRec.delegate = self
        view.addGestureRecognizer(panRec)
        
        // configure flagship
        flagshipView.setName(faction.flagship.name)
        flagshipView.setCost(8)
        flagshipView.setCombat(faction.flagship.hitValue)
        flagshipView.setCapacity(faction.flagship.capacity)
        flagshipView.setDescriptino(faction.flagship.ability)
        
        scrollView.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveSheet(to: .compact)
    }
    
    @objc private func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
//        print("panGestureRecognized")
        let translation = gestureRecognizer.translation(in: self.view)
        let y = self.view.frame.minY
        let newy = y + translation.y < 100 ? 100 : y + translation.y
        print("First Run: y is \(y); newY is \(newy)")
        let newFrame = CGRect(x: 0, y: newy, width: view.frame.width, height: view.frame.height)
        self.view.frame = newFrame
        gestureRecognizer.setTranslation(.zero, in: self.view)

        
        if gestureRecognizer.state == .ended {
            print("Gesture ended")
            if let superView = view.superview { superView.setNeedsLayout() }
            let newPosition = findClosestPosition(newY: newy)
            moveSheet(to: newPosition)
        }
    }
    
    private func findClosestPosition(newY: CGFloat) -> SheetPosition {
        switch newY {
        case 0...300:
            return .expanded
        default:
            return .compact
        }
    }

}

extension FactionBottomSheetViewController {
    enum SheetPosition {
        case hidden, compact, expanded
    }
    
    enum VerticalDirection {
        case down, up
    }
    
    func moveSheet(to position: SheetPosition) {
        guard let superView = view.superview else { return }
        
        switch position {
        case .hidden:
            compactConstraint.isActive = false
            expandedConstraint.isActive = false
            hiddenConstraint.isActive = true
        case .compact:
            expandedConstraint.isActive = false
            hiddenConstraint.isActive = false
            compactConstraint.isActive = true
        case .expanded:
            compactConstraint.isActive = false
            hiddenConstraint.isActive = false
            expandedConstraint.isActive = true
        }
        
        UIView.animate(withDuration: 0.6) {
            superView.layoutIfNeeded()
        }
    }
}

extension FactionBottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("shouldRecognizeSimultaneouslyWith")
//        print("this gesture rec: \(gestureRecognizer)")
//        print("other gesture rec: \(otherGestureRecognizer)")
//        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
//        let direction = gesture.velocity(in: view).y
//
//        let y = view.frame.minY.rounded()
//        print("view's frame y: \(y)")
//
//        // enable scrolling when view hits top (y == 100)
//        if (y == 100) {
//            scrollView.isScrollEnabled = true
//        }
//
//        // disable scrolling when view is at the top, scrollview is at top, and pan gesture is in the right direction
//        if (y == 100 && scrollView.contentOffset.y == 0 && direction > 0) {
//            scrollView.isScrollEnabled = false
//        }
        
        return false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("gestureRecognizerShouldBegin")
        return true
    }
}
