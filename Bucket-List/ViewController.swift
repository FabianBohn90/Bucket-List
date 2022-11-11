//
//  ViewController.swift
//  Bucket-List
//
//  Created by Fabian Bohn on 11.11.22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    var editable = false
    var zuBesuchendeOrte = ["Griechenland","Japan"]
    var schonBesuchteOrte: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        let alert = UIAlertController(title: "Hinzufügen", message: "Welchen Ort willst du Hinzufügen", preferredStyle: .alert)
        
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel))
        alert.addAction(UIAlertAction(title: "Hinzufügen", style: .default, handler: {(_) in
            let text = alert.textFields?.first?.text
            self.zuBesuchendeOrte.append(text!)
            self.myTableView.reloadData()
        }))
        present(alert, animated: true)
    }
    
    @IBAction func edittrue(_ sender: UIBarButtonItem) {
        self.myTableView.isEditing = !self.myTableView.isEditing
        sender.title = (self.myTableView.isEditing) ? "Done" : "Edit"
    }
    
}




extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if (section == 0){
            return "Orte zu Besuchen"
        }else {
            return "Schon Besucht"
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath ) {
        
            let data = zuBesuchendeOrte[sourceIndexPath.item]
            zuBesuchendeOrte.remove (at: sourceIndexPath.item)
            zuBesuchendeOrte.insert (data, at: destinationIndexPath.item)
    }
    
    
    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return zuBesuchendeOrte.count
        } else {
            return schonBesuchteOrte.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            var content = cell.defaultContentConfiguration()
            content.text = zuBesuchendeOrte[indexPath.row]
            cell.contentConfiguration = content
            cell.accessoryType = .none
        }else {
            if indexPath.section == 1 {
                var content = cell.defaultContentConfiguration()
                content.text = schonBesuchteOrte[indexPath.row]
                cell.contentConfiguration = content
                cell.accessoryType = .checkmark
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            if(indexPath.section == 0){
                zuBesuchendeOrte.remove(at: indexPath.row)
                myTableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                schonBesuchteOrte.remove(at: indexPath.row)
                myTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section) == 0{
            let data = zuBesuchendeOrte[indexPath.row]
            schonBesuchteOrte.append(data)
            zuBesuchendeOrte.remove(at: indexPath.row)
        }
        
        if (indexPath.section) == 1{
            let data = schonBesuchteOrte[indexPath.row]
            zuBesuchendeOrte.append(data)
            schonBesuchteOrte.remove(at: indexPath.row)
        }
        myTableView.reloadData()
    }
}

