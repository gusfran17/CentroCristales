//
//  WorkOrderRepository.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 12/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation

protocol CarRepository {
    func getCarByCarByBadgeAndWorkOrder(badge: String, workOrder: String) -> Car
}
