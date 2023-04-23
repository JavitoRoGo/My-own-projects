//
//  CoreDataManager.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 16/12/22.
//

import CoreData
import SwiftUI

class CoreDataManager: ObservableObject {
    let persistentContainer = NSPersistentContainer(name: "RingsCDModel")
    
    init() {
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                print("No se ha podido iniciar Core Data: \(error)")
            }
            self.persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
