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
    @IBOutlet weak var startingTechStack: UIStackView!
    @IBOutlet weak var flagshipView: FlagshipView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commoditiesValueLabel: UILabel!
    
    // MARK: Properties
    let faction: Faction
    let blurredView: UIVisualEffectView
    var hiddenConstraint: NSLayoutConstraint!
    var compactConstraint: NSLayoutConstraint!
    var expandedConstraint: NSLayoutConstraint!
    var peekingConstraint: NSLayoutConstraint!
    
    var position: SheetPosition = .compact {
        didSet {
            moveSheet(to: position)
        }
    }
    
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
        
        startingTechStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for tech in faction.startingTechs {
            let techCard = TechCardView(title: tech.name, cardText: tech.description, prereqString: tech.prereqString)
            techCard.setAppearance(forTechType: tech.type)
            startingTechStack.addArrangedSubview(techCard)
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
        
        commoditiesValueLabel.text = "\(faction.commodities)"
        
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
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
        let newFrame = CGRect(x: 0, y: newy, width: view.frame.width, height: view.frame.height)
        self.view.frame = newFrame
        gestureRecognizer.setTranslation(.zero, in: self.view)

        if gestureRecognizer.state == .ended {
            print("Gesture ended")
            guard let superView = view.superview else { return }
            superView.setNeedsLayout()
            let velocity = gestureRecognizer.velocity(in: superView)
            print("Velocity of pan: \(velocity)")
            let newPosition = abs(velocity.y) > 100 ? findNextPosition(startingPosition: position, velocity: velocity) : findClosestPosition(newY: newy)
            position = newPosition
        }
    }
    
    private func findNextPosition(startingPosition: SheetPosition, velocity: CGPoint) -> SheetPosition {
        let next = velocity.y > 0 ? startingPosition.down() : startingPosition.up()
        let minPosition: SheetPosition = .compact
        return next.rawValue < minPosition.rawValue ? minPosition : next
    }
    
    private func findClosestPosition(newY: CGFloat) -> SheetPosition {
        guard let superViewHeight = view.superview?.frame.height else { return .peeking }
        let expandedRange = 0..<(superViewHeight * 1 / 2)
        let compactRange = expandedRange.upperBound..<(superViewHeight * 4 / 5)
        let peekingRange = compactRange.upperBound..<superViewHeight
        
        switch newY {
        case expandedRange:
            return .expanded
        case compactRange:
            return .compact
        case peekingRange:
            return .compact
        default:
            return .peeking
        }
    }

}

extension FactionBottomSheetViewController {
    enum SheetPosition: Int {
        case hidden, peeking, compact, expanded
        
        func up() -> SheetPosition {
            return SheetPosition(rawValue: rawValue + 1) ?? self
        }
        func down() -> SheetPosition {
            return SheetPosition(rawValue: rawValue - 1) ?? self
        }
    }
    
    enum VerticalDirection {
        case down, up
    }
    
    func moveSheet(to position: SheetPosition) {
        guard let superView = view.superview else { return }
        
        switch position {
        case .peeking:
            compactConstraint.isActive = false
            expandedConstraint.isActive = false
            hiddenConstraint.isActive = false
            peekingConstraint.isActive = true
        case .hidden:
            peekingConstraint.isActive = false
            compactConstraint.isActive = false
            expandedConstraint.isActive = false
            hiddenConstraint.isActive = true
        case .compact:
            peekingConstraint.isActive = false
            expandedConstraint.isActive = false
            hiddenConstraint.isActive = false
            compactConstraint.isActive = true
        case .expanded:
            peekingConstraint.isActive = false
            compactConstraint.isActive = false
            hiddenConstraint.isActive = false
            expandedConstraint.isActive = true
            print("Enabling Scroll")
            scrollView.isScrollEnabled = true
        }
        
        UIView.animate(withDuration: 0.6) {
            superView.layoutIfNeeded()
        }
    }
}

extension FactionBottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension FactionBottomSheetViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -50 {
            scrollView.isScrollEnabled = false
            moveSheet(to: .compact)
        }
    }
}
