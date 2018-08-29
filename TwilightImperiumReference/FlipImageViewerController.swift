//
//  ViewController.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/9/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

class FlipImageViewerController: UIViewController {
    
    var scrollView: UIScrollView!
    var firstImageView: UIImageView!
    var secondImageView: UIImageView!
    var showingImage: UIImageView!
    var containerView: UIView!
    let firstImage: UIImage
    let secondImage: UIImage
    let faction: Faction
    weak var factionBottomSheet: FactionBottomSheetViewController?
    
    let flipSpeed = 0.75
    
    init(faction: Faction, firstImage: UIImage, secondImage: UIImage) {
        self.faction = faction
        self.firstImage = firstImage
        self.secondImage = secondImage
        super.init(nibName: nil, bundle: Bundle(for: FlipImageViewerController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        let safe = view.safeAreaLayoutGuide
        
        scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safe.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safe.trailingAnchor)
        ])

        firstImageView = UIImageView(image: firstImage)
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        firstImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(firstImageView)
        NSLayoutConstraint.activate([
            firstImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            firstImageView.heightAnchor.constraint(equalTo: firstImageView.widthAnchor),
            firstImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            firstImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        secondImageView = UIImageView(image: secondImage)
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        secondImageView.contentMode = .scaleAspectFit
        secondImageView.isHidden = true
        
        showingImage = firstImageView
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(firstImageView)
        containerView.addSubview(secondImageView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: firstImageView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: firstImageView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: firstImageView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: firstImageView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: secondImageView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: secondImageView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: secondImageView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: secondImageView.bottomAnchor)
        ])
        
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
//        scrollView.contentSize = self.containerView.frame.size
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(flipImage))
        containerView.addGestureRecognizer(tapRec)
        containerView.isUserInteractionEnabled = true
        
        // right bar button item
        let factionTechImage = UIImage(named: "brain_small")!
        let factionTechButton = UIBarButtonItem(image: factionTechImage, style: .plain, target: self, action: #selector(showFactionTech))
        navigationItem.rightBarButtonItem = factionTechButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // add bottom sheet
        addBottomSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let shiftHeight = (scrollView.frame.height/2.0) - (view.frame.width/2.0)
        scrollView.contentInset.top = shiftHeight
    }
    
    private func addBottomSheet() {
        let bottomSheet = FactionBottomSheetViewController(faction: faction)
        factionBottomSheet = bottomSheet
        addChild(bottomSheet)
        // Add View
        bottomSheet.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSheet.view)
        bottomSheet.hiddenConstraint = bottomSheet.view.topAnchor.constraint(equalTo: view.bottomAnchor)
        bottomSheet.peekingConstraint = bottomSheet.view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        bottomSheet.compactConstraint = bottomSheet.view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)
        bottomSheet.expandedConstraint = bottomSheet.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([
            bottomSheet.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottomSheet.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            bottomSheet.hiddenConstraint,
            bottomSheet.view.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        view.layoutIfNeeded()
        bottomSheet.didMove(toParent: self)
    }
    
    @objc func flipImage() {
        print("flipping image!")
        let fromImage = showingImage
        let toImage = showingImage == firstImageView ? secondImageView : firstImageView
        UIView.transition(from: fromImage!, to: toImage!, duration: flipSpeed, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        showingImage = toImage
    }
    
    func adjustShowingImage() {
        if containerView.frame.height <= scrollView.frame.height {
            print("centering height")
            let shiftHeight = scrollView.frame.height/2.0 - scrollView.contentSize.height/2.0
            scrollView.contentInset.top = shiftHeight
        }
        if containerView.frame.width <= scrollView.frame.width {
            print("centering width")
            let shiftWidth = scrollView.frame.width/2.0 - scrollView.contentSize.width/2.0
            scrollView.contentInset.left = shiftWidth
        }
    }
    
    @objc private func showFactionTech() {
        
        let techController = TechnologyTableViewController(withFaction: faction)
        let newNav = UINavigationController(rootViewController: techController)
        techController.navigationItem.title = "All Techs"
        newNav.modalPresentationStyle = .overCurrentContext
        present(newNav, animated: true, completion: nil)
    }
}

extension FlipImageViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("zoomed to: \(scrollView.zoomScale)")
        adjustShowingImage()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("did zoom to scale: \(scrollView.zoomScale) -- view is front view: \(view == firstImageView)")
    }
    
}

