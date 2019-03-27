//
//  PBeacon+CoreDataProperties.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 11/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import Foundation
import CoreData


extension PBeacon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PBeacon> {
        return NSFetchRequest<PBeacon>(entityName: "PBeacon")
    }

    @NSManaged public var aula: String?
    @NSManaged public var major: Int32
    @NSManaged public var minor: Int32
    @NSManaged public var uuid: String?

}
