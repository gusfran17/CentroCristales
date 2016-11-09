//
//  WorkOrder.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 05/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation

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

struct WorkOrder{
    let id: Int
    let remarks: String
    let status: Status
}
