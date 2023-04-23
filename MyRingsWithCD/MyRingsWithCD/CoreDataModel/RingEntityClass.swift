//
//  RingEntityClass.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 16/12/22.
//

import CoreData
import Foundation


@objc(RingEntity)
public class RingEntity: NSManagedObject {

}

extension RingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RingEntity> {
        return NSFetchRequest<RingEntity>(entityName: "RingEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var movement: Int16
    @NSManaged public var exercise: Int16
    @NSManaged public var standUp: Int16
    @NSManaged public var isTraining: Bool
    @NSManaged public var toTrain: TrainingEntity?

}

// MARK: Generated accessors for toTrain
extension RingEntity : Identifiable {
    
}
