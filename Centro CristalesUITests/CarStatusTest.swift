//
//  CarStatusTest.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 11/12/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import XCTest

class CarStatusTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWorkOrderFieldIsRequired() {
        
        let app = XCUIApplication()
        app.buttons["ESTADO DE SU VEHÍCULO"].tap()
        
        let dominioTextField = app.textFields["Dominio"]
        dominioTextField.tap()
        dominioTextField.typeText("test")
        app.buttons["CONSULTAR ESTADO"].tap()
        XCTAssert(app.alerts["Faltan datos"].exists)
    }
    
    func testWorkOrderFieldIsNumberOnly() {
        
        let app = XCUIApplication()
        app.buttons["ESTADO DE SU VEHÍCULO"].tap()
        let ordenDeTrabajoTextField = app.textFields["Orden de Trabajo"]
        ordenDeTrabajoTextField.tap()
        ordenDeTrabajoTextField.typeText("test")
        app.buttons["CONSULTAR ESTADO"].tap()
        XCTAssert(app.alerts["Faltan datos"].exists)
    }
    
    func testBadgeIsRequired() {
        
        let app = XCUIApplication()
        app.buttons["ESTADO DE SU VEHÍCULO"].tap()
        
        let ordenDeTrabajoTextField = app.textFields["Orden de Trabajo"]
        ordenDeTrabajoTextField.tap()
        ordenDeTrabajoTextField.typeText("46271")
        app.buttons["CONSULTAR ESTADO"].tap()
        
        XCTAssert(app.alerts["Faltan datos"].exists)
    }
    
}
