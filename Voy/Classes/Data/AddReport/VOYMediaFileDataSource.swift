//
//  VOYMediaFileDataSource.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYMediaFileDataSource {
    var isUploading: Bool { get }
    func delete(mediaFiles: [VOYMedia]?)
    func upload(reportID: Int, cameraData: VOYCameraData, completion:@escaping(Error?) -> Void)
    func upload(reportID: Int, cameraDataList: [VOYCameraData], completion:@escaping(Error?) -> Void)
}
