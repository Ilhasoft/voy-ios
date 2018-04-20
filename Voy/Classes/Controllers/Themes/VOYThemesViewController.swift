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
        lbThemesCount.text = localizedString(.themesListHeader, andNumber: 0)
        tableView.separatorColor = UIColor.clear
        tableView.register(
            UINib(nibName: VOYThemeTableViewCell.nibName, bundle: nil),
            forCellReuseIdentifier: VOYThemeTableViewCell.nibName
        )
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
            self.presenter.onProjectSelectionChanged(project: item)
        }
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
        // TODO
    }

    func dismissProgress() {
        // TODO
    }

    func navigateToReportsScreen() {
        self.navigationController?.pushViewController(VOYReportListViewController(), animated: true)
    }
}

extension VOYThemesViewController: VOYSelectedReportViewDelegate {
    func seletecReportDidTap() {
        dropDown.show()
    }
}
