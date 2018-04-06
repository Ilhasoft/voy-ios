//
//  VOYMockAddReportRepository.swift
//  Voy
//
//  Created by Pericles Jr on 07/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

//class VOYMockAddReportRepository: VOYAddReportDataSource {
//    var hasNetwork: Bool = false
//    
//    func setNetwork(hasNetwork: Bool) {
//        self.hasNetwork = hasNetwork
//    }
//    
//    func save(report: VOYReport, completion: @escaping (Error?, Int?) -> Void) {
//        if hasNetwork {
//            if let id = report.id, let dataList = report.cameraDataList {
//                VOYMockMediaFileRepository.shared.delete(mediaFiles: report.removedMedias)
//                VOYMockMediaFileRepository.shared.upload(reportID: id, cameraDataList: dataList, completion: { (_) in})
//                completion(nil, id)
//            }
//        } else {
//            completion(nil, nil)
//        }
//    }
//}
