//
//  Car.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 05/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation



struct Car {
    let badge: String
    let workOrder: WorkOrder
    init(badge: String, workOrder: WorkOrder){
        self.badge = badge
        self.workOrder = workOrder
    }
}

extension Car: JSONDecodable {
    init?(JSON: [[String: AnyObject]], badge: String) {
        guard let workOrderId = JSON[0]["id_presupuesto"] as? Int,
            let status = JSON[0]["id_estado"] as? String,
            let statusDesc = JSON[0]["descripcionEstado"] as? String,
            let remarks = JSON[0]["observaciones"] as? String else {
                return nil
        }
        let statusEnum = Status(rawValue: status, remark: statusDesc)
        let workOrder = WorkOrder(id: workOrderId, remarks: remarks, status: statusEnum)
        self.badge = badge
        self.workOrder = workOrder
    }
}
