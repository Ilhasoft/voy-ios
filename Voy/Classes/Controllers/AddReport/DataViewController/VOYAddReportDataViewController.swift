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

    @IBOutlet var lbTitle: UILabel!
    @IBOutlet weak var titleView: VOYTextFieldView!
    @IBOutlet weak var heightDescriptionView: NSLayoutConstraint!
    @IBOutlet weak var heightBindView: NSLayoutConstraint!
    @IBOutlet weak var descriptionView: VOYTextView!
    @IBOutlet weak var lbAddLink: UILabel!
    @IBOutlet weak var txtFieldLink: UITextField!
    @IBOutlet weak var btAddLink: UIButton!
    @IBOutlet weak var tbViewLinks: DataBindTableView!
    @IBOutlet weak var dataBindView: DataBindView!

    var savedReport: VOYReport

    init(savedReport: VOYReport) {
        self.savedReport = savedReport
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        self.txtFieldLink.delegate = self
        setupTableView()
        setupLayout()
        addNextButton()
        dataBindView.delegate = self
        dataBindView.fillFields(withObject: savedReport.toJSON())
        descriptionView.delegate = self
        setupLocalization()
    }

    func addNextButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: localizedString(.next),
            style: .plain,
            target: self,
            action: #selector(openNextController)
        )
    }

    @objc func openNextController() {
        if titleView.txtField.safeText.isEmpty {
            titleView.shake()
            titleView.txtField.becomeFirstResponder()
            return
        }
        if let report = VOYReport(JSON: self.dataBindView.toJSON()) {
            savedReport.name = report.name
            savedReport.description = report.description
            savedReport.urls = report.urls
            savedReport.update = true
            navigationController?.pushViewController(
                VOYAddReportTagsViewController(report: savedReport),
                animated: true
            )
        }
    }

    func setupLayout() {
        guard let activeTheme = assertExists(optionalVar: VOYTheme.activeTheme()) else { return }

        titleView.txtField.autocapitalizationType = .sentences

        tbViewLinks.separatorColor = UIColor.clear
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        automaticallyAdjustsScrollViewInsets = false
        txtFieldLink.layer.borderWidth = 1
        txtFieldLink.layer.borderColor = UIColor.voyGray.cgColor
        if !activeTheme.allow_links {
            tbViewLinks.isHidden = true
            txtFieldLink.isHidden = true
            btAddLink.isHidden = true
            lbAddLink.isHidden = true
        }
    }

    func setupTableView() {
        self.tbViewLinks.register(
            UINib(nibName: "VOYLinkTableViewCell", bundle: nil),
            forCellReuseIdentifier: NSStringFromClass(VOYLinkTableViewCell.self)
        )
    }

    @IBAction func btAddLinkTapped(_ sender: Any) {
        if !txtFieldLink.safeText.isEmpty && txtFieldLink.safeText.isValidURL {
            tbViewLinks.dataList.append(txtFieldLink.safeText)
            tbViewLinks.reloadData()
            txtFieldLink.text = ""
            UIView.animate(withDuration: 0.3, animations: {
                self.btAddLink.alpha = 0.3
            })
        }
    }

    // MARK: - Localization

    private func setupLocalization() {
        title = localizedString(.addReport)
        lbTitle.text = localizedString(.titleAndDescription)
        titleView.placeholder = localizedString(.title)
        descriptionView.placeholder = localizedString(.description)
        lbAddLink.text = localizedString(.addLink)
    }

}

extension VOYAddReportDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tbViewLinks.dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NSStringFromClass(VOYLinkTableViewCell.self),
            for: indexPath
        )
        if let linkTableViewCell = cell as? VOYLinkTableViewCell {
            linkTableViewCell.delegate = self
            if let dataList = tbViewLinks.dataList[indexPath.row] as? String {
                linkTableViewCell.setupCell(data: dataList)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension VOYAddReportDataViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        let newText = (textField.safeText as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count

        if numberOfChars > 0 && self.btAddLink.alpha < 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.btAddLink.alpha = 1
            })
        } else if numberOfChars == 0 && self.btAddLink.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.btAddLink.alpha = 0.3
            })
        }

        return true
    }
}

extension VOYAddReportDataViewController: VOYTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        heightDescriptionView.constant = height + 15
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension VOYAddReportDataViewController: VOYLinkTableViewCellDelegate {
    func linkDidTap(url: String, cell: VOYLinkTableViewCell) {
    }

    func removeButtonDidTap(cell: VOYLinkTableViewCell) {
        if let dataList = tbViewLinks.dataList as? [String] {
            let index = dataList.index {($0 == cell.lbLink.safeText)}
            if let index = index {
                tbViewLinks.dataList.remove(at: index)
                tbViewLinks.reloadData()
            }
        }
    }
}

extension VOYAddReportDataViewController: DataBindViewDelegate {
    func didFillAllComponents(JSON: [String: Any]) {
    }

    func willFill(component: Any, value: Any) -> Any? {
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
