//
//  City+CoreDataProperties.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/29/23.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var name: String?
    @NSManaged public var longitude: Double

}

extension City : Identifiable {

}
