//
//  AdvertServiceTest.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 18/12/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import XCTest
import Foundation
@testable import Centro_Cristales

class AdvertServiceTest: XCTestCase {
    
    var advertService: AdvertService? = nil
    
    override func setUp() {
        super.setUp()
        let mockAdvertAPI = MockAdvertAPI()
        advertService = AdvertService(advertAPIClient: mockAdvertAPI)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGetBannerLink_One_Should_Return_Link_One() {
        let advertId = 1
        advertService?.getBannerLink(for: advertId) { result in
            switch result {
            case .Success(let link):
                XCTAssertEqual(link, "www.test1.com")
            default:
                XCTFail()
            }
   
        }
    }
    
    func testGetBannerLink_Two_Should_Return_Failure() {
        let advertId = 2
        advertService?.getBannerLink(for: advertId) { result in
            switch result {
            case .Failure(let error):
                XCTAssertNotNil(error, "No error was attached")
            default:
                XCTFail()
            }
        }
    }
    
    
    
    class MockAdvertAPI: AdvertAPIClientProtocol{
        
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
        
        func fetchBannerLink( for advertId: Int, completion: @escaping (APIResult<String>) -> Void){
            if advertId == 1 {
                completion(APIResult.Success("www.test1.com"))
            }
            if advertId == 2 {
                let error = NSError(domain: TRETestingErrorDomain, code: TestingError, userInfo: nil)
                completion(APIResult.Failure(error))
            }
        }
    }
    
}
