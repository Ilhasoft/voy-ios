//
//  VOYReportDetailCameraExtension.swift
//  Voy
//
//  Created by Daniel Amaral on 19/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

extension VOYAddReportAttachViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            
        }
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let path = VOYFileUtil.writeImageFile(UIImageJPEGRepresentation(image, 0.2)!)
            cameraData = VOYCameraData(image: image, path: URL(fileURLWithPath: path), type: .image)
        }else if let mediaURL = info[UIImagePickerControllerMediaURL] as? URL {
            self.startAnimating()
            ISVideoUtil.compressVideo(inputURL: mediaURL, completion: { (success, url) in
                self.stopAnimating()
                self.cameraData = VOYCameraData(image: nil, path: mediaURL, type: .video)
            })
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
}
