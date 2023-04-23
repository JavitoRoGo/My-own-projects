//
//  TrainingEntityClass.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 16/12/22.
//

import CoreData
import Foundation


@objc(TrainingEntity)
public class TrainingEntity: NSManagedObject {

}

extension TrainingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingEntity> {
        return NSFetchRequest<TrainingEntity>(entityName: "TrainingEntity")
    }

    @NSManaged public var duration: Double
    @NSManaged public var length: Double
    @NSManaged public var calories: Int16
    @NSManaged public var meanHR: Int16
    @NSManaged public var type: String
    @NSManaged public var toRing: RingEntity?
    
    var trainingType: TrainingType {
        get {
            return TrainingType(rawValue: type) ?? .toRun
        }
        set {
            type = newValue.rawValue
        }
    }
    
    var velocity: Double {
        if duration == 0 {
            return 0.0
        }
        return length / duration * 60
    }
}

extension TrainingEntity : Identifiable {

}


enum TrainingType: String, CaseIterable, Identifiable, Codable {
    case toRun = "Correr"
    case toWalk = "Caminar"
    
    var id: Self { return self }
}
