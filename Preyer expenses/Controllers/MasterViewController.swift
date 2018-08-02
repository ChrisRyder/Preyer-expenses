//
//  MasterViewController.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift


extension JSON {
    public var date: Date? {
        get {
            if let str = self.string {
                return JSON.jsonDateFormatter.date(from: str)
            }
            return nil
        }
    }
    
    private static let jsonDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter
    }()
}

/*
var countries = [Country]()
var partners = [Partner]()
var payors = [Partner]()
*/


let BASE_APP_URL = "http://127.0.0.1:8080"
let APP_URL = "http://127.0.0.1:8080/api/trips"
let trips_URL = "/api/trips"

let partners_URL = "/api/partners"

let login_URL = "/api/login"

class MasterViewController: UITableViewController    {  //, LoginViewControllerDelegate

    @IBOutlet var masterTableView: UITableView!
    
    let realm = try! Realm()
    
    var detailViewController: DetailViewController? = nil

    var trips  : Results<Trip>!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        loadTrips()
        
        //  masterTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
       
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
         tableView.reloadData()
        
  }
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
 
/*
        if refresh_token == "" {
            let loginController = LoginViewController()
            
            loginController.delegate = self
            
            self.present(loginController, animated: true, completion: nil)
        } else {
            doReAuthorize()
        }
 */
 }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                // let object = objects[indexPath.row] as! NSDate
                let trip = trips[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = trip //object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count //objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // let object = objects[indexPath.row] as! NSDate
        let trip = trips[indexPath.row]

        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        let fromDate : String = formatter.string(from: trip.beginning!)
        formatter.dateFormat = "MM.dd"
        let toDate : String = formatter.string(from: trip.ending!)
        var payorName : String = "No Payor"
     //   if let payorIndex = trip.payor {
     //       if (payorIndex > 0 && payors.count > 0) {
     //           let payor : Partner = payors.lazy.filter( {return $0.id == payorIndex }).first!
     //           payorName = payor.name
     //       } else {
     //           payorName = "0 Payor"
     //       }
      //  }
        
        cell.textLabel?.text! =  "\(fromDate) - \(toDate) :  \(payorName)"
        cell.detailTextLabel?.text! = trip.reason
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let trip = trips[indexPath.row]
            try! realm.write {
                realm.delete(trip)
            }
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            insertNewObject(self)
        }
    }

    // MARK:  Data Source
    
    func loadTrips() {
        trips = realm.objects(Trip.self)
        tableView.reloadData()
    }
    
    
    // MARK: Functions
    
    @objc
    func insertNewObject(_ sender: Any) {

    
        let realm = try! Realm()
        
        let trip = Trip()
        let nextId : Int = (trips.max(ofProperty: "id") ?? 0 ) + 1
     
        
        trip.id = nextId
        trip.beginning = Date()
        trip.ending = Date()
        trip.reason = "A test of REALM"
       
        try! realm.write {
            realm.add(trip)
        }
        
        tableView.reloadData()
    }
 
    func signin(loginViewController: LoginViewController, accessToken: String, refreshToken: String) {
        print ("login delegate called ")
        // do login
        
        token = accessToken
        refresh_token = refreshToken
        
        self.masterTableView.reloadData()
        // if ok dismiss login box
        // TODO else display warning ask again
    }
    
    func doLogin (username: String, password: String)  {
        let credentials: [String: Any] = ["username": username, "password": password]
        print(credentials)
        Alamofire.request(BASE_APP_URL+login_URL, method: .post, parameters: credentials, encoding: JSONEncoding.default).responseJSON  { response in
                      print("Request: \(String(describing: response.request))")   // original url request
                        print("Response: \(String(describing: response.response))") // http url response
                       print("Result: \(response.result)")                         // response serialization result
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling POST on /api/login")
                print(response.result.error!)
                return
            }
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value as? [String: Any] else {
                print("didn't get user object as JSON from API")
                if let error = response.result.error {
                    print("Error: \(error)")
                }
                return
            }
            // get and print the title
            guard let accessToken = json["access_token"] as? String else {
                print("Could not get access_token number from JSON")
                return
            }
            guard let refreshToken = json["refresh_token"] as? String else {
                print("Could not get refresh_token number from JSON")
                return
            }
            token = accessToken
            refresh_token = refreshToken

            print ("AccessToken: \(accessToken)")
            print ("refreshToken: \(refreshToken)")
            print("logon successful")
  /*
            if countries.count == 0 {
                self.getCountries()
            }
            if payors.count == 0 {
                self.getPayors()
            }
            if self.trips.count == 0 {
                self.getTrips()
            }
             */
        }
        
    }
    
    func doReAuthorize ()  {
        let rest_auth = "/oauth/access_token"
        let params : [String: Any] = ["grant_type": "refresh_token", "refresh_token": refresh_token]
        Alamofire.request(BASE_APP_URL+rest_auth, method: .post, parameters: params).responseJSON  { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling POST on \(rest_auth)")
                print(response.result.error!)
                return
            }
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value as? [String: Any] else {
                print("didn't get user object as JSON from API")
                if let error = response.result.error {
                    print("Error: \(error)")
                }
                return
            }
            // get and print the title
            guard let accessToken = json["access_token"] as? String else {
                print("Could not get access_token number from JSON")
                return
            }
            guard let refreshToken = json["refresh_token"] as? String else {
                print("Could not get refresh_token number from JSON")
                return
            }
            token = accessToken
            refresh_token = refreshToken
            
            print ("AccessToken: \(accessToken)")
            print ("refreshToken: \(refreshToken)")
            print("logon successful")
            /*
            if countries.count == 0 {
                self.getCountries()
            }
            if payors.count == 0 {
                self.getPayors()
            }
            if self.trips.count == 0 {
                self.getTrips()
            }
             */
        }
        
    }
    
  /*
    func getTrips() {

        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/X-Access-Token"
        ]
        Alamofire.request(APP_URL , headers: headers).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
            guard response.result.error == nil else {
                print("error calling GET on \(APP_URL)")
                print(response.result.error!)
                return
                
            }
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value else {
                print("trips: didn't get objects as JSON from API")
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
                    print("---------")
                    print("payor: \(subJson["payor"]["id"].int!)")
                    let trip : Trip = Trip(json: subJson)
                    self.trips.append(trip)//(trip, at: 0)
                    self.tableView.insertRows(at: [IndexPath(row: self.trips.count-1, section: 0)], with: .automatic)
  
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
    func getPartners(url: String) {

        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/X-Access-Token"
        ]
        Alamofire.request(url , headers: headers).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            guard response.result.error == nil else {
                print("error calling GET on \(url)")
                print(response.result.error!)
                return
                
            }
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value  else {
                print("pasrtners: didn't get object as JSON from API")
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
                    let partner : Partner = Partner(id: subJson["id"].int!, par: subJson["par"].string!, name: subJson["name"].string!,payor: subJson["payor"].bool!, client: subJson["client"].bool!, costCenter: subJson["costCenter"].bool!)
                    
                    partners.append(partner)
                    if partner.payor! {
                        payors.append(partner)
                    }
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
                let partner : Partner = Partner(id: subJson["id"].int!, par: subJson["par"].string!, name: subJson["name"].string!,payor: subJson["payor"].bool!, client: subJson["client"].bool!, costCenter: subJson["costCenter"].bool!)
                
                payors.append(partner)
                
            }
           
            
        }
        
    }
 */
    
}


