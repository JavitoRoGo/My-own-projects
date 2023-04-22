//
//  AddNewViewController.swift
//  Masks
//
//  Created by Javier Rodríguez Gómez on 14/11/21.
//

import UIKit
import FirebaseFirestore

class AddNewViewController: UIViewController {
    
    var owner: Owner?
    
    // MARK: - Outlets
    
    @IBOutlet var nameTextFieldOutlet: UITextField!
    @IBOutlet var ownerPickerOutlet: UIPickerView!
    @IBOutlet var imageTextFieldOutlet: UITextField!
    @IBOutlet var selectImageButtonOutlet: UIButton!
    @IBOutlet var imageViewOutlet: UIImageView!
    
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Nueva mascarilla"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .plain, target: self, action: #selector(save))
        
        ownerPickerOutlet.dataSource = self
        ownerPickerOutlet.delegate = self
        
        initialData()
    }
    
    // MARK: - Button action
    
    @IBAction func selectImageButtonAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    // MARK: - Functions
    
    func initialData() {
        let index = Owner.allCases.firstIndex(of: owner!)!
        
        nameTextFieldOutlet.text = ""
        ownerPickerOutlet.selectRow(index, inComponent: 0, animated: true)
        imageTextFieldOutlet.text = ""
        selectImageButtonOutlet.setTitle("Seleccionar la imagen", for: .normal)
        imageViewOutlet.image = UIImage()
    }
    
    @objc func save() {
        let ac = UIAlertController(title: "¿Quieres guardar esta mascarilla?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        ac.addAction(UIAlertAction(title: "Sí", style: .default) { _ in
            let name = self.nameTextFieldOutlet.text!
            let owner = Owner.allCases[self.ownerPickerOutlet.selectedRow(inComponent: 0)]
            let image = self.imageTextFieldOutlet.text!
            let washes: [Int] = []
            let dates: [String] = []
            let newMask = Masks(name: name, owner: owner, washes: washes, dates: dates, image: image, isActive: true)
            masksModel.masks.append(newMask)
            
            db.collection("masks").document(name).setData([
                "owner": owner.rawValue,
                "image": image,
                "washes": washes,
                "dates": dates,
                "active": true
            ])
            
            self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
}

// MARK: - Extensions for Picker and ImagePicker

extension AddNewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Owner.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Owner.allCases[row].rawValue
    }
}

extension AddNewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = imageTextFieldOutlet.text!
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName).appendingPathExtension("jpg")
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            print(imagePath.absoluteString)
            print("Se guardó la imagen \(imageName)")
            selectImageButtonOutlet.setTitle("Cambiar la imagen", for: .normal)
            imageViewOutlet.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
