//
//  AlamofireExtension.swift
//  Voy
//
//  Created by Daniel Amaral on 15/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//
import Alamofire

extension Alamofire.SessionManager{
    
    @discardableResult
    open func requestWithCacheOrLoad(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .returnCacheDataElseLoad
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}
