//
//  CarBudgetAPIClientProtocol.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 20/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
import UIKit

protocol CarBudgetAPIClientProtocol: APIClient {
    func submitBudgetingRequest(for email: String, message: String, image: UIImage?,completion: @escaping (APIResult<Bool>) -> Void) -> Void
}
