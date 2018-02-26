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
    
    @IBOutlet weak var tableView: DataBindOnDemandTableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bgViewTextField: UIView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var btSend: UIButton!
    @IBOutlet weak var txtField: UITextField!
    
    var report:VOYReport!
    
    init(report:VOYReport) {
        self.report = report
        super.init(nibName: "VOYCommentViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comment"
        setupKeyboard()
        setupTableView()
        setupLayout()
    }
    
    func setupLayout() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        self.bgViewTextField.layer.cornerRadius = 4
        self.bgViewTextField.layer.borderColor = UIColor(hex: "E7E7E7").cgColor
        self.bgViewTextField.layer.borderWidth = 2
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "VOYCommentTableViewCell", bundle: Bundle(for:VOYCommentTableViewCell.self)), forCellReuseIdentifier: NSStringFromClass(VOYCommentTableViewCell.self))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.refreshControl = nil
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
        tableView.onDemandTableViewDelegate = self
        tableView.interactor = DataBindOnDemandTableViewInteractor(configuration: tableView.getConfiguration(), params: ["report":self.report.id!], paginationCount: 20)
        tableView.loadContent()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
            let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
            view.setNeedsLayout()
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
                self.bottomViewConstraint.constant = -keyboardSize.height //- 45
                self.view.layoutIfNeeded()
            }, completion:nil)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
            let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
            view.setNeedsLayout()
            view.layoutIfNeeded()
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
                self.bottomViewConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion:nil)
        }
    }
    
    func sendComment() {
        let text = self.txtField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.isEmpty {
            let comment = VOYComment(text:text, reportID:self.report.id!)
            self.txtField.text = ""
            self.txtField.resignFirstResponder()
            VOYCommentInteractor.shared.save(comment:comment) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            let alertViewController = VOYAlertViewController(title: "Thanks!", message: "Your comment was sent to moderation after approved it will available here!")
            alertViewController.show(true, inViewController: self)
        }
    }
    
    @objc fileprivate func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func btSendTapped(_ sender: Any) {
        sendComment()
    }
}

extension VOYCommentViewController : ISOnDemandTableViewDelegate {
    
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

extension VOYCommentViewController : VOYCommentTableViewCellDelegate {
    func btOptionsDidTap(cell: VOYCommentTableViewCell) {
        let actionSheetViewController = VOYActionSheetViewController(buttonNames: ["Remove"], icons: nil)
        actionSheetViewController.delegate = self
        actionSheetViewController.show(true, inViewController: self)
    }
}

extension VOYCommentViewController : VOYActionSheetViewControllerDelegate {
    func cancelButtonDidTap(actionSheetViewController: VOYActionSheetViewController) {
        actionSheetViewController.close()
    }
    func buttonDidTap(actionSheetViewController: VOYActionSheetViewController, button: UIButton, index: Int) {
        print("remove")
    }
}
