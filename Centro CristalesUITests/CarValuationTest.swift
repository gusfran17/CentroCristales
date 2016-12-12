//
//  CarValuationTest.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 11/12/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import XCTest

class CarValuationTest: XCTestCase {
        
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
    
    func testMesssageFieldRequired() {
        let app = XCUIApplication()
        app.buttons["COTIZACIÓN / PRESUPUESTO"].tap()
        app.buttons["ENVIAR PEDIDO"].tap()
        XCTAssert(app.alerts["Datos incorrectos"].exists)
    }
    
    func testEmailFieldRequired(){
        
        let app = XCUIApplication()
        app.buttons["COTIZACIÓN / PRESUPUESTO"].tap()
        
        let escribaAquiSuMensajeTextField = app.textFields["Escriba aqui su mensaje"]
        escribaAquiSuMensajeTextField.tap()

        escribaAquiSuMensajeTextField.typeText("test")
        app.buttons["ENVIAR PEDIDO"].tap()
        XCTAssert(app.alerts["Datos incorrectos"].exists)
    }
    
    func testEmailFormatIsIncorrect(){
        
        let app = XCUIApplication()
        app.buttons["COTIZACIÓN / PRESUPUESTO"].tap()
        
        let escribaAquiSuMensajeTextField = app.textFields["Escriba aqui su mensaje"]
        escribaAquiSuMensajeTextField.tap()
        escribaAquiSuMensajeTextField.typeText("test")
        
        let emailDeRespuestaTextField = app.textFields["Email de respuesta"]
        emailDeRespuestaTextField.tap()
        emailDeRespuestaTextField.typeText("test")
        app.buttons["ENVIAR PEDIDO"].tap()
        XCTAssert(app.alerts["Datos incorrectos"].exists)
        
    }
    
}
