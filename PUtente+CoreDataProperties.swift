//
//  PUtente+CoreDataProperties.swift
//  BeaconDetectorAPP
//
//  Created by Maria Laura Bisogno on 03/01/18.
//  Copyright © 2018 Marco Capozzo. All rights reserved.
//
//

import Foundation
import CoreData


extension PUtente {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PUtente>{
        return NSFetchRequest<PUtente>(entityName: "PUtente")
    }

    @NSManaged public var anno: String?
    @NSManaged public var cdl: String?
    @NSManaged public var matr: String?
    @NSManaged public var nome: String?
    
}
