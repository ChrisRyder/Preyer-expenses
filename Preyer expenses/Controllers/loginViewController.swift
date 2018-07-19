//
//  loginViewController.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 16.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


public protocol LoginViewControllerDelegate: class {
    /**
     Delegate method to call when signin is clicked
     */
    func signin(loginViewController: LoginViewController,accessToken : String, refreshToken : String)
    
}

/**
 Extension to allow us to dismiss the keyboard when clicked somewhere else on the screen except the
 text fields
 */
extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
}

open class LoginViewController: UIViewController, UITextFieldDelegate {
    
    public weak var delegate: LoginViewControllerDelegate?
    public var errmsg: UILabel!
    public var username: UITextField!
    public var password: UITextField!
    public var backgroundImage: UIImageView!
    var signinButton: UIButton!
    var errText: UITextView!
    var signinBackground : UIColor = UIColor.blue.withAlphaComponent(0.5)
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    
    override open func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        // set up activity indicator
        activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        self.view.addSubview(activityIndicator)
        // Do any additional setup after loading the view.
        setupView()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    public var signinColor: UIColor = UIColor.white {
        didSet {
            self.signinBackground = signinColor;
        }
    }
    
    /**
     add the logo for your company/product on the login screen
     */
    public func setupView() {
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Boat")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
       
        errmsg = UILabel(frame: CGRect(x: 40, y: self.view.frame.height - 265, width: self.view.frame.width - 80, height: 48))
        //errmsg.font = UIFont.boldSystemFont(ofSize: 10)
        errmsg.textColor = .white
        errmsg.textAlignment = .center
        errmsg.text = "error test message"
        errmsg.backgroundColor = .red
        errmsg.isHidden = true
        self.view.addSubview(errmsg)
        
        username = UITextField(frame: CGRect(x: 40, y: self.view.frame.height - 96 - 48 - 5, width: self.view.frame.width - 80, height: 48))
        username.borderStyle = .roundedRect
        username.placeholder = "Username"
        username.spellCheckingType = .no
        username.becomeFirstResponder()
        username.returnKeyType = .next
        username.delegate = self
        self.view.addSubview(username)
        
        password = UITextField(frame: CGRect(x: 40, y: self.view.frame.height - 96 , width: self.view.frame.width - 80, height: 48))
        password.isSecureTextEntry = true
        password.placeholder = "Password"
        password.borderStyle = .roundedRect
        password.spellCheckingType = .no
        password.delegate = self
        password.returnKeyType = .done
        self.view.addSubview(password)
        
   
        signinButton = UIButton(type: .system)
        signinButton.frame = CGRect(x: 0, y: self.view.frame.height - 64, width: self.view.frame.width, height: 64)
        signinButton.setTitle("Sign In", for: .normal)
        signinButton.setTitleColor(.white, for: .normal)
        signinButton.backgroundColor = signinBackground
        signinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        signinButton.layer.cornerRadius = 0
        signinButton.layer.masksToBounds = true
        signinButton.addTarget(self, action: #selector(signin_clicked), for: .touchUpInside)
        self.view.addSubview(signinButton)
        
    }
    
    @objc func rotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            
            self.signinButton.frame.origin.y = self.view.frame.height - self.signinButton.frame.height
            self.signinButton.frame.size =  CGSize(width: self.view.frame.width, height: self.signinButton.frame.height)
            self.username.frame.origin.y = self.view.frame.height - self.signinButton.frame.height - 96 - 48 - 5
            self.username.frame.size = CGSize(width:  self.view.frame.width - 80, height: self.username.frame.height)
            self.password.frame.origin.y = self.view.frame.height - self.signinButton.frame.height - 96
            self.password.frame.size = CGSize(width:  self.view.frame.width - 80, height: self.password.frame.height)
            self.errmsg.frame.origin.y = self.view.frame.height - self.signinButton.frame.height - 265
            self.errmsg.frame.size = CGSize(width:  self.view.frame.width - 80, height: self.errmsg.frame.height)
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            self.signinButton.frame.origin.y = self.view.frame.height - self.signinButton.frame.height
            self.signinButton.frame.size =  CGSize(width: self.view.frame.width, height: self.signinButton.frame.height)
            self.username.frame.origin.y = self.view.frame.height - self.signinButton.frame.height - 96 - 48 - 5
            self.username.frame.size = CGSize(width:  self.view.frame.width - 80, height: self.username.frame.height)
            self.password.frame.origin.y = self.view.frame.height - self.signinButton.frame.height - 96
            self.password.frame.size = CGSize(width:  self.view.frame.width - 80, height: self.password.frame.height)
            self.errmsg.frame.origin.y = self.view.frame.height - self.signinButton.frame.height - 265
            self.errmsg.frame.size = CGSize(width:  self.view.frame.width - 80, height: self.errmsg.frame.height)
        }
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        print("duration: \(duration)")
        print("curve: \(curve)")
        print("curFrame: \(curFrame)")
        print("targetFrame: \(targetFrame)")
        print("deltaY: \(deltaY)")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
             print ("keyboardWillShow: Keyboard =\(keyboardSize)")

            self.signinButton.frame.origin.y = self.view.frame.height - keyboardSize.height - self.signinButton.frame.height
            self.signinButton.frame.size =  CGSize(width: self.view.frame.width, height: self.signinButton.frame.height)
            self.username.frame.origin.y = self.view.frame.height - keyboardSize.height - self.signinButton.frame.height - 96 - 48 - 5
            self.username.frame.size = CGSize(width:  self.view.frame.width - 80, height: self.username.frame.height)
            self.password.frame.origin.y = self.view.frame.height - keyboardSize.height - self.signinButton.frame.height - 96
            self.password.frame.size = CGSize(width:  self.view.frame.width - 80, height: self.password.frame.height)
            self.errmsg.frame.origin.y = self.view.frame.height - self.signinButton.frame.height - keyboardSize.height - 265
            self.errmsg.frame.size = CGSize(width:  self.view.frame.width - 80, height: self.errmsg.frame.height)

        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        print("duration: \(duration)")
        print("curve: \(curve)")
        print("curFrame: \(curFrame)")
        print("targetFrame: \(targetFrame)")
        print("deltaY: \(deltaY)")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print ("keyboardWillHide: Keyboard =\(keyboardSize)")

            self.signinButton.frame.origin.y = self.view.frame.height - self.signinButton.frame.height
            self.signinButton.frame.size =  CGSize(width: self.view.frame.width, height: self.signinButton.frame.height)
            self.username.frame.origin.y = self.view.frame.height - self.signinButton.frame.height - 96 - 48 - 5
            self.username.frame.size = CGSize(width: self.view.frame.width - 80, height: self.username.frame.height)
            self.password.frame.origin.y = self.view.frame.height - self.signinButton.frame.height - 96
            self.password.frame.size = CGSize(width: self.view.frame.width - 80, height: self.password.frame.height)
            self.errmsg.frame.origin.y = self.view.frame.height - self.signinButton.frame.height - 265
            self.errmsg.frame.size = CGSize(width:  self.view.frame.width - 80, height: self.errmsg.frame.height)

            
        }
    }
    /**
     call the delegate method when the signin button is clicked
     */
    @objc fileprivate func signin_clicked() {
        if refresh_token == "" {
            doLogin(username: username.text!.lowercased(), password: password.text!) { access_token, reauth_token, error in
                // use tokens and error here
                if error! {
                    print ("error")
                    self.errmsg.text = "login unsuccessful"
                    self.errmsg.isHidden = false
                } else {
                    self.dismiss(animated: true)
                    self.delegate?.signin(loginViewController: self,accessToken: access_token!, refreshToken: reauth_token!)
                }
        
                return
            }
        } else {
            doReAuthorize() { access_token, reauth_token, error in
                // use tokens and error here
                if error! {
                    print ("error")
                } else {
                    self.dismiss(animated: true)
                    self.delegate?.signin(loginViewController: self,accessToken: access_token!, refreshToken: reauth_token!)
                }
                return
            }
        }
    }
    
    /**
     Define the behavior when the return button is clicked when on username field or password field
     */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username {
            password.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
            signin_clicked()
        }
        return false
    }
    
    func doLogin (username: String, password: String, completionHandler: @escaping (String? ,String?, Bool?) -> ())  {
        
        let login_URL = "/api/login"
        let credentials: [String: Any] = ["username": username, "password": password]
        print(credentials)
        activityIndicator.startAnimating()
        Alamofire.request(BASE_APP_URL+login_URL, method: .post, parameters: credentials, encoding: JSONEncoding.default).responseJSON  { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            self.activityIndicator.stopAnimating()
            switch response.result {
            case .success(let value):
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /api/login")
                    print(response.result.error!)
                     completionHandler(nil, nil, true)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = value as? [String: Any] else {
                    print("didn't get user object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                     completionHandler(nil, nil, true)
                    return
                }
                // get and print the title
                guard let accessToken = json["access_token"] as? String else {
                    print("Could not get access_token number from JSON")
                     completionHandler(nil, nil, true)
                    return
                }
                guard let refreshToken = json["refresh_token"] as? String else {
                    print("Could not get refresh_token number from JSON")
                    completionHandler(nil, nil, true)
                    return
                }
                token = accessToken
                refresh_token = refreshToken
                
                print ("AccessToken: \(accessToken)")
                print ("refreshToken: \(refreshToken)")
                print("logon successful")
                self.activityIndicator.startAnimating()
                self.getCountries()
                self.getPayors()
                self.activityIndicator.stopAnimating()
                completionHandler(accessToken, refreshToken, false)
            case .failure(_ ):
                completionHandler(nil, nil, true)
            }

        }
        
    }
    
    func doReAuthorize (completionHandler: @escaping (String? ,String?, Bool?) -> ())  {
        let rest_auth = "/oauth/access_token"
        let params : [String: Any] = ["grant_type": "refresh_token", "refresh_token": refresh_token]
        Alamofire.request(BASE_APP_URL+rest_auth, method: .post, parameters: params).responseJSON  { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            switch response.result {
            case .success(let value):
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /api/login")
                    print(response.result.error!)
                    completionHandler(nil, nil, true)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = value as? [String: Any] else {
                    print("didn't get user object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    completionHandler(nil, nil, true)
                    return
                }
                // get and print the title
                guard let accessToken = json["access_token"] as? String else {
                    print("Could not get access_token number from JSON")
                    completionHandler(nil, nil, true)
                    return
                }
                guard let refreshToken = json["refresh_token"] as? String else {
                    print("Could not get refresh_token number from JSON")
                    completionHandler(nil, nil, true)
                    return
                }
                
                print ("AccessToken: \(accessToken)")
                print ("refreshToken: \(refreshToken)")
                print("logon successful")
                if countries.count == 0 { self.getCountries() }
                if payors.count == 0 { self.getPayors() }
                
                completionHandler(accessToken, refreshToken, nil)
            case .failure(_ ):
                completionHandler(nil, nil, false)
            }
        }
    }
    

    func getCountries() {
        let countries_URL = "/api/countries"
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/X-Access-Token"
        ]
        Alamofire.request(BASE_APP_URL+countries_URL , headers: headers).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            print("Result: \(String(describing: response.result.value))")                         // response serialization result
            guard response.result.error == nil else {
                print("error calling GET on \(countries_URL)")
                print(response.result.error!)
                return
                
            }
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value else {
                print("countries: didn't get object as JSON from API")
                if let error = response.result.error {
                    print("Error: \(error)")
                }
                return
            }
            print("JSON: \(json)") // serialized json response
            let jsonError=JSON(json)["error"]
            print("\(jsonError)")
            if jsonError == "Unauthorized" || jsonError == "500" {
                print("JSON: \(json)") // serialized json response
                return
            }
            
            
            
            for (_,subJson):(String, JSON) in JSON(json) {
                let country = Country(json: subJson)
                countries.append(country)
            }
        }
    }
        
    func getPayors() {
        let payors_URL = "/api/partners/findAllByPayor"
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/X-Access-Token"
        ]
        print (headers)
        Alamofire.request(BASE_APP_URL+payors_URL , headers: headers).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            guard response.result.error == nil else {
                print("error calling GET on \(payors_URL)")
                print(response.result.error!)
                return
                
            }
            guard let json = response.result.value else {
                print("Payors: didn't get object as JSON from API")
                if let error = response.result.error {
                    print("Error: \(error)")
                }
                return
            }
            print("JSON: \(json)") // serialized json response
            let jsonError=JSON(json)["error"]
            print("\(jsonError)")
            if jsonError == "Unauthorized" || jsonError == "500" {
                print("JSON: \(json)") // serialized json response
                return
            }
            
            for (_,subJson):(String, JSON) in JSON(json) {
                let client = subJson["client"].null == NSNull()  ? false : subJson["client"].bool!
                let costCenter = subJson["costCenter"].null == NSNull()  ? false : subJson["costCenter"].bool!
                    
                
                
                
                let partner : Partner = Partner(id: subJson["id"].int!,
                                                par: subJson["par"].string!,
                                                name: subJson["name"].string!,
                                                payor: subJson["payor"].bool!,
                                                client: client,
                                                costCenter: costCenter
                    )
                
                payors.append(partner)
                
            }
        }
    }
}

