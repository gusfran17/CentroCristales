
//
//  CarStatusController.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 09/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import UIKit

class CarStatusController: UIViewController {
    
    @IBOutlet weak var workOrderTextField: UITextField!
    @IBOutlet weak var badgeTextField: UITextField!
    @IBOutlet weak var carStatusResultLabel: UILabel!
    
    var carService: CarService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Faltan Datos", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
            showAlert(message: message)
        } else {
            carService?.getCarByBadgeAndWorkOrder(for: badge!, workOrder: workOrderId!){ result in
                switch result {
                case .Success(let car):
                    switch car.workOrder.status {
                    case .Finalized(_):
                        self.carStatusResultLabel.text = labelMessage + "TERMINADO"
                    case .InGarage(_):
                        self.carStatusResultLabel.text = labelMessage + "EN TALLER"
                    case .Passed(_):
                        self.carStatusResultLabel.text = labelMessage + "TERMINADO"
                    case .NotFound(_):
                        self.carStatusResultLabel.text = "Vehículo NO ENCONTRADO"
                    }
                case .Failure(let error):
                    print(error)
                    self.showAlert(message: "Ha habido un problema, por favor intente mas tarde.")
                }
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
