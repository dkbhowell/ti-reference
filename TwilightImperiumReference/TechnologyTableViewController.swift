//
//  TechnologyTableViewController.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/10/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

class TechnologyTableViewController: UITableViewController {
    let reuseId = "cellReuseId"
    var technologies = Technology.allGenerics
    var faction: Faction?
    
    convenience init(withFaction faction: Faction) {
        self.init(withTechnologies: faction.factionTechs + Technology.allGenerics)
        self.faction = faction
    }
    
    init(withTechnologies techs: [Technology]) {
        self.technologies = techs
        super.init(nibName: nil, bundle: Bundle(for: TechnologyTableViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        tableView.separatorStyle = .none
        let doneNavButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finish))
        navigationItem.rightBarButtonItem = doneNavButton
        
        let clearOwnedTechsButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(clearOwnedTechs))
        navigationItem.leftBarButtonItem = clearOwnedTechsButton
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
//        tableView.allowsSelection = false

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.title = PlayerState.shared.getTechString()
    }
    
    @objc private func finish() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func clearOwnedTechs() {
        if let faction = faction {
            PlayerState.shared.ownedTechnologies = faction.startingTechs
        } else {
            PlayerState.shared.ownedTechnologies = []
        }
        tableView.reloadData()
        navigationItem.title = PlayerState.shared.getTechString()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return technologies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseId)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let technology = technologies[indexPath.row]
        let techCard = TechCardView(title: technology.name, cardText: technology.cardText, prereqString: technology.prereqString)
        techCard.setAppearance(forTechType: technology.type)
        cell.backgroundColor = UIColor.clear
        cell.contentView.addSubview(techCard)
        techCard.pin(toView: cell.contentView, withPadding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        techCard.layer.cornerRadius = 10
        
        let ownedTechs = PlayerState.shared.ownedTechnologies
        if ownedTechs.contains(where: { $0.name == technology.name }) {
            techCard.setAppearance(forState: .owned)
        } else if PlayerState.shared.meetsPrerequisites(forTech: technology) {
            techCard.setAppearance(forState: .canResearch)
        } else {
            techCard.setAppearance(forState: .cannotResearch)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tech = technologies[indexPath.row]
        let ownedTechs = PlayerState.shared.ownedTechnologies
        if ownedTechs.contains(tech) {
            PlayerState.shared.ownedTechnologies = ownedTechs.filter { $0 != tech }
            tableView.reloadData()
        } else if PlayerState.shared.meetsPrerequisites(forTech: tech) {
            PlayerState.shared.ownedTechnologies.append(tech)
            tableView.reloadData()
        }
        navigationItem.title = PlayerState.shared.getTechString()
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
