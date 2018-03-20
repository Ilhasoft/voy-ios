//
//  VOYThemeListViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView
import DropDown
import ObjectMapper
import NVActivityIndicatorView
import Kingfisher

class VOYThemeListViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var lbThemesCount: UILabel!
    @IBOutlet weak var tbView: DataBindOnDemandTableView!

    static var badgeView = UIView()
    var presenter: VOYThemeListPresenter?
    var userJustLogged = false
    var selectedReportView: VOYSelectedReportView!
    var dropDown = DropDown()

    init(userJustLogged: Bool) {
        self.userJustLogged = userJustLogged
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.updateNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        edgesForExtendedLayout = []
        setupButtonItems()
        presenter = VOYThemeListPresenter(
            view: self,
            dataSource: VOYThemeListRepository(reachability: VOYDefaultReachability()),
            userJustLogged: userJustLogged
        )
        presenter?.onViewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addLeftBarButtonItem),
            name: Notification.Name("userDataUpdated"),
            object: nil
        )
    }

    @objc func addLeftBarButtonItem() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.contentMode = .scaleAspectFill
        if let activeUser = VOYUser.activeUser(), let avatar = activeUser.avatar {
            imageView.kf.setImage(with: URL(string: avatar)!)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openAccount))
        imageView.addGestureRecognizer(tapGesture)
        let leftBarButtonItem = UIBarButtonItem(customView: imageView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    func setupButtonItems() {
        addLeftBarButtonItem()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openNotifications))
        let customView = UIImageView(image: #imageLiteral(resourceName: "bell"))
        VOYThemeListViewController.badgeView = UIView(
            frame: CGRect(x: customView.frame.width - 9, y: 0, width: 9, height: 9)
        )
        VOYThemeListViewController.badgeView.backgroundColor = UIColor(
            displayP3Red: 222/255,
            green: 72/255,
            blue: 107/255,
            alpha: 1
        )
        VOYThemeListViewController.badgeView.clipsToBounds = true
        VOYThemeListViewController.badgeView.layer.cornerRadius = VOYThemeListViewController.badgeView.frame.height/2
        VOYThemeListViewController.badgeView.isHidden = true

        customView.addGestureRecognizer(gestureRecognizer)
        customView.addSubview(VOYThemeListViewController.badgeView)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customView)
    }

    @objc func openAccount() {
        guard let navigation = self.navigationController else { return }
        navigation.pushViewController(VOYAccountViewController(), animated: true)
    }

    @objc func openNotifications() {
        guard let slideMenu = self.slideMenuController() else { return }
        slideMenu.openRight()
    }

    func loadThemesFilteredByProject(project: VOYProject) {
        VOYProject.setActiveProject(project: project)
        tbView.interactor = DataBindOnDemandTableViewInteractor(
            configuration: tbView.getConfiguration(),
            params: ["project": project.id, "user": VOYUser.activeUser()!.id],
            paginationCount: VOYConstant.API.paginationSize,
            reachability: VOYDefaultReachability()
        )
        tbView.loadContent()
    }

    func setupTableView(filterThemesByProject project: VOYProject) {
        tbView.separatorColor = UIColor.clear
        tbView.register(
            UINib(nibName: VOYThemeTableViewCell.nibName, bundle: nil),
            forCellReuseIdentifier: VOYThemeTableViewCell.nibName
        )
        tbView.onDemandTableViewDelegate = self
        loadThemesFilteredByProject(project: project)
    }

    // MARK: - Private methods

    fileprivate func setupDropDown(projects: [VOYProject]) {
        selectedReportView = VOYSelectedReportView(frame: CGRect(x: 0, y: 0, width: 180, height: 40))
        selectedReportView.widthAnchor.constraint(equalToConstant: 180)
        selectedReportView.heightAnchor.constraint(equalToConstant: 40)
        selectedReportView.delegate = self
        self.navigationItem.titleView = selectedReportView

        dropDown.anchorView = selectedReportView
        dropDown.bottomOffset = CGPoint(x: 0, y: selectedReportView.bounds.size.height)
        dropDown.dataSource = projects.map {($0.name)}
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = .center
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.loadThemesFilteredByProject(project: projects[index])
            self.selectedReportView.lbTitle.text = item
        }
    }
}

extension VOYThemeListViewController: VOYThemeListContract {
    func updateProjectsList(projects: [VOYProject]) {
        if !projects.isEmpty {
            let selectedReport = projects.first!
            setupDropDown(projects: projects)
            setupTableView(filterThemesByProject: selectedReport)
            self.selectedReportView.lbTitle.text = selectedReport.name
        }
    }

    func navigateToReportList() {
        self.navigationController?.pushViewController(VOYReportListViewController(), animated: true)
    }
}

extension VOYThemeListViewController: ISOnDemandTableViewDelegate {
    func onDemandTableView(_ tableView: ISOnDemandTableView, reuseIdentifierForCellAt indexPath: IndexPath) -> String {
        return VOYThemeTableViewCell.nibName
    }

    func onDemandTableView(_ tableView: ISOnDemandTableView, setupCell cell: UITableViewCell, at indexPath: IndexPath) {
    }

    func onDemandTableView(_ tableView: ISOnDemandTableView, onContentLoad lastData: [Any]?, withError error: Error?) {
        self.lbThemesCount.text = localizedString(
            .themesListHeader,
            andNumber: tableView.interactor!.objects.count
        )
    }

    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }

    func onDemandTableView(_ tableView: ISOnDemandTableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? VOYThemeTableViewCell {
            presenter?.onThemeSelected(object: cell.object.JSON)
        }
    }
}

extension VOYThemeListViewController: VOYSelectedReportViewDelegate {
    func seletecReportDidTap() {
        dropDown.show()
    }
}
