//
//  AdvertServicing.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 18/12/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
import UIKit
protocol AdvertServicing {
    func getBannerLink(for advertId: Int, completion: @escaping (APIResult<String>) -> Void) -> Void
    func getBannerImage(for advertId: Int) -> UIImage?
}
