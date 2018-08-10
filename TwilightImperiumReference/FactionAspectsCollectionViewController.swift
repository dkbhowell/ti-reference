//
//  FactionAspectsCollectionViewController.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/10/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FactionAspectsCollectionViewController: UICollectionViewController {
    
    let aspects: [FactionAspect] = [.sheet, .technology]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 30, bottom: 0, right: 30)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aspects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let aspect = aspects[indexPath.row]
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let image: UIImage
        let title: String
        switch aspect {
        case .sheet:
            image = UIImage(named: "office-file-sheet")!
            title = "Faction Sheet"
        case .technology:
            image = UIImage(named: "brain-1")!
            title = "Faction Tech"
        }
        let lbledImg = LabeledImage(image: image, title: title)
        cell.contentView.addSubview(lbledImg)
        lbledImg.pin(toView: cell.contentView, withPadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        let imageView = UIImageView(image: image)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
//        cell.contentView.addSubview(imageView)
//        imageView.pin(toView: cell.contentView)
        cell.contentView.backgroundColor = UIColor.lightGray
        cell.contentView.layer.cornerRadius = 10
        return cell
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension FactionAspectsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnCount: CGFloat = 2
        let screenWidth = view.bounds.width
        let insets: CGFloat = 30 * 2
        let itemSpacing: CGFloat = 30 * (columnCount - 1)
        let padding: CGFloat = 0
        let netWidth = screenWidth - itemSpacing - padding - insets
        let widthPerItem: CGFloat = netWidth / columnCount
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
