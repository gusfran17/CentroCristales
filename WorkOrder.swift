//
//  WorkOrder.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 05/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
import ObjectMapper

enum Status{
    case InGarage(String)
    case Passed(String)
    case Finalized(String)
    case NotFound(String)
    
    init(rawValue: String, remark: String){
        switch (rawValue) {
        case "ENT":
            self = .InGarage(remark)
        case "PAS":
            self = .Passed(remark)
        case "TER":
            self = .Finalized(remark)
        default:
            self = .NotFound(remark)
        }
    }
}

struct WorkOrder: Mappable{
    var id: Int?
    var remarks: String?
    var status: Status?
    
    init?(map: Map) {
        
    }
    
    init(id: Int, remarks: String, status: Status){
        self.id = id
        self.remarks = remarks
        self.status = status
    }
    
    mutating func mapping(map: Map) {
        id    <- map["id_presupuesto"]
        remarks <- map["observaciones"]
        guard let status = map["id_estado"].currentValue as! String?,
            let statusDesc = map["descripcionEstado"].currentValue as! String?
            else {
                return
        }
        self.status = Status(rawValue: status, remark: statusDesc)
    }
}


