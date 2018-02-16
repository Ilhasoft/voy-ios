//
//  VOYThemeListViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import RestBind
import ISOnDemandTableView
import DropDown
import ObjectMapper
import NVActivityIndicatorView
import Kingfisher

class VOYThemeListViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var lbThemesCount: UILabel!
    @IBOutlet weak var tbView: RestBindTableView!
    
    var userJustLogged = false
    var selectedReportView:VOYSelectedReportView!
    var dropDown = DropDown()
    var projects = [VOYProject]() {
        didSet {
            if !projects.isEmpty {
                let selectedReport = projects.first!
                setupDropDown()
                setupTableView(filterThemesByProject: selectedReport)
                self.selectedReportView.lbTitle.text = selectedReport.name
            }else {
                print("User without projects associated")
            }
        }
    }
    
    init(userJustLogged:Bool) {
        self.userJustLogged = userJustLogged
        super.init(nibName: "VOYThemeListViewController", bundle: nil)
    }
    
    init() {
        super.init(nibName: "VOYThemeListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        setupButtonItems()
        getProjects()
        NotificationCenter.default.addObserver(self, selector: #selector(addLeftBarButtonItem), name: Notification.Name("userDataUpdated"), object: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func addLeftBarButtonItem() {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.kf.setImage(with: URL(string:VOYUser.activeUser()!.avatar)!)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openAccount))
        imageView.addGestureRecognizer(tapGesture)
        let leftBarButtonItem = UIBarButtonItem(customView: imageView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func setupButtonItems() {
        addLeftBarButtonItem()
        let rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bell"), style: .plain, target: self, action: #selector(openNotifications))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func getProjects() {
        self.startAnimating()
        VOYProjectInteractor.getMyProjects { (projects, error) in
            self.stopAnimating()
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.projects = projects
                if self.userJustLogged {
                    for project in self.projects {
                        var params = ["project":project.id as Any, "user":VOYUser.activeUser()!.id]
                        VOYRequestManager.cacheDataFrom(url: VOYConstant.API.URL + "themes", parameters:&params)
                    }
                    self.userJustLogged = false
                }
            }
        }
    }
    
    func setupDropDown() {
        
        selectedReportView = VOYSelectedReportView(frame: CGRect(x: 0, y: 0, width: 180, height: 40))
        selectedReportView.widthAnchor.constraint(equalToConstant: 180)
        selectedReportView.heightAnchor.constraint(equalToConstant: 40)
        selectedReportView.delegate = self
        self.navigationItem.titleView = selectedReportView            
        
        dropDown.anchorView = selectedReportView
        dropDown.bottomOffset = CGPoint(x: 0, y: selectedReportView.bounds.size.height)
        dropDown.dataSource = self.projects.map {($0.name)}
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = .center
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.loadThemesFilteredByProject(project: self.projects[index])
            self.selectedReportView.lbTitle.text = item
        }
    }
    
    @objc func openAccount() {
        self.navigationController?.pushViewController(VOYAccountViewController(), animated: true)
    }
    
    @objc func openNotifications() {
        self.slideMenuController()?.openRight()
    }
    
    func loadThemesFilteredByProject(project:VOYProject) {
        VOYProject.setActiveProject(project: project)
        tbView.interactor = RestBindTableViewProvider(configuration:tbView.getConfiguration(), params: ["project":project.id,"user":VOYUser.activeUser()!.id])
        tbView.loadContent()
    }
    
    func setupTableView(filterThemesByProject project:VOYProject) {
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
        self.lbThemesCount.text = "You are on \(String(describing: tableView.interactor!.objects.count)) themes"
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! VOYThemeTableViewCell
        self.navigationController?.pushViewController(VOYReportListViewController(theme: VOYTheme(JSON: cell.object.JSON)!), animated: true)
    }
}

extension VOYThemeListViewController : VOYSelectedReportViewDelegate {
    func seletecReportDidTap() {
        dropDown.show()
    }
}
