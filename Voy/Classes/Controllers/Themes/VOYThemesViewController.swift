//
//  VOYThemesViewController.swift
//  Voy
//
//  Created by Dielson Sales on 17/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import DropDown
import NVActivityIndicatorView

class VOYThemesViewController: UIViewController, NVActivityIndicatorViewable {

    var lbThemesCount: UILabel!
    @IBOutlet weak var dropDownAnchor: UIView!
    @IBOutlet weak var tableView: UITableView!

    static var badgeView = UIView()
    var dropDown = DropDown()
    var selectedReportView: VOYSelectedReportView!
    var viewModel: VOYThemesViewModel?

    private var presenter: VOYThemesPresenter!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        presenter = VOYThemesPresenter(view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lbThemesCount = UILabel()
        lbThemesCount.textAlignment = .center
        lbThemesCount.font = UIFont.boldSystemFont(ofSize: 18)
        lbThemesCount.text = localizedString(.themesListHeader, andNumber: 0)
        tableView.separatorColor = UIColor.clear
        tableView.register(
            UINib(nibName: VOYThemeTableViewCell.nibName, bundle: nil),
            forCellReuseIdentifier: VOYThemeTableViewCell.nibName
        )
        setupButtonItems()
        presenter.onReady()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDataUpdated),
            name: Notification.Name("userDataUpdated"),
            object: nil
        )
    }

    override func viewDidLayoutSubviews() {
        lbThemesCount.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 70)
        tableView.tableHeaderView = lbThemesCount
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Sometimes this viewController comes from a step where the navigationController is hidden
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onViewDidAppear()
    }

    fileprivate func setupDropDown(projects: [VOYProject]) {
        let width = UIScreen.main.bounds.width - 100
        selectedReportView = VOYSelectedReportView(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        selectedReportView.widthAnchor.constraint(equalToConstant: width).isActive = true
        selectedReportView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        selectedReportView.delegate = self
        self.navigationItem.titleView = selectedReportView

        dropDown.anchorView = dropDownAnchor
        dropDown.bottomOffset = CGPoint(x: 0, y: selectedReportView.bounds.size.height)
        dropDown.dataSource = projects.map {($0.name)}
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = .center
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.presenter.onProjectSelectionChanged(project: item)
        }
    }

    func configureLeftBarButtonItem(user: VOYUser) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.contentMode = .scaleAspectFill
        if let avatar = user.avatar,
            let url = URL(string: avatar) {
            imageView.kf.setImage(with: url)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onProfileButtonTapped))
        imageView.addGestureRecognizer(tapGesture)
        let leftBarButtonItem = UIBarButtonItem(customView: imageView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    func setupButtonItems() {
        if let activeUser = VOYUser.activeUser() {
            configureLeftBarButtonItem(user: activeUser)
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onNotificationsButtonTapped))
        let customView = UIImageView(image: #imageLiteral(resourceName: "bell"))
        VOYThemesViewController.badgeView = UIView(
            frame: CGRect(x: customView.frame.width - 9, y: 0, width: 9, height: 9)
        )
        VOYThemesViewController.badgeView.backgroundColor = UIColor(
            displayP3Red: 222/255,
            green: 72/255,
            blue: 107/255,
            alpha: 1
        )
        VOYThemesViewController.badgeView.clipsToBounds = true
        VOYThemesViewController.badgeView.layer.cornerRadius = VOYThemesViewController.badgeView.frame.height / 2
        VOYThemesViewController.badgeView.isHidden = true

        customView.addGestureRecognizer(gestureRecognizer)
        customView.addSubview(VOYThemesViewController.badgeView)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customView)
    }

    @objc func onProfileButtonTapped() {
        presenter.onProfileAction()
    }

    @objc func onNotificationsButtonTapped() {
        presenter.onNotificationsAction()
    }

    @objc func userDataUpdated() {
        presenter.onUserDataUpdated()
    }
}

extension VOYThemesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.viewModel else { return UITableViewCell() }
        let themes = viewModel.themesForSelectedProject()
        if let cell = tableView.dequeueReusableCell(withIdentifier: VOYThemeTableViewCell.nibName, for: indexPath)
            as? VOYThemeTableViewCell, indexPath.row < themes.count {
            let theme = themes[indexPath.row]
            cell.setupCell(with: theme)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        return viewModel.themesForSelectedProject().count
    }
}

extension VOYThemesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? VOYThemeTableViewCell, let theme = cell.theme {
            presenter.onThemeSelected(theme: theme)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
}

extension VOYThemesViewController: VOYThemesContract {

    func update(with viewModel: VOYThemesViewModel) {
        self.viewModel = viewModel
        lbThemesCount.text = localizedString(.themesListHeader, andNumber: viewModel.themesForSelectedProject().count)
        let projects = Array(viewModel.themes.keys)
        if projects.count > 0 {
            setupDropDown(projects: projects)
        }
        selectedReportView.lbTitle.text = viewModel.selectedProject?.name ?? ""
        tableView.reloadData()
    }

    func showProgress() {
        self.startAnimating()
    }

    func dismissProgress() {
        self.stopAnimating()
    }

    func navigateToReportsScreen() {
        navigationController?.pushViewController(VOYReportListViewController(), animated: true)
    }

    func navigateToProfileScreen() {
        navigationController?.pushViewController(VOYAccountViewController(), animated: true)
    }

    /**
     * Opens the notifications slider if it is closed.
     */
    func toggleNotifications() {
        guard let slideMenuController = self.slideMenuController() else { return }
        if !slideMenuController.isRightOpen() {
            slideMenuController.openRight()
        } else {
            slideMenuController.closeRight()
        }
    }

    /**
     * Sets an updated image of the user in the left navigation button.
     */
    func updateUserData(user: VOYUser) {
        configureLeftBarButtonItem(user: user)
    }

    func setNotificationBadge(hidden: Bool) {
        VOYThemesViewController.badgeView.isHidden = hidden
    }
}

extension VOYThemesViewController: VOYSelectedReportViewDelegate {
    func seletecReportDidTap() {
        dropDown.show()
    }
}
