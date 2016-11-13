//
//  CarService.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 12/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation

class CarService: CarServicing {
    
    let workOrderAPIClient: WorkOrderAPIClientProtocol?
    
    init(workOrderAPIClient: WorkOrderAPIClientProtocol) {
        self.workOrderAPIClient = workOrderAPIClient
    }
    
    public func getCarByBadgeAndWorkOrder(for badge: String, workOrder: Int, completion: @escaping (APIResult<Car>) -> Void) {
        workOrderAPIClient?.fetchCurrentStatus(workOrder: workOrder, badge: badge){ result in
            switch result {
            case .Success(let car):
                completion(APIResult.Success(car))
            case .Failure(let error):
                completion(APIResult.Failure(error))
            }
        }
    }

}
