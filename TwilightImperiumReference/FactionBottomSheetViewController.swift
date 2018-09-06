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
    
    var position: SheetPosition = .compact
    
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
        flagshipView.setMove(faction.flagship.move)
        flagshipView.setCombat(faction.flagship.hitValue)
        flagshipView.setCapacity(faction.flagship.capacity)
        flagshipView.setDescriptino(faction.flagship.ability)
        flagshipView.setNumDice(faction.flagship.numberOfRolls)
        
        commoditiesValueLabel.text = "\(faction.commodities)"
        
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveSheet(to: .compact)
    }
    
    private func startAnimationIfNeeded(followedByPause: Bool = false) {
        if animator == nil || animator.state == .stopped || animator.state == .inactive {
            initialY = view.frame.minY
            let to: SheetPosition = position == .compact ? .expanded : .compact
            animator = getAnimatorForTransition(from: position, to: to)
            print("starting animation from: \(position) to \(to)")
            if followedByPause {
                animator.pauseAnimation()
            } else {
                animator.startAnimation()
            }
        }
    }
    
    private func startTransition(from: SheetPosition, to: SheetPosition) {
        switch (from, to){
        case (.compact, .expanded):
            // TODO: Implement Transition
            break
        case (.expanded, .compact):
            // TODO: Implement Transition
            break
        default:
            fatalError("Invalid Transition from \(from) to \(to)")
        }
    }
    
    var animator: UIViewPropertyAnimator!
    var initialY: CGFloat = 0

    @objc private func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        guard !scrollView.isScrollEnabled else { return }
        guard let superView = view.superview else { fatalError("no superview") }
        switch gestureRecognizer.state {
        case .began:
            print("began pan gesture")
            startAnimationIfNeeded(followedByPause: true)
        case .changed:
            startAnimationIfNeeded(followedByPause: true)
            let translation = gestureRecognizer.translation(in: superView)
//            print("pan gesture changed with translation: \(translation)")
            let percentComplete = getAnimationPercentComplete(translation: translation, position: position)
            animator.fractionComplete = percentComplete
        case .ended:
            var velocity = gestureRecognizer.velocity(in: superView).y
            let translation = gestureRecognizer.translation(in: superView)
            
            if position == .expanded { velocity = -velocity }
            if ( abs(velocity) < 500 && abs(translation.y) < 150) || velocity > 0 {
                print("reversing animator")
                animator.isReversed = true
            }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
            // continue animation if (velocity over threshold in the right direction aka flick), (velocity under threshold, but movement is over threshold, slow and long)
            // reverse animation if (velocity under threshold and movement is under threshold)
        default:
            break
        }
    }
    
    private func getAnimatorForTransition(from: SheetPosition, to: SheetPosition) -> UIViewPropertyAnimator {
        guard let superView = view.superview else { fatalError("no superview") }
        let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut, animations: { [weak self] in
            self?.setConstraints(forPosition: to)
            superView.layoutIfNeeded()
        })
        animator.addCompletion { (pos) in
            print("finished animation from \(from) to \(to)")
            if self.animator.isReversed {
                print("finished in reverse")
                self.setConstraints(forPosition: from)
            } else {
                print("Setting position to \(to)")
                self.position = to
                if to == .expanded { self.scrollView.isScrollEnabled = true }
            }
        }
        return animator
    }
    
    private func getAnimationPercentComplete(y: CGFloat, position: SheetPosition) -> CGFloat {
        guard let superView = view.superview else { fatalError("no superview") }
        let safeBottom = superView.frame.height - superView.safeAreaInsets.bottom
        let progressFromSafeBottom = safeBottom - y
        let total = safeBottom - superView.safeAreaInsets.top
        return position == .compact ? progressFromSafeBottom / total : 1 - (progressFromSafeBottom / total)
    }
    
    private func getAnimationPercentComplete(translation: CGPoint, position: SheetPosition) -> CGFloat {
        let targetY = view.frame.minY
        let distance = abs(targetY - initialY)
        let distancePanned = position == .compact ? -translation.y : translation.y
        return distancePanned / distance
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
        
        setConstraints(forPosition: position)
        
        if position == .expanded {
            print("Enabling Scroll")
            scrollView.isScrollEnabled = true
        }
        
        UIView.animate(withDuration: 0.6) {
            superView.layoutIfNeeded()
        }
    }
    
    private func setConstraints(forPosition pos: SheetPosition) {
        switch pos {
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
        }
    }
}

extension FactionBottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("shouldRecognizeSimultaneouslyWith")
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension FactionBottomSheetViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -15 && scrollView.isScrollEnabled == true {
            scrollView.isScrollEnabled = false
//            startAnimationIfNeeded()
        }
    }
    
    func printState(panRec: UIPanGestureRecognizer) {
        switch panRec.state {
        case .began:
            print("gesture rec state: began   - with translation: \(panRec.translation(in: view.superview!))")
        case .changed:
            print("gesture rec state: changed- with translation: \(panRec.translation(in: view.superview!))")
        default:
            print("gesture rec state: other- with translation: \(panRec.translation(in: view.superview!))")
        }
    }
    
    func printAnimatorState(animator: UIViewPropertyAnimator?) {
        guard let animator = animator else { print("Animator is nil"); return }
        switch animator.state {
        case .active:
            print("Animator state: Active")
        case .inactive:
            print("Animator state: Inactive")
        case .stopped:
            print("Animator state: Stopped")
        }
    }
    
}
