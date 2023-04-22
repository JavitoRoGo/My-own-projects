//
//  AddNewInterfaceController.swift
//  MasksForWatch WatchKit Extension
//
//  Created by Javier Rodríguez Gómez on 17/10/21.
//

import WatchKit
import Foundation


class AddNewInterfaceController: WKInterfaceController {
    
    var mask: Masks?
    var number: Int = 0
    
    @IBOutlet var washLabel: WKInterfaceLabel!
    @IBOutlet var dateLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let mask = context as? Masks else { return }
        self.mask = mask
        number = mask.washes.count
        
        setTitle(mask.name)
        washLabel.setText("\(mask.washes.last ?? 0) lavados")
        dateLabel.setText(mask.dates.last)
        
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func addNewWash() {
        guard var mask = mask else { return }

        if number < 50 {
            number += 1
            mask.washes.append(number)
            let date = model.formatDate(Date())
            mask.dates.append(date)
            model.addNewWash(mask: mask)
            washLabel.setText("\(mask.washes.last ?? 0) lavados")
            dateLabel.setText(mask.dates.last)
        } else if number >= 50 {
            let okButton = WKAlertAction(title: "Cerrar", style: .cancel) {}
            presentAlert(withTitle: "50 lavados.", message: "Se ha llegado al límite.", preferredStyle: .alert, actions: [okButton])
        }
    }

}
