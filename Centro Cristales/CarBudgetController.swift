//
//  CarBudgetController.swift
//  Centro Cristales
//
//  Created by Gustavo Franco on 09/11/2016.
//  Copyright © 2016 Gustavo Franco. All rights reserved.
//

import UIKit

class CarBudgetController: UIViewController, UITextFieldDelegate {

    var photoUploaded: Bool = false
    var carService: CarService?
    @IBOutlet weak var topVerticalSpacingConstraint: NSLayoutConstraint!

    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var carImageView: UIImageView!
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageTextField.layer.borderWidth = 0.5
        self.messageTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.messageTextField.layer.cornerRadius = 6
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CarBudgetController.tapDetected))
        singleTap.numberOfTapsRequired = 1
        carImageView.isUserInteractionEnabled = true
        carImageView.addGestureRecognizer(singleTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CarBudgetController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CarBudgetController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message:
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
                message = "Debe cargar una foto del vehículo a presupuestar"
            }
            showAlert(title:"Datos incorrectos", message: message)
        } else {
            let alertController = UIAlertController(title: "Atención", message:
                "Esta a punto de enviar la foto de su vehículo con su respectiva descripción. Una vez recibidos estos datos se le enviará un mail con la cotizacion a \(email!)", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: {(alert: UIAlertAction!) in self.sendValuationRequest(to: email!, messageToSend: messageToSend!)}))
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        if image.size.width > newWidth {
            let scale = newWidth / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        return image
    }
    
    private func sendValuationRequest(to email: String, messageToSend: String){
        showLoadingActivity()
        let resizeImage = self.resizeImage(image: carImageView.image!, newWidth: 1200)
        self.carService?.submitCarBudgetingRequest(for: email, message: messageToSend, image: resizeImage, completion: { result in
            switch result {
            case .Success(_):
                self.dismissLoadingActivity()
                self.showAlert(title:"", message: "Los datos fueron enviados exitosamente")
            case .Failure(let error):
                print(error)
                self.dismissLoadingActivity()
                self.showAlert(title:"Error", message: "Hubo un error al enviar los datos. Por favor intente de nuevo, y si persiste comuniquese con el administrador")
            }
            
        })
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
    
    private func dismissLoadingActivity(){
        dismiss(animated: false, completion: nil)
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfoDict = notification.userInfo,
           let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardFrame = keyboardFrameValue.cgRectValue
            UIView.animate(withDuration: 0.8){
                self.topVerticalSpacingConstraint.constant = keyboardFrame.size.height - 70
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.8){
            self.topVerticalSpacingConstraint.constant = -50
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CarBudgetController: MediaPickerManagerDelegate {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        carImageView.contentMode = .scaleAspectFit
        carImageView.backgroundColor = .black
        carImageView.image = image
        photoUploaded = true
    }
}
