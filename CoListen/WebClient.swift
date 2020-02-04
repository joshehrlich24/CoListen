//
//  WebClient.swift
//  CoListen
//
//  Created by Josh Ehrlich on 2/19/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import Foundation

enum RequestMethod: String
{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension URL {
    init(baseUrl: String, path: String, params: JSON, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .get, .delete:
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        self = components.url!
    }
}

extension URLRequest {
    init(baseUrl: String, path: String, method: RequestMethod, params: JSON) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch method {
        case .post, .put:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        default:
            break
        }
    }
}

final class WebClient {
    private var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func load(path: String, method: RequestMethod, params: JSON, completion: @escaping (Any?, WebError?) -> ()) -> URLSessionDataTask?
    {
        
        //Check for internet connection
        if !Reachability.isConnectedToNetwork() {
            completion(nil, WebError.noInternetConnection)
            return nil
        }
        
         //Adding common parameters --> NEEDS TO BE FIXED
        var parameters = params

//        if let token = KeychainWrapper.itemForKey("application_token") {
//            parameters["token"] = token
//        }
        
        // Creating the URLRequest object
        let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: params)
        
        // Sending request to the server.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Parsing incoming data
            var object: Any? = nil
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: [])
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                completion(object, nil)
            } else {
                let error = (object as? JSON).flatMap(WebError.init) ?? WebError.other
                completion(nil, error)
            }
        }
        
        task.resume()
        
        return task
        
    }
}


