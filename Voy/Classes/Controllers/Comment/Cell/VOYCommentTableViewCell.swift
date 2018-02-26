//
//  VOYCommentTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView
import DataBindSwift

protocol VOYCommentTableViewCellDelegate {
    func btOptionsDidTap(cell:VOYCommentTableViewCell)
}

class VOYCommentTableViewCell: DataBindOnDemandTableViewCell {

    @IBOutlet weak var imgAvatar: DataBindImageView!
    @IBOutlet weak var lbName: DataBindLabel!
    @IBOutlet weak var lbDate: DataBindLabel!
    @IBOutlet weak var lbComment: DataBindLabel!
    @IBOutlet weak var btOptions: UIButton!
    
    var delegate:VOYCommentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.selectionStyle = .none
        self.dataBindView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    @IBAction func btOptionsTapped(_ sender: Any) {
        delegate?.btOptionsDidTap(cell: self)
    }
    
    
}

extension VOYCommentTableViewCell : DataBindViewDelegate {
    func didFillAllComponents(JSON: [String : Any]) {
        
    }
    
    func willFill(component: Any, value: Any) -> Any? {
        if let component = component as? UILabel {
            if component == self.lbDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                let dateString = value as! String
                let date = dateFormatter.date(from: dateString)
                
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "MMM"
                dateFormatter2.dateStyle = .medium
                
                lbDate.text = dateFormatter2.string(from: date!)
                
                return nil
            }
            
        }
        return value
    }
    
    func didFill(component: Any, value: Any) {
        
    }
    
    func willSet(component: Any, value: Any) -> Any? {
        return value
    }
    
    func didSet(component: Any, value: Any) {
        
    }
    
    
}
