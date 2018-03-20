//
//  VOYAddReportSuccessViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class VOYAddReportSuccessViewController: UIViewController {

    @IBOutlet var infoView: VOYInfoView!
    @IBOutlet var btClose: UIButton!
    
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupLocalization()
    }
    
    @IBAction func btNewReportTapped() {
        if let sharedInstance = VOYReportListViewController.sharedInstance {
            self.navigationController?.popToViewController(sharedInstance, animated: true)
        }
    }
    
    @IBAction func btCloseTapped() {
        guard let navigation = self.navigationController else { return }
        navigation.popToRootViewController(animated: true)
    }
    
    // MARK: - Localization
    
    private func setupLocalization() {
        infoView.lbTitle.text = localizedString(.thanks)
        infoView.lbMessage.text = localizedString(.thanksForReporting)
        btClose.setTitle(localizedString(.done), for: .normal)
    }

}