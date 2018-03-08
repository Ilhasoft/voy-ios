//
//  VOYCommentRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Alamofire

class VOYCommentRepository: VOYCommentDataSource {

    func save(comment: VOYComment, completion: @escaping (Error?) -> Void) {
        
        let authToken = VOYUser.activeUser()!.authToken!
        let url = VOYConstant.API.URL + "report-comments/"
        let headers = ["Authorization": "Token " + authToken, "Content-Type": "application/json"]
        
        Alamofire.request(url, method: .post, parameters: comment.toJSON(), headers: headers)
            .responseJSON { (dataResponse: DataResponse<Any>) in
            if dataResponse.result.value != nil {
                completion(nil)
            } else if let error = dataResponse.result.error {
                completion(error)
            }
        }
    }
}
