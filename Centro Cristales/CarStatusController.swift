
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func requestCarStatus(_ sender: AnyObject) {
        let workOrder = workOrderTextField.text
        let badge = badgeTextField.text
        if workOrder == "" || badge == "" {
            var message = "Faltan los siguientes datos:"
            if workOrder == "" {
                message += "\nNumero de orden "
            }
            if badge == "" {
                message += "\nDominio"
            }
            showAlert(message: message)
        }
    }

    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Faltan Datos", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
