//
//  AdvertService.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 18/12/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
import UIKit

class AdvertService: AdvertServicing {
    
    let advertAPIClient: AdvertAPIClientProtocol?
    
    init(advertAPIClient: AdvertAPIClientProtocol?) {
        self.advertAPIClient = advertAPIClient
    }

    
    func getBannerLink(for advertId: Int, completion: @escaping (APIResult<String>) -> Void) {
        advertAPIClient?.fetchBannerLink(for: advertId){ result in
            switch result {
            case .Success(let link):
                completion(APIResult.Success(link))
            case .Failure(let error):
                completion(APIResult.Failure(error))
            }
        }
    }
    
    func getBannerImage(for advertId: Int) -> UIImage? {
        return advertAPIClient?.fetchBannerImage(for: advertId)
    }
}
