//
//  CarService.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 12/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
import UIKit
protocol CarServicing {
    func getCarByBadgeAndWorkOrder(for badge: String, workOrder: Int, completion: @escaping (APIResult<Car>) -> Void) -> Void
    func submitCarBudgetingRequest(for email: String, message: String, image: UIImage, completion: @escaping (APIResult<Bool>) -> Void) -> Void
}
