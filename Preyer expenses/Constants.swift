//
//  Constants.swift
//  Networking
//
//  Created by Alaeddine Messaoudi on 26/11/2017.
//  Copyright © 2017 Alaeddine Me. All rights reserved.
//

import Foundation

var username : String = ""
var password : String = ""
var BASE_APP_URL : String = "http://127.0.0.1:8080"

//var API : URL = URL(string: "http://127.0.0.1:8080/api/")!
var token : String =  ""
var refresh_token : String = ""

//et APP_URL = "http://127.0.0.1:8080/api/trips"
//let trips_URL = "/api/trips"
//let partners_URL = "/api/partners"

let login_URL = "/api/login"
/*
struct K {
    struct ProductionServer {
        static let baseURL : String = "http://127.0.0.1:8080/api/"
    }
    struct AuthServer {
        static let baseURL : String = "http://127.0.0.1:8080/"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let username  = "username"
        static let token = "token"
    }
}
*/
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
