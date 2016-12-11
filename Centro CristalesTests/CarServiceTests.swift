//
//  Centro_CristalesTests.swift
//  Centro CristalesTests
//
//  Created by Gustavo Franco on 17/10/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//
import Foundation
import XCTest
@testable import Centro_Cristales
public let TRETestingErrorDomain = "com.treehouse.CentroCristales.TestingError"
public let TestingError: Int = 1000

class CarServiceTests: XCTestCase {
    
    var carService: CarService? = nil
    
    override func setUp() {
        super.setUp()
        let mockAPIClient = MockWorkOrderAPI()
        carService = CarService(workOrderAPIClient: mockAPIClient, carBudgetAPIClient: nil)
        
    }
    
    override func tearDown() {
        super.tearDown()
        carService = nil
    }
    
    func testGetCarByBadgeAndWorkOrder_Should_Return_Car() {
        let badge = "HNZ114"
        let workOrderId = 12345
        carService?.getCarByBadgeAndWorkOrder(for: badge, workOrder: workOrderId) { result in
            switch result {
            case .Success(let car):
                XCTAssertEqual(car.badge, badge)
                XCTAssertEqual(car.workOrder?.id, workOrderId)
            default:
                XCTFail()
            }
        }
    }
    
    func testGetCarByBadgeAndWorkOrder_Should_Return_CarStatusPassed() {
        let badge = "HNZ114"
        let workOrderId = 12345
        carService?.getCarByBadgeAndWorkOrder(for: badge, workOrder: workOrderId) { result in
            switch result {
            case .Success(let car):
                guard let workOrder = car.workOrder,
                      let status = workOrder.status
                    else {
                        XCTFail("Car has no work order in it")
                        return
                }
                switch status {
                case .Passed(let message):
                    XCTAssertEqual(message, "PASADO")
                default:
                    XCTFail()
                }
            default:
                XCTFail()
            }
        }
    }
    
    func testGetCarByBadgeAndWorkOrder_Should_Return_Failure() {
        let badge = "AAAAAA"
        let workOrderId = 12345
        carService?.getCarByBadgeAndWorkOrder(for: badge, workOrder: workOrderId) { result in
            switch result {
            case .Failure(let error):
                XCTAssertNotNil(error, "No error was attached")
            default:
                XCTFail()
            }
        }
    }
    
    
    
    class MockWorkOrderAPI: WorkOrderAPIClientProtocol{
        
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

        
        func fetchCurrentStatus(badge: String, workOrder: Int, completion: @escaping (APIResult<Car>) -> Void) {
            if badge == "AAAAAA" {
                let error = NSError(domain: TRETestingErrorDomain, code: TestingError, userInfo: nil)
                completion(APIResult.Failure(error))
            } else {
                let workOrderEntity = WorkOrder(id: workOrder,
                                                remarks: "PASADO",
                                                status: Status(rawValue: "PAS", remark: "PASADO"))
                let car = Car(badge: badge, workOrder: workOrderEntity)
                completion(APIResult.Success(car))
            }
        }
    }
    
    class MockCarBudgetAPI : CarBudgetAPIClientProtocol {
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
        
        func submitBudgetingRequest(for email: String, message: String, image: UIImage?,completion: @escaping (APIResult<Bool>) -> Void) {
            completion(APIResult.Success(true))
        }
        
    }
    
}
