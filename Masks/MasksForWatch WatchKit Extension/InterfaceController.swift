//
//  InterfaceController.swift
//  MasksForWatch WatchKit Extension
//
//  Created by Javier Rodríguez Gómez on 12/10/21.
//

import WatchKit
import Foundation
import UIKit

var model = MasksModel(masks: masksFromFirebase)

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var myTable: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        let num = model.numberOfOwners()
        let ownerArray = Owner.allCases
        
        myTable.setNumberOfRows(num, withRowType: "zelda")
        for (index, owner) in ownerArray.enumerated() {
            let row = myTable.rowController(at: index) as! MyRowController
            row.ownerLabel.setText(owner.rawValue)
        }
    }
    
    override func willActivate() {
        super.willActivate()
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        // This method is called when watch view controller is no longer visible
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if segueIdentifier == "mySegue" {
            return Owner.allCases[rowIndex]
        }
        return nil
    }
}
