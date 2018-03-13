//
//  VOYCommentViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

class VOYCommentViewController: UIViewController, VOYCommentContract {
    
    @IBOutlet weak var tableView: DataBindOnDemandTableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bgViewTextField: UIView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var btSend: UIButton!
    @IBOutlet weak var txtField: UITextField!
    
    var report: VOYReport!
    var presenter: VOYCommentPresenter?
    var activeCellId: Int?
    
    init(report: VOYReport) {
        self.report = report
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = VOYCommentPresenter(dataSource: VOYCommentRepository(), view: self)
        setupKeyboard()
        setupTableView()
        setupLayout()
        setupLocalization()
    }
    
    func setupLayout() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        edgesForExtendedLayout = []
        self.bgViewTextField.layer.cornerRadius = 4
        self.bgViewTextField.layer.borderColor = UIColor.voyLightGray.cgColor
        self.bgViewTextField.layer.borderWidth = 2
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    func setupTableView() {
        tableView.register(
            UINib(nibName: "VOYCommentTableViewCell", bundle: Bundle(for: VOYCommentTableViewCell.self)),
            forCellReuseIdentifier: NSStringFromClass(VOYCommentTableViewCell.self)
        )
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.refreshControl = nil
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        tableView.onDemandTableViewDelegate = self
        tableView.interactor = DataBindOnDemandTableViewInteractor(
            configuration: tableView.getConfiguration(),
            params: ["report": self.report.id!],
            paginationCount: 20
        )
        tableView.loadContent()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? Double,
                let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? UInt {
                view.setNeedsLayout()
                view.layoutIfNeeded()
                UIView.animate(
                    withDuration: duration,
                    delay: 0,
                    options: UIViewAnimationOptions(rawValue: curve),
                    animations: {
                        self.bottomViewConstraint.constant = -keyboardSize.height //- 45
                        self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue != nil {
            if let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? Double,
                let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? UInt {
                view.setNeedsLayout()
                view.layoutIfNeeded()
                UIView.animate(
                    withDuration: duration,
                    delay: 0,
                    options: UIViewAnimationOptions(rawValue: curve),
                    animations: {
                        self.bottomViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }

    func sendComment() {
        let text = self.txtField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.isEmpty {
            let comment = VOYComment(text: text, reportID: self.report.id!)
            self.txtField.text = ""
            self.txtField.resignFirstResponder()
            guard let presenter = presenter else { return }
            presenter.save(comment: comment, completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
            let alertViewController = VOYAlertViewController(
                title: localizedString(.thanks),
                message: localizedString(.commentSentToModeration)
            )
            alertViewController.show(true, inViewController: self)
        }
    }
    
    @objc fileprivate func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func btSendTapped(_ sender: Any) {
        sendComment()
    }
    
    // MARK: - Localization
    
    private func setupLocalization() {
        self.title = localizedString(.comments)
        btSend.setTitle(localizedString(.send), for: .normal)
        self.txtField.placeholder = localizedString(.sendComment)
    }
}

extension VOYCommentViewController: ISOnDemandTableViewDelegate {
    
    func onDemandTableView(_ tableView: ISOnDemandTableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func onDemandTableView(_ tableView: ISOnDemandTableView, reuseIdentifierForCellAt indexPath: IndexPath) -> String {
        return NSStringFromClass(VOYCommentTableViewCell.self)
    }        
    
    func onDemandTableView(_ tableView: ISOnDemandTableView, onContentLoad lastData: [Any]?, withError error: Error?) {
        
    }
    
    func onDemandTableView(_ tableView: ISOnDemandTableView, setupCell cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? VOYCommentTableViewCell {
            cell.delegate = self
        }
    }
    
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension VOYCommentViewController: VOYCommentTableViewCellDelegate {
    func btOptionsDidTap(commentId: Int) {
        self.activeCellId = commentId
        let actionSheetViewController = VOYActionSheetViewController(
            buttonNames: [localizedString(.remove)],
            icons: nil
        )
        actionSheetViewController.delegate = self
        actionSheetViewController.show(true, inViewController: self)
    }
}

extension VOYCommentViewController: VOYActionSheetViewControllerDelegate {
    func cancelButtonDidTap(actionSheetViewController: VOYActionSheetViewController) {
        self.activeCellId = nil
        actionSheetViewController.close()
    }
    
    func buttonDidTap(actionSheetViewController: VOYActionSheetViewController, button: UIButton, index: Int) {
        guard let presenter = self.presenter, let id = self.activeCellId else { return }
        actionSheetViewController.close()
        presenter.remove(commentId: id) { (_) in
            self.activeCellId = nil
            self.tableView.interactor?.refreshAllContent()
        }
    }
}
