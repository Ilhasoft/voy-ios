//
//  VOYThemesViewController.swift
//  Voy
//
//  Created by Dielson Sales on 17/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYThemesViewController: UIViewController {

    @IBOutlet weak var lbThemesCount: UILabel!
    @IBOutlet weak var tableView: UITableView!

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
}

extension VOYThemesViewController: VOYThemesContract {
    func showProgress() {
        // TODO
    }

    func dismissProgress() {
        // TODO
    }
}
