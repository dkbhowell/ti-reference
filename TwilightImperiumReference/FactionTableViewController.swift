//
//  FactionTableViewController.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/9/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

class FactionTableViewController: UITableViewController {
    let reuseId = "factionCellReuseId"
    
    var factions = [Faction]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let allTechIcon = UIImage(named: "brain_small")!
        let allTechBarButtonItem = UIBarButtonItem(image: allTechIcon, style: .plain, target: self, action: #selector(showGenericTechs))
        navigationItem.rightBarButtonItem = allTechBarButtonItem
        navigationItem.title = "TI4 Factions"
        
        // test loading techs
        loadFactions()
    }
    
    private func loadTechs() {
        guard let path = Bundle(for: FactionTableViewController.self).path(forResource: "ti_generic_tech", ofType: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let jsonResult = try JSONDecoder().decode(TechnologyData.self, from: data)
            let techs = jsonResult.generic_technologies
            print("Gotcha techs: \(techs)")
        } catch {
            fatalError("Failed to Load Technologies Data")
        }
    }
    
    private func loadFactions() {
        guard let path = Bundle(for: FactionTableViewController.self).path(forResource: "ti_factions", ofType: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let jsonResult = try JSONDecoder().decode(FactionData.self, from: data)
            let factions = jsonResult.factions
            self.factions = factions
            tableView.reloadData()
        } catch {
            print("Error: \(error)")
            fatalError("Failed to Load Technologies Data: \(error)")
        }
    }
    
    @objc private func showGenericTechs() {
        let techTable = TechnologyTableViewController(withTechnologies: Technology.allGenerics)
        techTable.navigationItem.title = "Generic Techs"
        let newNav = UINavigationController(rootViewController: techTable)
        newNav.modalPresentationStyle = .overCurrentContext
        present(newNav, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) ?? UITableViewCell(style: .value1, reuseIdentifier: reuseId)
        let faction = factions[indexPath.row]
        cell.textLabel?.text = faction.name
        cell.detailTextLabel?.text = "\(faction.deviation)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let faction = factions[indexPath.row]
        let firstImage = UIImage(named: "\(faction.resourcePrefix)_front")!
        let secondImage = UIImage(named: "\(faction.resourcePrefix)_back")!
        let factionSheetImageController = FlipImageViewerController(faction: faction, firstImage: firstImage, secondImage: secondImage)
        
//        let factionAspectsController = FactionAspectsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
//
//        let techController = TechnologyTableViewController()
        self.navigationController?.pushViewController(factionSheetImageController, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
