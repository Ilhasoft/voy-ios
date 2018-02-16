//
//  VOYAccountInteractor.swift
//  Voy
//
//  Created by Daniel Amaral on 16/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Alamofire

class VOYAccountInteractor: NSObject {
    
    static func updateUser(avatar:Int?, password:String?, completion:@escaping(Error?) -> Void) {
        
        let user = VOYUser.activeUser()!
        var jsonUser = user.toJSON()
        
        if let avatar = avatar {
            jsonUser["avatar"] = avatar
        }else {
            jsonUser["avatar"] = nil
        }
        if let password = password {
            jsonUser["password"] = password
        }
        
        let url = VOYConstant.API.URL + "users/" + "\(user.id!)/"
        let headers = ["Authorization" : "Token " + user.authToken, "Content-Type" : "application/json"]
        
        Alamofire.request(url, method: .put, parameters: jsonUser, encoding: JSONEncoding.default, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
            if let data = dataResponse.result.value {
                print(data)
                completion(nil)
            }else if let error = dataResponse.result.error {
                print(error.localizedDescription)
                completion(error)
            }
        }
    }
    
}
