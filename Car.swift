//
//  Car.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 05/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
import ObjectMapper


struct Car: Mappable {
    var badge: String?
    var workOrder: WorkOrder?
    
    init(badge: String, workOrder: WorkOrder){
        self.badge = badge
        self.workOrder = workOrder
    }
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        badge    <- map["dominio"]
        workOrder = WorkOrder(JSON: map.JSON)
    }
}


