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
    
    func testExample() {
        
        let app = XCUIApplication()
        app.buttons["COTIZACIÓN / PRESUPUESTO"].tap()
        app.buttons["Escoger Imagen"].tap()
        app.alerts["“Centro Cristales” Would Like to Access Your Photos"].buttons["OK"].tap()
        app.collectionViews["PhotosGridView"].cells["Photo, Landscape, August 08, 2012, 7:52 PM"].tap()
        
        let escribaAquiSuMensajeTextField = app.textFields["Escriba aqui su mensaje"]
        escribaAquiSuMensajeTextField.tap()
        escribaAquiSuMensajeTextField.typeText("tes")
        
        let emailDeRespuestaTextField = app.textFields["Email de respuesta"]
        emailDeRespuestaTextField.typeText("t")
        app.otherElements.containing(.navigationBar, identifier:"Centro_Cristales.CarBudget").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element(boundBy: 1).tap()
        emailDeRespuestaTextField.tap()
        emailDeRespuestaTextField.typeText("test")
        emailDeRespuestaTextField.typeText("@")
        emailDeRespuestaTextField.typeText("test.")
        app.typeText("com")
        app.otherElements.containing(.alert, identifier:"Atención").element.tap()
        app.alerts.buttons["OK"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
