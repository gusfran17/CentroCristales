//
//  CarBudgetAPIClient.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 20/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import Foundation
import UIKit

enum CarBudgetEndpoint: Endpoint {
    case BudgetRequest
    
    var baseURL: URL {
        return URL(string: "http://centrocristales.com")!
    }
    
    var path: String {
        return "/turnos-app/web/ws/v1/sendpedidopresupuesto"
    }
    
    var request: NSMutableURLRequest {
        let url = URL(string: path, relativeTo: baseURL as URL)!
        let result = NSMutableURLRequest(url: url)
        return result
    }
}

class CarBudgetAPIClient : CarBudgetAPIClientProtocol {
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
    
    func submitBudgetingRequest(for email: String, message: String, image: UIImage?, completion: @escaping (APIResult<Bool>) -> Void){
        if image == nil {
            return
        }
        
        let boundary = generateBoundaryString()
        let request = CarBudgetEndpoint.BudgetRequest.request
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let param = [
            "lcs_webservice_pedidopresupuesto[email]"  : email,
            "lcs_webservice_pedidopresupuesto[mensaje]"    : message
        ]
        
        let image_data = UIImageJPEGRepresentation(image!, 1)
        
        if (image_data == nil) {
            return
        }
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "lcs_webservice_pedidopresupuesto[imagen]", imageDataKey: image_data!, boundary: boundary)
        fetch(request: request as URLRequest, parse: { (json) -> Bool? in
            //Parse from JSON response to Car
            if let jsonResult = json["status"] as? Int {
                if jsonResult == 0 {
                    return true
                } else {
                    return false
                }
            }
            return nil
            }, completion: completion)
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        let filename = "car_photo.jpg"
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageDataKey)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        return body as Data
    }
}
