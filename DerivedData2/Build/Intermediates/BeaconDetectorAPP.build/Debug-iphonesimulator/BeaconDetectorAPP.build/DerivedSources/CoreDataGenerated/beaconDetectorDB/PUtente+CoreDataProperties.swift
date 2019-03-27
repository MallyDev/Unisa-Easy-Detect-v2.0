//
//  PUtente+CoreDataProperties.swift
//  
//
//  Created by Maria Laura Bisogno on 03/01/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension PUtente {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PUtente> {
        return NSFetchRequest<PUtente>(entityName: "PUtente")
    }

    @NSManaged public var anno: NSDate?
    @NSManaged public var cdl: String?
    @NSManaged public var matr: String?
    @NSManaged public var nome: String?

}
