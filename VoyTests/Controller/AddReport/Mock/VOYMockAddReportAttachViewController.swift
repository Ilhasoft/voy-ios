//
//  VOYMockAddReportAttachViewController.swift
//  Voy
//
//  Created by Pericles Jr on 08/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
@testable import Voy

class VOYMockAddReportAttachViewController: VOYAddReportAttachContract {
    var addedMedias: Bool = false
    var startedMediaPicker: Bool = false
    var loadedMediaFromPreviousReport: Bool = false
    var userTappedNext: Bool = false
    var addedNextButton: Bool = false
    var userDismissedMediaPicker: Bool = false
    var mediaPicker: UIImagePickerController?
    var mediaList: [VOYMedia] = [VOYMedia]()
    
    init() {
        addNextButton()
        loadFromReport()
    }
    
    func addNextButton() {
        addedNextButton = true
        
    }
    
    func loadFromReport() {
        loadedMediaFromPreviousReport = true
    }
    
    func openNextController() {
        userTappedNext = true
    }
    

}

extension VOYMockAddReportAttachViewController: VOYActionSheetViewControllerDelegate {
    func buttonDidTap(actionSheetViewController: VOYActionSheetViewController, button: UIButton, index: Int) {
        self.mediaPicker = UIImagePickerController()
        let newMedia = VOYMedia()
        newMedia.id = 123456
        newMedia.title = "Media Title"
        self.mediaList = [newMedia, newMedia, newMedia, newMedia]
        if self.mediaList.count > 0, self.mediaPicker != nil {
            addedMedias = true
            startedMediaPicker = true
        }
    }
    
    func cancelButtonDidTap(actionSheetViewController: VOYActionSheetViewController) {
        self.mediaPicker = nil
        if self.mediaPicker == nil {
            self.userDismissedMediaPicker = true
        }
    }
}
