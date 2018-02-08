//
//  VOYReportTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

protocol VOYReportTableViewCellDelegate {
    func btResentDidTap(cell:VOYReportTableViewCell)
}

class VOYReportTableViewCell: RestBindTableViewCell {

    @IBOutlet var lbTitle:RestBindLabel!
    @IBOutlet var lbDescription:RestBindLabel!
    @IBOutlet var lbDate:RestBindLabel!
    @IBOutlet var imgReport:RestBindImageView!
    @IBOutlet var btResent:UIButton!
    
    var delegate:VOYReportTableViewCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        installShadow(view:self.restBindFillView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.restBindFillView.delegate = self
        self.selectionStyle = .none
    }

    func installShadow(view:UIView) {
        let radius: CGFloat = (self.contentView.frame.size.width - 55) / 2.0 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.1 * radius, height: view.frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        view.layer.cornerRadius = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.1, height: 0.2)  //Here you control x and y
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 2.0 //Here your control your blur
        view.layer.masksToBounds =  false
        view.layer.shadowPath = shadowPath.cgPath
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btResentTapped() {
        self.delegate?.btResentDidTap(cell: self)
    }
    
}

extension VOYReportTableViewCell : RestBindFillViewDelegate {
    func didFetch(error: Error?) {
        
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
            }else if component == self.lbDescription {
                if value is NSNull {
                    return nil
                }
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
