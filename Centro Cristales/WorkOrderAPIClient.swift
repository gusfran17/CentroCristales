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
    case Status(workOrder: Int, badge: String )
    
    var baseURL: URL {
        return URL(string: "http://centrocristales.dynns.com:8094")!
    }
    
    var path: String {
        switch self {
        case .Status(let workOrder, let badge):
            return "/WSCRMREST/WarnesWSRest.svc/getEstadoSiniestro/\(badge)/\(workOrder)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL as URL)!
        let result = URLRequest(url: url)
        return result
    }
}

class WorkOrderAPIClient : WorkOrderAPIClientProtocol {
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
    
    func fetchCurrentStatus(workOrder: Int, badge: String, completion: @escaping (APIResult<Car>) -> Void){
        let request = WorkOrderEndpoint.Status(workOrder: workOrder, badge: badge).request
        
        fetch(request: request, parse: { (json) -> Car? in
            //Parse from JSON response to Car
            if let jsonResult = json["resultadoJson"] as? String {
                if jsonResult != "" {
                    let data = (jsonResult.data(using: String.Encoding.utf8)! as Data) as Data
                    do {
                        if let anyObj = try JSONSerialization.jsonObject(with: data, options: []) as? [[String : AnyObject]] {
                            let car = Car(JSON: anyObj[0], badge: badge)
                            return car
                        }
                    } catch (let error){
                        print("Error: \(error)")
                        return nil
                    }
                //Parse from JSON error response to Car
                } else if let statusText = json["statusText"] as? String,
                      let status = json["status"] as? Int {
                            let workOrderObject = WorkOrder(id: workOrder, remarks: "Status: " + String(status), status: .NotFound(statusText))
                            let car = Car(badge: badge, workOrder: workOrderObject)
                            return car
                }
            }
            return nil
        }, completion: completion)
    }
}


