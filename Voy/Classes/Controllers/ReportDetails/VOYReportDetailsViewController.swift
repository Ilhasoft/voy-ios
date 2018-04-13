//
//  VOYReportDetailsViewController.swift
//  Voy
//
//  Created by Dielson Sales on 12/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

enum VOYReportDetailsRow: String {
    case header
}

class VOYReportDetailsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    init(report: VOYReport) {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(
            UINib(nibName: "VOYReportDetailsHeaderCell", bundle: nil),
            forCellReuseIdentifier: VOYReportDetailsRow.header.rawValue
        )
    }
}

extension VOYReportDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath.row)")
    }
}

extension VOYReportDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseIdentifier = ""
        if indexPath.row == 0 {
            reuseIdentifier = VOYReportDetailsRow.header.rawValue
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) else {
            fatalError("Cell was not found")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
