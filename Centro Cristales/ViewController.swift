//
//  ViewController.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 17/10/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bannerImage: UIImageView!
    var bannerLink: String?
    var advertService: AdvertService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let advertAPIClient = AdvertAPIClient()
        advertService = AdvertService(advertAPIClient: advertAPIClient)
        setBanner()
    }
    
    func setBanner() {
        if let image = advertService?.getBannerImage(for: Adverts.Main.rawValue) {
            bannerImage.image = image
        }
        advertService?.getBannerLink(for: Adverts.Main.rawValue) { result in
            switch result {
            case .Success(let link):
                self.bannerLink = link
            case .Failure( _):
                self.bannerLink = nil
            }
        }
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapBannerDetected))
        singleTap.numberOfTapsRequired = 1
        bannerImage.isUserInteractionEnabled = true
        bannerImage.addGestureRecognizer(singleTap)
    }
    
    @objc func tapBannerDetected(){
        if let url = URL(string: bannerLink!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "requestCarStatus" {
            if let carStatusController = segue.destination as? CarStatusController {
                carStatusController.carService = CarService(workOrderAPIClient: WorkOrderAPIClient(), carBudgetAPIClient: nil)
            }
        } else if segue.identifier == "requestCarBudgeting" {
            if let carBudgetController = segue.destination as? CarBudgetController {
                carBudgetController.carService = CarService(workOrderAPIClient: nil, carBudgetAPIClient: CarBudgetAPIClient())
            }
        }

    }
    
}

