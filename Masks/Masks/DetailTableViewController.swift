//
//  DetailTableViewController.swift
//  Masks
//
//  Created by Javier Rodríguez Gómez on 16/8/21.
//

import UIKit
import FirebaseFirestore

class DetailTableViewController: UITableViewController {
    
    var mask: Masks?
    var number: Int = 0 {
        didSet {
            title = "\(mask!.name): \(number) lavados"
        }
    }
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNew))
        if !mask!.isActive {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        number = masksModel.numberOfWashes(mask: mask!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.toolbar.isHidden = true
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        number
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        cell.textLabel?.text = String(mask!.washes.reversed()[indexPath.row])
        cell.detailTextLabel?.text = "\(mask!.dates.reversed()[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let index = mask!.washes.firstIndex(where: { $0 == mask!.washes.reversed()[indexPath.row] }) {
                masksModel.deleteWashes(mask: mask!, indexPath: indexPath)
                mask!.washes.remove(at: index)
                mask!.dates.remove(at: index)
                number -= 1
                tableView.deleteRows(at: [indexPath], with: .fade)
                saveToFirebase()
            }
        }
    }
    
    // MARK: - Functions
    
    @objc func addNew() {
        if number >= 50 {
            let ac = UIAlertController(title: "Se ha alcanzado el número máximo de lavados.", message: "Esta mascarilla debe descartarse.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Aceptar", style: .cancel))
            present(ac, animated: true)
        } else {
            let screenWidth = UIScreen.main.bounds.width - 10
            let screeHeight = UIScreen.main.bounds.height / 6
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: screenWidth, height: screeHeight)
            let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screeHeight))
            picker.preferredDatePickerStyle = .wheels
            picker.datePickerMode = .date
            picker.locale = Locale(identifier: "es_ES")
            picker.maximumDate = Date()
            vc.view.addSubview(picker)
            picker.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
            picker.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
            
            let ac = UIAlertController(title: "¿Añadir un nuevo lavado?", message: nil, preferredStyle: .actionSheet)
            ac.setValue(vc, forKey: "contentViewController")
            ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            ac.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
                let dateString = masksModel.formatDate(picker.date)
                self.addNewData(dateString)
            })
            present(ac, animated: true)
        }
    }
    
    func addNewData(_ date: String) {
        number += 1
        
        mask?.washes.append(number)
        mask?.dates.append(date)
        
        if number == 50 {
            let ac = UIAlertController(title: "¡Atención, último lavado!", message: "La mascarilla dejará de estar activa.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Aceptar", style: .cancel) { _ in
                self.mask?.isActive = false
            })
            present(ac, animated: true)
        }
        
        masksModel.addNewWash(mask: mask!)
        tableView.reloadData()
        saveToFirebase()
    }
    
    // Guardar los datos en Firestore
    func saveToFirebase() {
        guard let mask = mask else { return }

        db.collection("masks").document(mask.name).setData([
            "owner": mask.owner.rawValue,
            "washes": mask.washes,
            "dates": mask.dates,
            "image": mask.image,
            "active": mask.isActive
        ], merge: true)
    }
    
}
