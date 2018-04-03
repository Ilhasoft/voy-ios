//
//  VOYReportTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import DataBindSwift

protocol VOYReportTableViewCellDelegate: class {
    func btResentDidTap(cell: VOYReportTableViewCell)
}

class VOYReportTableViewCell: DataBindOnDemandTableViewCell {

    @IBOutlet var lbTitle: DataBindLabel!
    @IBOutlet var lbDescription: DataBindLabel!
    @IBOutlet var lbDate: DataBindLabel!
    @IBOutlet var imgReport: DataBindImageView!
    @IBOutlet var btResent: UIButton!

    weak var delegate: VOYReportTableViewCellDelegate?

    var didLayoutSubviews = false

    override func layoutSubviews() {
        super.layoutSubviews()
        if !didLayoutSubviews {
            installShadow(view: self.dataBindView)
            didLayoutSubviews = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataBindView.delegate = self
        self.selectionStyle = .none
    }

    func installShadow(view: UIView) {
        //change it to .height if you need spread for height
        let radius: CGFloat = (self.contentView.frame.size.width - 55) / 2.0

        //Change 2.1 to amount of spread you need and for height replace the code for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.1 * radius, height: view.frame.height))

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
}

extension VOYReportTableViewCell: DataBindViewDelegate {
    func didFillAllComponents(JSON: [String: Any]) {
        if let report = VOYReport(JSON: JSON), report.status == nil {
            self.btResent.isHidden = false
        } else {
            self.btResent.isHidden = true
        }
    }

    func willFill(component: Any, value: Any) -> Any? {
        if let component = component as? UILabel {
            if component == self.lbDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                if let dateString = value as? String {
                    let date = dateFormatter.date(from: dateString)

                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat = "MMM"
                    dateFormatter2.dateStyle = .medium
                    if let date = date { lbDate.text = dateFormatter2.string(from: date) }
                }
                return nil
            } else if component == self.lbDescription {
                if value is NSNull {
                    return ""
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
