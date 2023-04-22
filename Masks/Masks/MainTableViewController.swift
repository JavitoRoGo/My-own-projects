//
//  MainTableViewController.swift
//  Masks
//
//  Created by Javier Rodríguez Gómez on 15/8/21.
//

import UIKit
import FirebaseFirestore

let db = Firestore.firestore()
var masksModel = MasksModel()

class MainTableViewController: UITableViewController {
    
    // MARK: - UI view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Mascarillas"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "icloud.and.arrow.down"), style: .plain, target: self, action: #selector(loadData))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.toolbar.isHidden = true
        
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        masksModel.numberOfOwners()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        cell.textLabel?.text = masksModel.titleForCells(indexPath: indexPath)
        cell.detailTextLabel?.text = masksModel.subtitleForCells(indexPath: indexPath)
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? MainCollectionViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        vc.owner = Owner.allCases[indexPath.row]
    }
    
    @objc func loadData() {
        let ac = UIAlertController(title: "¿Deseas descargar los datos desde la nube?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        ac.addAction(UIAlertAction(title: "Sí", style: .default) { _ in
            var array = [Masks]()
            db.collection("masks").getDocuments() { (querySnapshot, error) in
                if let query = querySnapshot, error == nil {
                    for document in query.documents {
                        if let newOwner = document.get("owner") as? String,
                           let newImage = document.get("image") as? String,
                           let newWashes = document.get("washes") as? [Int],
                           let newDates = document.get("dates") as? [String],
                           let newActive = document.get("active") as? Bool {
                            let newMask = Masks(name: document.documentID, owner: Owner.init(rawValue: newOwner)!, washes: newWashes, dates: newDates, image: newImage, isActive: newActive)
                            array.append(newMask)
                        }
                    }
                    masksModel.masks = array
                    self.tableView.reloadData()
                }
            }
        })
        present(ac, animated: true)
    }
    
}
