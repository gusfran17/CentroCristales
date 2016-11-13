//
//  CarService.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 12/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
protocol CarServicing {
    func getCarByBadgeAndWorkOrder(for badge: String, workOrder: Int, completion: @escaping (APIResult<Car>) -> Void) -> Void
}
