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

class VOYThemeListViewController: UIViewController, NVActivityIndicatorViewable, VOYThemeListContract {
    @IBOutlet weak var lbThemesCount: UILabel!
    @IBOutlet weak var tbView: DataBindOnDemandTableView!
    var presenter: VOYThemeListPresenter?
    var userJustLogged = false
    var selectedReportView: VOYSelectedReportView!
    var dropDown = DropDown()
    
    init(userJustLogged:Bool) {
        self.userJustLogged = userJustLogged
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigation = self.navigationController else { return }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        edgesForExtendedLayout = []
        setupButtonItems()
        presenter = VOYThemeListPresenter(dataSource: VOYThemeListRepository(reachability: VOYReachabilityImpl()), view: self)
        getProjects()
        checkPendentReportsToSend()
        NotificationCenter.default.addObserver(self, selector: #selector(addLeftBarButtonItem), name: Notification.Name("userDataUpdated"), object: nil)
        navigation.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func addLeftBarButtonItem() {
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.kf.setImage(with: URL(string:VOYUser.activeUser()!.avatar)!)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openAccount))
        imageView.addGestureRecognizer(tapGesture)
        let leftBarButtonItem = UIBarButtonItem(customView: imageView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func checkPendentReportsToSend() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (t) in
            VOYReportSyncManager.shared.trySendPendentReports()
        }
        Timer.scheduledTimer(withTimeInterval: 17, repeats: true) { (t) in
            VOYReportSyncManager.shared.trySendPendentCameraData()
        }
    }
    
    func setupButtonItems() {
        addLeftBarButtonItem()
        let rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bell"), style: .plain, target: self, action: #selector(openNotifications))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func getProjects() {
        guard let presenter = presenter else { return }
        self.startAnimating()
        presenter.getProjects { (success) in
            self.stopAnimating()
            if success {
                if self.userJustLogged {
                    presenter.cacheData()
                    self.userJustLogged = false
                }
            } else {
                // TODO: Show some error
            }
        }
    }
    
    func projectListWasUpdated() {
        guard let projects = presenter?.projects else { return }
        if !projects.isEmpty {
            let selectedReport = projects.first!
            setupDropDown()
            setupTableView(filterThemesByProject: selectedReport)
            self.selectedReportView.lbTitle.text = selectedReport.name
        } else {
            print("User without projects associated")
        }
    }
    
    func setupDropDown() {
        guard let projects = presenter?.projects else { return }
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
        tbView.interactor = DataBindOnDemandTableViewInteractor(configuration:tbView.getConfiguration(), params: ["project": project.id,"user": VOYUser.activeUser()!.id], paginationCount: VOYConstant.API.PAGINATION_SIZE)
        tbView.loadContent()
    }
    
    func setupTableView(filterThemesByProject project: VOYProject) {
        tbView.separatorColor = UIColor.clear
        tbView.register(UINib(nibName: "VOYThemeTableViewCell", bundle: nil), forCellReuseIdentifier: "VOYThemeTableViewCell")
        tbView.onDemandTableViewDelegate = self
        loadThemesFilteredByProject(project: project)
    }

}

extension VOYThemeListViewController : ISOnDemandTableViewDelegate {
    func onDemandTableView(_ tableView: ISOnDemandTableView, reuseIdentifierForCellAt indexPath: IndexPath) -> String {
        return "VOYThemeTableViewCell"
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
        let cell = tableView.cellForRow(at: indexPath) as! VOYThemeTableViewCell
        VOYTheme.setActiveTheme(theme: VOYTheme(JSON: cell.object.JSON)!)
        self.navigationController?.pushViewController(VOYReportListViewController(), animated: true)
    }
}

extension VOYThemeListViewController : VOYSelectedReportViewDelegate {
    func seletecReportDidTap() {
        dropDown.show()
    }
}
