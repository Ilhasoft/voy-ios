//
//  VOYCameraData.swift
//  Voy
//
//  Created by Daniel Amaral on 19/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//
import UIKit

struct VOYCameraData {
    
    var id:String!
    var type:VOYMediaType!
    var image:UIImage?
    var path:URL?
    
    init(image:UIImage?, path:URL?, type:VOYMediaType) {
        self.id = getIdentifier()
        self.image = image
        self.path = path
        self.type = type
    }
    
    private func getIdentifier() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let minutes = Calendar.current.component(.minute, from: Date())
        let seconds = Calendar.current.component(.second, from: Date())
        return "\(hour)\(minutes)\(seconds)"
    }
    
}
