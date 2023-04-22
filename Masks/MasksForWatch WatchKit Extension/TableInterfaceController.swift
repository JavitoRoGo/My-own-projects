//
//  TableInterfaceController.swift
//  MasksForWatch WatchKit Extension
//
//  Created by Javier Rodríguez Gómez on 15/10/21.
//

import WatchKit
import Foundation


class TableInterfaceController: WKInterfaceController {
    
    var masksArray = [Masks]()
    
    @IBOutlet var table: WKInterfaceTable!
            
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let owner = context as? Owner else { return }
        
        setTitle(owner.rawValue)
        let num = model.numberOfMasks(owner: owner)
        let array = model.queryMasks(owner: owner)
        masksArray = array
        
        table.setNumberOfRows(num, withRowType: "Row")
        for (index, mask) in array.enumerated() {
            let washes = model.numberOfWashes(mask: array[index])
            let row = table.rowController(at: index) as! MaskRow
            row.textLabel.setText(mask.name)
            row.numLabel.setText("\(washes)")
        }
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if segueIdentifier == "mySecondSegue" {
            return masksArray[rowIndex]
        }
        return nil
    }

}
