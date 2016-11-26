//
//  CarBudgetController.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 09/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import UIKit

class CarBudgetController: UIViewController {

    var photoUploaded: Bool = false
    var carService: CarService?
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var carImageView: UIImageView!
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CarBudgetController.tapDetected))
        singleTap.numberOfTapsRequired = 1
        carImageView.isUserInteractionEnabled = true
        carImageView.addGestureRecognizer(singleTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func tapDetected(){
        let newImageView = UIImageView(image: carImageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(CarBudgetController.dismissFullScreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    @objc func dismissFullScreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    @IBAction func getPictureFromLibrary(_ sender: AnyObject) {
        mediaPickerManager.presentImagePickerController(animated: true, imageType: .photoLibrary)
    }
    
    @IBAction func getPictureFromCamera(_ sender: AnyObject) {
        mediaPickerManager.presentImagePickerController(animated: true, imageType: .camera)
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Datos Incorrectos", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func submitCarBudgetingRequest(_ sender: AnyObject) {
        let messageToSend = messageTextField.text
        let email = emailTextField.text
        if email == "" ||
           messageToSend == "" ||
           !isValidEmail(testStr: email!) ||
           !photoUploaded {
            
            var message = "Faltan los siguientes datos:"
            if messageToSend == "" {
                message += "\nMensaje"
            }
            if email == "" {
                message += "\nEmail"
            } else if !isValidEmail(testStr: email!) {
                message = "El email es incorrecto"
            }
            if !photoUploaded {
                message = "Debe cargar una foto del auto a presupuestar"
            }
            showAlert(message: message)
        } else {
            self.carService?.submitCarBudgetingRequest(for: email!, message: messageToSend!, image: carImageView.image!, completion: { result in
                switch result {
                case .Success(_):
                    self.showAlert(message: "Los datos fueron enviados exitosamente")
                case .Failure(let error):
                    print(error)
                    self.showAlert(message: "Hubo un error al enviar los datos. Por favor intente de nuevo, y si persiste comuniquese con el administrador")
                }
                
            })
        }
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}

extension CarBudgetController: MediaPickerManagerDelegate {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        carImageView.image = image
        photoUploaded = true
    }
}
