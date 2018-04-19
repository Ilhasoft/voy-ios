//
//  VOYThemesViewController.swift
//  Voy
//
//  Created by Dielson Sales on 17/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import DropDown

class VOYThemesViewController: UIViewController {

    @IBOutlet weak var lbThemesCount: UILabel!
    @IBOutlet weak var tableView: UITableView!

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
        presenter.onReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Sometimes this viewController comes from a step where the navigationController is hidden
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

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
//            self.loadThemesFilteredByProject(project: projects[index])
            self.selectedReportView.lbTitle.text = item
        }
    }
}

extension VOYThemesViewController: VOYThemesContract {

    func update(with viewModel: VOYThemesViewModel) {
        lbThemesCount.text = localizedString(.themesListHeader, andNumber: viewModel.themes.count)
        let projects = Array(viewModel.themes.keys)
        if projects.count > 0 {
            setupDropDown(projects: projects)
        }
        selectedReportView.lbTitle.text = viewModel.selectedProject?.name ?? ""
    }

    func showProgress() {
        // TODO
    }

    func dismissProgress() {
        // TODO
    }
}

extension VOYThemesViewController: VOYSelectedReportViewDelegate {
    func seletecReportDidTap() {
        dropDown.show()
    }
}
