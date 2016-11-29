//
//  CarService.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 12/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
import UIKit

class CarService: CarServicing {
    
    let workOrderAPIClient: WorkOrderAPIClientProtocol?
    let carBudgetAPIClient: CarBudgetAPIClientProtocol?
    
    init(workOrderAPIClient: WorkOrderAPIClientProtocol?, carBudgetAPIClient: CarBudgetAPIClientProtocol?) {
        self.workOrderAPIClient = workOrderAPIClient
        self.carBudgetAPIClient = carBudgetAPIClient
    }
    
    public func getCarByBadgeAndWorkOrder(for badge: String, workOrder: Int, completion: @escaping (APIResult<Car>) -> Void) {
        workOrderAPIClient?.fetchCurrentStatus(badge: badge, workOrder: workOrder){ result in
            switch result {
            case .Success(let car):
                completion(APIResult.Success(car))
            case .Failure(let error):
                completion(APIResult.Failure(error))
            }
        }
    }
    
    func submitCarBudgetingRequest(for email: String, message: String, image: UIImage, completion: @escaping (APIResult<Bool>) -> Void) {
        carBudgetAPIClient?.submitBudgetingRequest(for: email, message: message, image: image){ result in
            switch result {
            case .Success(let resultBool):
                completion(APIResult.Success(resultBool))
            case .Failure(let error):
                completion(APIResult.Failure(error))
            }
        }
    }

}
