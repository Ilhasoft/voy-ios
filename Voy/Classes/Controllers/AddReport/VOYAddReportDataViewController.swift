//
//  VOYAddReportDataViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 31/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import GrowingTextView
import DataBindSwift

class VOYAddReportDataViewController: UIViewController {

    @IBOutlet var lbTitle:UILabel!
    @IBOutlet weak var titleView: VOYTextFieldView!
    @IBOutlet weak var heightDescriptionView: NSLayoutConstraint!
    @IBOutlet weak var descriptionView: VOYTextView!
    @IBOutlet weak var lbAddLink: UILabel!
    @IBOutlet weak var txtFieldLink: UITextField!
    @IBOutlet weak var btAddLink: UIButton!
    @IBOutlet weak var tbViewLinks: DataBindTableView!
    @IBOutlet weak var dataBindView: DataBindView!
    
    var cameraDataList = [VOYCameraData]()
    var savedReport:VOYReport?
    
    init(cameraDataList:[VOYCameraData]) {
        self.cameraDataList = cameraDataList
        super.init(nibName: "VOYAddReportDataViewController", bundle: nil)
    }
    
    init(savedReport:VOYReport) {
        self.savedReport = savedReport
        super.init(nibName: "VOYAddReportDataViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Report"
        self.txtFieldLink.delegate = self
        setupTableView()
        setupLayout()
        addNextButton()
        dataBindView.delegate = self
        if let savedReport = self.savedReport {
            dataBindView.fillFields(withObject:savedReport.toJSON())
        }
        descriptionView.delegate = self
    }
    
    func addNextButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(openNextController))
    }
    
    @objc func openNextController() {
        
        if self.titleView.txtField.text!.isEmpty {
            self.titleView.shake()
            self.titleView.txtField.becomeFirstResponder()
            return
        }
        
        let report = VOYReport(JSON: self.dataBindView.toJSON())!
        if let savedReport = self.savedReport {
            report.tags = savedReport.tags
            report.id = savedReport.id
        }
        report.cameraDataList = cameraDataList
        self.navigationController?.pushViewController(VOYAddReportTagsViewController(report:report), animated: true)
    }
    
    func setupLayout() {
        self.tbViewLinks.separatorColor = UIColor.clear
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        self.txtFieldLink.layer.borderWidth = 1
        self.txtFieldLink.layer.borderColor = VOYConstant.Color.gray.cgColor
        if !VOYTheme.activeTheme()!.allow_links {
            self.tbViewLinks.isHidden = true
            self.txtFieldLink.isHidden = true
            self.btAddLink.isHidden = true
        }
    }
    
    func setupTableView() {
        self.tbViewLinks.register(UINib(nibName: "VOYLinkTableViewCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(VOYLinkTableViewCell.self))
    }
    
    @IBAction func btAddLinkTapped(_ sender: Any) {
        if !self.txtFieldLink.text!.isEmpty {
            self.tbViewLinks.dataList.append(self.txtFieldLink.text!)
            self.tbViewLinks.reloadData()
            self.txtFieldLink.text = ""
            UIView.animate(withDuration: 0.3, animations: {
                self.btAddLink.alpha = 0.3
            })
        }
    }
    

}

extension VOYAddReportDataViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tbViewLinks.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(VOYLinkTableViewCell.self), for: indexPath) as! VOYLinkTableViewCell
        cell.setupCell(data: tbViewLinks.dataList[indexPath.row] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension VOYAddReportDataViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        
        if numberOfChars > 0 && self.btAddLink.alpha < 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.btAddLink.alpha = 1
            })
        }else if numberOfChars == 0 && self.btAddLink.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.btAddLink.alpha = 0.3
            })
        }
        
        return true
    }
    
}

extension VOYAddReportDataViewController : VOYTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        self.heightDescriptionView.constant = height + 15
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension VOYAddReportDataViewController : DataBindViewDelegate {
    func didFillAllComponents(JSON:[String:Any]) {
        
    }
    
    func willFill(component: Any, value: Any) -> Any? {
//        switch component as! UIView {
//        case self.tbViewLinks:
//            break
//        default:
//            break
//        }
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
