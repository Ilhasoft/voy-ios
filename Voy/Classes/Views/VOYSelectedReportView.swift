//
//  VOYReportSelectedView.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYSelectedReportViewDelegate: class {
    func seletecReportDidTap()
}

class VOYSelectedReportView: UIView {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet var contentView: UIView!
    
    weak var delegate: VOYSelectedReportViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "VOYSelectedReportView", bundle: Bundle(for: VOYSelectedReportView.self))
        nib.instantiate(withOwner: self, options: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.addGestureRecognizer(tapGesture)
        contentView.frame = bounds
        self.addSubview(contentView)
    }
    
    @objc private func viewDidTap() {
        self.delegate?.seletecReportDidTap()
    }
}
