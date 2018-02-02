//
//  VOYAvatarCollectionViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandCollectionView

class VOYAvatarCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imgAvatar:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension VOYAvatarCollectionViewCell : ISOnDemandCollectionViewCell {
    func setup(with object: Any, at indexPath: IndexPath) {
        let image = object as! UIImage
        self.imgAvatar.image = image
    }
    
}
