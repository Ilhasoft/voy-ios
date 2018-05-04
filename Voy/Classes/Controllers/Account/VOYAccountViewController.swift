//
//  VOYAccountViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class VOYAccountViewController: UIViewController, NVActivityIndicatorViewable {

    struct Constants {
        static let cellIdentifier = "VOYAvatarCollectionViewCell"
        static let avatarsCount = 42
    }

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var viewUserName: VOYTextFieldView!
    @IBOutlet weak var viewEmail: VOYTextFieldView!
    @IBOutlet weak var viewPassword: VOYTextFieldView!
    @IBOutlet weak var btLogout: UIButton!
    @IBOutlet weak var btEditPassword: UIButton!
    @IBOutlet weak var collectionAvatar: UICollectionView!
    @IBOutlet weak var heightCollectionAvatar: NSLayoutConstraint!

    var rightBarButtonItem: UIBarButtonItem!

    var presenter: VOYAccountPresenter!
    var viewModel: VOYAccountViewModel?

    var isPasswordEditing = false
    let nilPassword = "xpto321otpx"

    var newPassword: String? {
        didSet {
            enableRightBarButtonItem()
        }
    }

    var newAvatar: Int? {
        didSet {
            enableRightBarButtonItem()
        }
    }

    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        self.presenter = VOYAccountPresenter(
            dataSource: VOYAccountRepository(),
            view: self,
            storageManager: VOYServicesProvider.shared.storageManager
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.image = nil
        imgAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAvatars)))
        viewPassword.delegate = self
        setupLayout()
        setupCollectionView()
        setupLocalization()
        presenter.onScreenLoaded()
    }

    func enableRightBarButtonItem() {
        if newPassword == nil && newAvatar == nil {
            rightBarButtonItem.isEnabled = false
        } else {
            rightBarButtonItem.isEnabled = true
        }
    }

    func setupLayout() {
        edgesForExtendedLayout = []
        rightBarButtonItem = UIBarButtonItem(
            title: localizedString(.save),
            style: .plain,
            target: self,
            action: #selector(save)
        )
        rightBarButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func setupCollectionView() {
        collectionAvatar.register(
            UINib(nibName: "VOYAvatarCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: Constants.cellIdentifier
        )
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 70, height: 70)
        collectionAvatar.collectionViewLayout = layout
    }

    @objc func save() {
        presenter?.updateUser(avatar: newAvatar, password: newPassword)
    }

    @objc func showAvatars() {
        self.heightCollectionAvatar.constant = self.heightCollectionAvatar.constant == 0 ? 400 : 0
    }

    func setupViewPasswordLayout() {
        btEditPassword.setTitle(localizedString(.change), for: .normal)
        if isPasswordEditing {
            viewPassword.editEnabled = false
            let passwordChanged = (nilPassword != self.viewPassword.txtField.text
                    && !viewPassword.txtField.safeText.isEmpty)
            if passwordChanged {
                newPassword = viewPassword.txtField.text ?? ""
            } else {
                newPassword = nil
            }
            viewPassword.txtField.text = passwordChanged ? newPassword : nilPassword

            viewPassword.layer.opacity = 0.5
            viewPassword.txtField.resignFirstResponder()
            isPasswordEditing = false
        } else {
            viewPassword.editEnabled = true
            viewPassword.txtField.text = ""
            viewPassword.layer.opacity = 1
            viewPassword.txtField.becomeFirstResponder()
            isPasswordEditing = true
        }
    }

    @IBAction func btLogoutTapped() {
        presenter.onLogoutAction()
    }

    @IBAction func btEditPasswordTapped() {
        setupViewPasswordLayout()
    }

    // MARK: - Private methods

    private func setupLocalization() {
        self.title = localizedString(.account)
        btEditPassword.setTitle(localizedString(.change), for: .normal)
        viewUserName.placeholder = localizedString(.username)
        viewEmail.placeholder = localizedString(.email)
        viewPassword.placeholder = localizedString(.newPassword)
        btLogout.setTitle(localizedString(.logout), for: .normal)
    }
}

extension VOYAccountViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath)
            as? VOYAvatarCollectionViewCell {
            cell.imgAvatar.image = UIImage(named: "ic_avatar\(indexPath.item + 1)")
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.avatarsCount
    }
}

extension VOYAccountViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newAvatar = indexPath.item + 1
        if let cell = collectionView.cellForItem(at: indexPath) as? VOYAvatarCollectionViewCell {
            imgAvatar.image = cell.imgAvatar.image
            showAvatars()
        }
    }
}

extension VOYAccountViewController: VOYTextFieldViewDelegate {
    func textFieldDidChange(_ textFieldView: VOYTextFieldView, text: String) {
        if !text.isEmpty {
            btEditPassword.setTitle(localizedString(.done), for: .normal)
        }
    }

    func textFieldDidEndEditing(_ textFieldView: VOYTextFieldView) {
        setupViewPasswordLayout()
    }
}

extension VOYAccountViewController: VOYAccountContract {

    func update(with viewModel: VOYAccountViewModel) {
        self.viewModel = viewModel
        viewUserName.txtField.text = viewModel.fullName
        viewUserName.layer.opacity = 0.5
        viewEmail.txtField.text = viewModel.email
        viewEmail.layer.opacity = 0.5
        imgAvatar.image = viewModel.avatarImage
        viewPassword.txtField.text = nilPassword
        viewPassword.layer.opacity = 0.5
    }

    func showProgress() {
        self.startAnimating()
    }

    func hideProgress() {
        self.stopAnimating()
    }

    func showLogoutConfirmation(message: String) {
        let alert = UIAlertController(
            title: localizedString(.logout),
            message: message, //localizedString(.areYouSure),
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: localizedString(.cancel),
            style: .default
        ) { (_) in }
        let confirmAction = UIAlertAction(
            title: localizedString(.logout),
            style: .default
        ) { (_) in
            self.presenter?.logoutUser()
        }

        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        present(alert, animated: true, completion: nil)
    }

    func navigateToLoginScreen() {
        let navigationController = UINavigationController(rootViewController: VOYLoginViewController())
        UIViewController.switchRootViewController(navigationController, animated: true, completion: { })
    }
}
