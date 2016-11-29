//
//  WorkOrderAPIClientProtocol.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 12/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation

protocol WorkOrderAPIClientProtocol: APIClient {
    func fetchCurrentStatus(badge: String, workOrder: Int, completion: @escaping (APIResult<Car>) -> Void) -> Void
}
