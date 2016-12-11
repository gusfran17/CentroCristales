
//
//  CarStatusController.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 09/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import UIKit

class CarStatusController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var workOrderTextField: UITextField!
    @IBOutlet weak var badgeTextField: UITextField!
    @IBOutlet weak var carStatusResultLabel: UILabel!
    @IBOutlet weak var topVerticalSpacingConstraint: NSLayoutConstraint!
    
    var carService: CarService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(CarStatusController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CarStatusController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CarBudgetController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

    private func showLoadingActivity(){
        let alert = UIAlertController(title: nil, message: "Espere mientras se envian los datos...", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator = UIActivityIndicatorView(frame: alert.view.bounds)
        loadingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //Add the activity indicator to the alert's view
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    private func dismissLoadingActivity(message: String){
        dismiss(animated: false) { self.showAlert(title: "Resultado", message: message)}
    }
    
    @IBAction func requestCarStatus(_ sender: AnyObject) {
        let workOrder = workOrderTextField.text
        let workOrderId = Int(workOrder!)
        let badge = badgeTextField.text
        let labelMessage = "Su vehículo se encuentra "
        if nil == workOrderId || workOrder == "" || badge == "" {
            var message = "Faltan los siguientes datos:"
            if badge == "" {
                message += "\nDominio"
            }
            if workOrder == "" {
                message += "\nOrden de Trabajo"
            } else if nil == Int(workOrder!) {
                message = "La Orden de Trabajo solo debe contener números."
            }
            showAlert(title: "Faltan datos", message: message)
        } else {
            showLoadingActivity()
            carService?.getCarByBadgeAndWorkOrder(for: badge!.uppercased(), workOrder: workOrderId!){ result in
                switch result {
                case .Success(let car):
                    guard let workOrder = car.workOrder,
                          let status = workOrder.status else {
                        self.dismissLoadingActivity(message: "Ha habido un problema, por favor intente mas tarde.")
                        return
                    }
                    
                    switch status {
                    case .Finalized(_):
                        self.dismissLoadingActivity(message: labelMessage + "TERMINADO")
                    case .InGarage(_):
                        self.dismissLoadingActivity(message: labelMessage + "TERMINADO")
                    case .Passed(_):
                        self.dismissLoadingActivity(message: labelMessage + "TERMINADO")
                    case .NotFound(_):
                        self.dismissLoadingActivity(message: labelMessage + "TERMINADO")
                    }
                case .Failure(let error):
                    print(error)
                    self.showAlert(title: "Resultado", message: "Ha habido un problema, por favor intente mas tarde.")
                }
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.8){
            self.topVerticalSpacingConstraint.constant = -100
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.8){
            self.topVerticalSpacingConstraint.constant = -150
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
