//
//  ViewController.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 17/10/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "requestCarStatus" {
            if let carStatusController = segue.destination as? CarStatusController {
                carStatusController.carService = CarService(workOrderAPIClient: WorkOrderAPIClient())
            }
        }
    }
}

