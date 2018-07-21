//
//  AppDelegate.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON


// TODO:  PUT THESE IN THE CONFIG SHEET
var username : String = ""
var password : String = ""
var API : URL = URL(string: "http://127.0.0.1:8080/api/")!
var token : String =  ""
var refresh_token : String = ""


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let realm = try! Realm()
 //       if refresh_token == "" {
 //           doLogin() { access_token, reauth_token, error in
                // use tokens and error here
  //              if error! {
  //                  print ("error")
  //                  self.errmsg.text = "login unsuccessful"
  //                 self.errmsg.isHidden = false
  //              } else {
  //                  self.dismiss(animated: true)
  //                  self.delegate?.signin(loginViewController: self,accessToken: access_token!, refreshToken: reauth_token!)
  //              }
                
  //              return
  //          }
  //      } else {
  //          doReAuthorize() { access_token, reauth_token, error in
                // use tokens and error here
  //              if error! {
   //                 print ("error")
   //             } else {
  //                  self.dismiss(animated: true)
    //                self.delegate?.signin(loginViewController: self,accessToken: access_token!, refreshToken: reauth_token!)
   //             }
   //             return
   //         }
   //     }
        
        let splitViewController = window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

extension AppDelegate {
    
    func doLogin ( completionHandler: @escaping (String? ,String?, Bool?) -> ())  {
        
        let login_URL = "\(BASE_APP_URL)/api/login"
        let credentials: [String: Any] = ["username": username.lowercased(), "password": password]


        Alamofire.request(login_URL, method: .post, parameters: credentials, encoding: JSONEncoding.default).responseJSON  { response in
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
                token = accessToken
                refresh_token = refreshToken
                
                print ("AccessToken: \(accessToken)")
                print ("refreshToken: \(refreshToken)")
                print("logon successful")
                
                completionHandler(accessToken, refreshToken, false)
            case .failure(_ ):
                completionHandler(nil, nil, true)
            }
            
        }
        
    }
    
    func doReAuthorize (completionHandler: @escaping (String? ,String?, Bool?) -> ())  {
        let rest_auth = "\(BASE_APP_URL)/oauth/access_token"
        let params : [String: Any] = ["grant_type": "refresh_token", "refresh_token": refresh_token]
        Alamofire.request(rest_auth, method: .post, parameters: params).responseJSON  { response in
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
 
                completionHandler(accessToken, refreshToken, nil)
            case .failure(_ ):
                completionHandler(nil, nil, false)
            }
        }
    }
}

