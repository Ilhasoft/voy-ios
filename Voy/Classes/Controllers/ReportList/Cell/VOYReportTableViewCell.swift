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
            didLayoutSubviews = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataBindView.delegate = self
        self.selectionStyle = .none
    }
}

extension VOYReportTableViewCell: DataBindViewDelegate {
    func didFillAllComponents(JSON: [String: Any]) {
        if let report = VOYReport(JSON: JSON), report.status == nil {
            self.btResent.isHidden = false
            if let cameraData = report.cameraDataList?.first, let mediaType = cameraData.type {
                switch mediaType {
                case .image:
                    if let fileName = cameraData.fileName,
                        let imagePath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(fileName) {
                        imgReport.image = UIImage(contentsOfFile: imagePath)
                    }
                case .video:
                    if let thumbnailFileName = cameraData.thumbnailFileName,
                        let thumbnailPath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(thumbnailFileName) {
                        imgReport.image = UIImage(contentsOfFile: thumbnailPath)
                    }
                }
            }
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
