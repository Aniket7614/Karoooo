//
//  ViewController.swift
//  KarooooSampleApp
//
//  Created by Halcyon Tek on 09/03/23.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import DropDown


class LoginViewController: UIViewController , UITextFieldDelegate{
    
    // MARK: - Variable declarations
    @IBOutlet weak var passwordTf: MDCOutlinedTextField?
    @IBOutlet weak var emailTf: MDCOutlinedTextField?
    @IBOutlet weak var countryTF: MDCOutlinedTextField? {
        didSet{
            countryTF?.delegate = self
            countryTF?.addTarget(self, action: #selector(dropdownchanges), for: .editingChanged)
        }}

    var dropDown = DropDown()
    
    
    // MARK: -View Life cycle methods
    /**
    * This method is to load the view
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        createDropdownWithCountryList()
    }
    
    
    // MARK: - Design Drop down for country list- Material design
    func createDropdownWithCountryList() {
        // The view to which the drop down will appear on
        dropDown.anchorView = countryTF // UIView or UIBarButtonItem
        dropDown.dataSource = ["Select Option"]
        //dropDown.dataSource.append(contentsOf: fundSourceModel.compactMap({$0.accountName}))
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.countryTF?.text = item
        }
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["India", "UK", "US", "Dubai", "South Africa", "Egypt", "Iraq"]
        dropDown.width = 200
     }
    
    // MARK: - When drop down changes
    @objc func dropdownchanges(){
        passwordTf?.resignFirstResponder()
    }
    
    // MARK: - Setting Up text field customization - Material design
    func setUpTextField(){
        emailTf?.label.text = "Username"
        emailTf?.placeholder = "XXXXXX"
        emailTf?.tintColor = UIColor.darkGray
        
        passwordTf?.label.text = "Password"
        passwordTf?.placeholder = "XXXXXX"
        passwordTf?.tintColor = UIColor.darkGray
        
        countryTF?.label.text = "Country"
        countryTF?.placeholder = "XXXXX"
        countryTF?.tintColor = UIColor.darkGray
        
        emailTf?.delegate = self
        passwordTf?.delegate = self
        countryTF?.delegate = self
    }
    
    
    // MARK: - Text fields delegates method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case emailTf:
            passwordTf?.becomeFirstResponder()
        case passwordTf:
            countryTF?.becomeFirstResponder()
        case countryTF:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == countryTF{
            self.view.endEditing(true)
            countryTF?.resignFirstResponder()
            dropDown.show()
        }}
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        return true;
    }
    
    @IBAction func btnRegisterClicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // MARK: - Login Button action
    @IBAction func btnLoginClicked(_ sender: Any) {
        if (emailTf?.text == ""){
            showAlert(withTitle: "Error", message: "Please enter username")
        }else if (passwordTf?.text == ""){
            showAlert(withTitle: "Error", message: "Please enter password")
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }}}


// MARK: - Extension for Alert messages
extension LoginViewController {
  func showAlert(withTitle title: String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        print("You've pressed OK Button")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
