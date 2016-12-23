//
//  AdvertAPIClient.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 18/12/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
import UIKit

enum AdvertEndpoint: Endpoint {
    case Link(advertId: Int)
    case Image(advertId: Int)
    
    var baseURL: URL {
        return URL(string: "http://centrocristales.com")!
    }
    
    var permPath: String {
        return "/turnos-app-new/web/ws/v1"
    }
    
    var path: String {
        switch self {
        case .Link(let advertId):
            return "/bannerlink/\(advertId)"
        case .Image(let advertId):
            return "/bannerimage/\(advertId)"
        }
    }
    
    var request: NSMutableURLRequest {
        let url = URL(string: permPath + path, relativeTo: baseURL as URL)!
        let result = NSMutableURLRequest(url: url)
        return result
    }
}


class AdvertAPIClient : AdvertAPIClientProtocol {
    
    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    init(config: URLSessionConfiguration){
        self.configuration = config
    }
    
    convenience init(){
        self.init(config: URLSessionConfiguration.default)
    }

    
    func fetchBannerLink( for advertId: Int, completion: @escaping (APIResult<String>) -> Void) {
        let request = AdvertEndpoint.Link(advertId: advertId).request
        
        fetch(request: request as URLRequest, parse: { (json) -> String? in
            //Parse from JSON response to Car
            if let link = json["link"] as? String {
                return link
            }
            return nil
        }, completion: completion)
    }
    
    func fetchBannerImage( for advertId: Int) -> UIImage? {
        let request = AdvertEndpoint.Image(advertId: advertId).request
        let data = try? Data(contentsOf: request.url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        if data != nil {
            return UIImage(data: data!)
        }
        return nil
    }
}
