//
//  DomainTests.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 13/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import XCTest
@testable import Centro_Cristales

class CarTests: XCTestCase {
    
    var jsonResult: String = "{\n" +
        "\"nroOT\":188972,\n" +
        "\"id_presupuesto\":188972,\n" +
        "\"version\":0,\n" +
        "\"observaciones\":\"1567936922 V.W. GOLF VII 1.6 TRENDLINE IMP 2016 PHS554 BBB 05 11 9:00 PAOLA\",\n" +
        "\"descripcionEstado\":\"PASADO\",\n" +
        "\"id_estado\":\"PAS\",\n" +
    "}"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCar_Should_Be_Created_From_JSON() {
        let data = (jsonResult.data(using: String.Encoding.utf8)! as Data) as Data
        do {
            if var anyObj = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] {
                anyObj["dominio"] = "HNZ114" as AnyObject?
                let car = Car(JSON: anyObj)
                XCTAssertEqual(car?.badge, "HNZ114")
                XCTAssertEqual(car?.workOrder?.id, 188972)
            }
        } catch (let error){
            print(error)
            XCTFail()
        }
    }
    
    func testCar_Should_Be_Created_From_JSON_With_Status_Passed() {
        let data = (jsonResult.data(using: String.Encoding.utf8)! as Data) as Data
        do {
            if var anyObj = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] {
                anyObj["dominio"] = "HNZ114" as AnyObject?
                if let car = Car(JSON: anyObj) {
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
                } else {
                    XCTFail()
                }
            }
        } catch (let error){
            print(error)
            XCTFail()
        }
    }
}
