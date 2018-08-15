//
//  TravelCost.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class TravelCost: Object , Uploadable{
    @objc dynamic var id : Int = 0
    @objc dynamic var route: String = String()
    @objc dynamic var rentalCar : Bool = false
    @objc dynamic var train: Bool = false
    //    var passenger: Bool
    @objc dynamic var airplane : Bool = false
    //    var ship : Bool
    //    var kmDriversLog : Float
    @objc dynamic var kmTraveler : Int = 0
    //    var kmPassenger : Integer
    //    var indRefund : Float
    @objc dynamic var infoText : String = String()
    @objc dynamic var noPaying : Bool = false
    @objc dynamic var vehicle : Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/TravelCosts")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, route, rentalCar,train,airplane,kmTraveler,noPaying,vehicle = "vehicles"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(route, forKey: .route)
        try container.encode(rentalCar, forKey: .rentalCar)
        try container.encode(train, forKey: .train)
        try container.encode(airplane, forKey: .airplane)
        try container.encode(kmTraveler, forKey: .kmTraveler)
        try container.encode(noPaying, forKey: .noPaying)
        try container.encode(vehicle, forKey: .vehicle)
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _ = Refer()
        id = try container.decode(Int.self, forKey: .id)
        route = try container.decodeIfPresent(String.self, forKey: .route) ?? ""
        rentalCar = try container.decodeIfPresent(Bool.self, forKey: .rentalCar) ?? false
        train = try container.decodeIfPresent(Bool.self, forKey: .train) ?? false
        airplane = try container.decodeIfPresent(Bool.self, forKey: .airplane) ?? false
        kmTraveler = try container.decode(Int.self, forKey: .kmTraveler)
        noPaying = try container.decodeIfPresent(Bool.self, forKey: .noPaying) ?? false
        let vehicleObj = try container.decode(Refer.self, forKey: .vehicle)
        vehicle = vehicleObj.id
        
    }
    
    static func getList() {
        
        sessionManager.request(resourceURL).responseJSON { (response: DataResponse<Any>) in
            print("======== TravelCost.getList() ===========")
            print("Request: \(String(describing: response.request))")   // original url request
            
      //      print("Response: \(String(describing: response))") // http url response
            print("error: \(String(describing: response.error))")
        //    print("value: \(String(describing: response.value))")
            
            if response.error == nil {
                print("Result: \(String(describing: response.result))")  // response serialization result
                
                do {
                    let objList = try JSONDecoder().decode([TravelCost].self, from: response.data!)
      //              print ("TravelCosts: \(String(describing:objList))")
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(objList, update: true)
                    }
                    
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                
            }
            else  {
                print("error calling GET on \(resourceURL)")
                print(response.error!)
                
            }
        }
    }

}
