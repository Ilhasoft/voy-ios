//
//  VOYThemeListRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class VOYThemeListRepository: VOYThemeListDataSource {
    
    let reachability: VOYReachability
    
    init(reachability: VOYReachability) {
        self.reachability = reachability
    }
    
    func cacheDataFrom(url: String, parameters: inout [String : Any]) {
        if reachability.hasNetwork() {
            var headers = [String:String]()
            headers["Cache-Control"] = "public, max-age=86400, max-stale=120"
            parameters["page"] = 1
            parameters["page_size"] = VOYConstant.API.PAGINATION_SIZE
            Alamofire.request(url, method:.get, parameters: parameters, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
                if dataResponse.result.error == nil {
                    let cachedURLResponse = CachedURLResponse(response: dataResponse.response!, data: dataResponse.data! , userInfo: nil, storagePolicy: .allowed)
                    URLCache.shared.storeCachedResponse(cachedURLResponse, for: dataResponse.request!)
                }
                
            }
            
        }else {
            print("User haven't internet connection and don't have cached data")
        }
    }
    
    func getMyProjects(completion:@escaping(_ projects:[VOYProject], _ error: Error?) -> Void) {
        
        var headers = [String:String]()
        if !reachability.hasNetwork() {
            headers["Cache-Control"] = "public, only-if-cached, max-stale=86400"
        }else {
            headers["Cache-Control"] = "public, max-age=86400, max-stale=120"
        }
        
        let request = Alamofire.request(VOYConstant.API.URL + "projects", parameters: ["auth_token":VOYUser.activeUser()!.authToken], headers: headers)
        
        let cachedResponse = URLCache.shared.cachedResponse(for: request.request!)
        
        if reachability.hasNetwork() {
            
            request.responseArray { (dataResponse:DataResponse<[VOYProject]>) in
                
                if dataResponse.result.error == nil {
                    let cachedURLResponse = CachedURLResponse(response: dataResponse.response!, data: dataResponse.data! , userInfo: nil, storagePolicy: .allowed)
                    URLCache.shared.storeCachedResponse(cachedURLResponse, for: dataResponse.request!)
                }
                
                if let projects = dataResponse.result.value {
                    completion(projects, nil)
                }else if let error = dataResponse.result.error {
                    completion([], error)
                }
            }
            
        } else if let cachedResponse = cachedResponse {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: cachedResponse.data, options: [])
                if let arrayDictionary = jsonObject as? [[String:Any]] {
                    var projects = [VOYProject]()
                    for dictionary in arrayDictionary {
                        let project = VOYProject(JSON: dictionary)!
                        projects.append(project)
                    }
                    completion(projects,nil)
                }
            } catch {
                print(error.localizedDescription)
                completion([],error)
            }
        }
    }
}
