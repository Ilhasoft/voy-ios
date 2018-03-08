//
//  VOYMockMediaFileRepository.swift
//  Voy
//
//  Created by Pericles Jr on 07/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
@testable import Voy

class VOYMockMediaFileRepository: VOYMediaFileDataSource {
    var removedFile: Bool = false
    var uploadedFile: Bool = false
    static let shared = VOYMockMediaFileRepository()
    
    func delete(mediaFiles: [VOYMedia]?) {
        removedFile = true
    }
    
    func upload(reportID: Int, cameraDataList: [VOYCameraData], completion: @escaping (Error?) -> Void) {
        uploadedFile = true
        completion(nil)
    }
    

}
