//
//  PEdificio+CoreDataProperties.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 07/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import Foundation
import CoreData


extension PEdificio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PEdificio> {
        return NSFetchRequest<PEdificio>(entityName: "PEdificio")
    }

    @NSManaged public var descrizione: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var nome: String?

}
