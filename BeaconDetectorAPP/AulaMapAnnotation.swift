//
//  AulaMapAnnotation.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 11/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import Foundation
import MapKit

class AulaMapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
