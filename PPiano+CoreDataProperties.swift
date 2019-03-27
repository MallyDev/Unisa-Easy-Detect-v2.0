//
//  PPiano+CoreDataProperties.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 07/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import Foundation
import CoreData


extension PPiano {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PPiano> {
        return NSFetchRequest<PPiano>(entityName: "PPiano")
    }

    @NSManaged public var descrizione: String?
    @NSManaged public var edificio: String?
    @NSManaged public var numero: Int16

}
