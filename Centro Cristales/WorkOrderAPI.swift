//
//  WorkOrderAPI.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 05/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation

//http://centrocristales.dynns.com:8094/WSCRMREST/WarnesWSRest.svc/getEstadoSiniestro/NCF297/188517

enum WorkOrderEndpoint: Endpoint {
    case Status(workOrder: String, badge: String )
    
    var baseURL: URL {
        return URL(string: "http://centrocristales.dynns.com:8094/WSCRMREST/WarnesWSRest.svc")!
    }
    
    var path: String {
        switch self {
        case .Status(let workOrder, let badge):
            return "/getEstadoSiniestro/\(badge)/\(workOrder)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL as URL)!
        return URLRequest(url: url)
    }
}


class WorkOrderAPIClient : APIClient {
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
    
    func fetchCurrentStatus(workOder: String, badge: String, completion: @escaping (APIResult<Car>) -> Void){
        
        let request = WorkOrderEndpoint.Status(workOrder: workOder, badge: badge).request
        
        fetch(request: request, parse: { (json) -> Car? in
            //Parse from JSON response to Car
            if let jsonResult = json["resultadoJson"] as? [[String: AnyObject]] {
                return Car(JSON: jsonResult, badge: badge)
            } else {
                return nil
            }
            
            }, completion: completion)
    }
}


