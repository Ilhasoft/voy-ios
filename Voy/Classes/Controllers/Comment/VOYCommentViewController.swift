//
//  VOYCommentViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

class VOYCommentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bgViewTextField: UIView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var btSend: UIButton!
    @IBOutlet weak var txtField: UITextField!

    var report: VOYReport!
    var presenter: VOYCommentPresenter!
    var activeCellId: Int?

    private var viewModel: VOYCommentViewModel?

    init(report: VOYReport) {
        self.report = report
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        presenter = VOYCommentPresenter(dataSource: VOYCommentRepository(), view: self, report: self.report)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        setupTableView()
        setupLayout()
        setupLocalization()
        presenter.onScreenDidLoad()
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
        guard let reportId = self.report.id else { return }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(
            UINib(nibName: "VOYCommentTableViewCell", bundle: nil),
            forCellReuseIdentifier: "VOYCommentTableViewCell"
        )
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
               let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
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
        if let userInfo = notification.userInfo,
            (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue != nil {
            if let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
               let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
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
        let text = self.txtField.safeText.trimmingCharacters(in: .whitespacesAndNewlines)
        if let reportId = self.report.id, !text.isEmpty {
            let comment = VOYComment(text: text, reportID: reportId)
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

extension VOYCommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel = self.viewModel,
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "VOYCommentTableViewCell") as? VOYCommentTableViewCell {
            commentCell.set(comment: viewModel.comments[indexPath.row])
            commentCell.delegate = self
            return commentCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        return viewModel.comments.count
    }
}

extension VOYCommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
            self.tableView.reloadData()
        }
    }
}

extension VOYCommentViewController: VOYCommentContract {
    func update(with viewModel: VOYCommentViewModel) {
        self.viewModel = viewModel
        self.tableView.reloadData()
    }
}
