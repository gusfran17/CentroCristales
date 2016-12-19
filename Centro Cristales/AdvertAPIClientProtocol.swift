//
//  AdvertAPIClientProtocol.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 18/12/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
import UIKit

protocol AdvertAPIClientProtocol: APIClient {
    func fetchBannerLink( for advertId: Int, completion: @escaping (APIResult<String>) -> Void) -> Void
    func fetchBannerImage( for advertId: Int) -> UIImage?
}
