//
//  PAula+CoreDataProperties.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 07/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import Foundation
import CoreData


extension PAula {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PAula> {
        return NSFetchRequest<PAula>(entityName: "PAula")
    }

    @NSManaged public var capienza: Int16
    @NSManaged public var codice: String?
    @NSManaged public var descrizione: String?
    @NSManaged public var edificio: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var nome: String?
    @NSManaged public var piano: Int16

}
