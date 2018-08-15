//
//  AuthorisationHandler.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 09.08.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire





class AuthHandler: RequestAdapter, RequestRetrier {

    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
    
    private let lock = NSLock()
    
    private var username: String
    private var password: String
    private var baseURLString: String
    private var accessToken: String
    private var refreshToken: String
    var credentials: [String: Any] = [:]
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(username: String, password: String, baseURLString: String, accessToken: String, refreshToken: String) {
        self.username = username
        self.password = password
        self.baseURLString = baseURLString
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.credentials =  ["username": username.lowercased(), "password": password]
    }
    

    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
            var urlRequest = urlRequest
            urlRequest.setValue("Bearer " + self.accessToken, forHTTPHeaderField: "Authorization")
            //print("Bearer " + self.accessToken)
            return urlRequest
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                    refreshTokens { [weak self] succeeded, accessToken, refreshToken in
                        guard let strongSelf = self else { return }
                        
                        strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                        
                        if let accessToken = accessToken, let refreshToken = refreshToken {
                            strongSelf.accessToken = accessToken
                            strongSelf.refreshToken = refreshToken
                        }
                        
                        strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                        strongSelf.requestsToRetry.removeAll()
                    }
            }
           
        } else {
            completion(false, 0.0)
        }
    }
    
   
    
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        let urlString = "\(baseURLString)/oauth/access_token"
        
        let parameters: [String: Any] = [
            "access_token": accessToken,
            "refresh_token": refreshToken,
            "username": username,
            "grant_type": "refresh_token"
        ]
        
        sessionManager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                
                if
                    let json = response.result.value as? [String: Any],
                    let accessToken = json["access_token"] as? String,
                    let refreshToken = json["refresh_token"] as? String
                {
                    completion(true, accessToken, refreshToken)
                } else {
                    completion(false, nil, nil)
                }
                
                strongSelf.isRefreshing = false
        }
    }
    


}
