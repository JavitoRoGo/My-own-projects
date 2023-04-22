//
//  MainCollectionViewController.swift
//  Masks
//
//  Created by Javier Rodríguez Gómez on 15/8/21.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
    
    var owner: Owner?
    var mask = Masks()
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = owner?.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.toolbar.isHidden = true
        
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let owner = owner else { fatalError() }
        return masksModel.numberOfMasks(owner: owner)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zelda", for: indexPath) as? MaskCell,
              let owner = owner else { fatalError() }
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 10
        cell.imageOutlet.alpha = 1
        cell.nameOutlet.textColor = .systemBlue
        cell.washesOutlet.textColor = .systemBlue
        
        cell.isActiveOutlet.tag = indexPath.row
        cell.isActiveOutlet.addTarget(self, action: #selector(activation), for: .valueChanged)
        
        mask = masksModel.queryMasks(owner: owner, indexPath: indexPath)
        cell.imageOutlet.image = masksModel.getMaskImage(imageName: mask.image)
        cell.nameOutlet.text = mask.name
        cell.washesOutlet.text = "\(masksModel.numberOfWashes(mask: mask)) lavados"
        cell.isActiveOutlet.isOn = mask.isActive
        if !mask.isActive {
            cell.imageOutlet.alpha = 0.5
            cell.nameOutlet.textColor = .systemGray5
            cell.washesOutlet.textColor = .systemGray5
        }
        return cell
    }
    
    // MARK: - Switch action
    
    @objc func activation(sender: UISwitch) {
        mask = masksModel.masks.filter { $0.owner == owner }[sender.tag]
        mask.isActive.toggle()
        masksModel.setIsActive(mask: mask)
        collectionView.reloadData()
        
        db.collection("masks").document(mask.name).setData([
            "active": mask.isActive
        ], merge: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailTableViewController,
              let owner = owner,
              let indexPath = collectionView.indexPathsForSelectedItems else { return }
        vc.mask = masksModel.queryMasks(owner: owner, indexPath: indexPath[0])
    }
    
    @objc private func addNewMask() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NewMask") as? AddNewViewController {
            vc.owner = owner
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
