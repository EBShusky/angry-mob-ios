//
//  Router.swift
//  AngryMob
//
//  Created by Wiktor Wielgus on 27.05.2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import Moya

let apiBaseURL = "http://192.168.43.40:8080"

enum Router {
    case image(imageData: Data, fileName: String)
}

extension Router: TargetType {
    
    var baseURL: URL {
        return URL(string: apiBaseURL)!
    }
    
    var path: String {
        switch self {
        case .image:
            return "/fileUpload"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .image:
            return .post
            //        default:
            //            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .image:
            return nil
            //        default:
            //            return nil
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    var httpHeaderFields: [String:String] {
        switch self {
        default:
            return Dictionary()
        }
    }
    

    
    var sampleData: Data {
        return "{\"result\": []}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .image(let imageData, let fileName):
            return .upload(.multipart([MultipartFormData(provider: .data(imageData),
                                                         name: "file",
                                                         fileName: fileName,
                                                         mimeType: "image/jpeg")]))
            
//        default:
//            return .request
        }
    }
}

public func url(route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

let endpointClosure = { (target: Router) -> Endpoint<Router> in
    let endpoint = Endpoint<Router>(url: url(route: target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
    let endpointWithTargetHeaders = endpoint.adding(newHTTPHeaderFields: target.httpHeaderFields)
    
    return endpointWithTargetHeaders.adding(newHTTPHeaderFields: ["Content-Type": "application/json"])
}

