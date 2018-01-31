//
//  VOYAddReportDataViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 31/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYAddReportDataViewController: UIViewController {

    @IBOutlet var lbTitle:UILabel!
    @IBOutlet weak var titleView: VOYTextFieldView!
    @IBOutlet weak var descriptionView: VOYTextFieldView!
    @IBOutlet weak var lbAddLink: UILabel!
    @IBOutlet weak var txtFieldLink: UITextField!
    @IBOutlet weak var btAddLink: UIButton!
    @IBOutlet weak var tbViewLinks: UITableView!
    
    var links = [String]()

    init() {
        super.init(nibName: "VOYAddReportDataViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLayout()
        self.automaticallyAdjustsScrollViewInsets = false
    }

    func setupLayout() {
        self.txtFieldLink.layer.borderWidth = 1
        self.txtFieldLink.layer.borderColor = UIColor(hex: "f0f0f0").cgColor
    }
    
    func setupTableView() {
        self.tbViewLinks.register(UINib(nibName: "VOYLinkTableViewCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(VOYLinkTableViewCell.self))
    }
    
    @IBAction func btAddLinkTapped(_ sender: Any) {
        if !self.txtFieldLink.text!.isEmpty {
            self.links.append(self.txtFieldLink.text!)
            self.tbViewLinks.reloadData()
            self.txtFieldLink.text = ""
        }
    }
    

}

extension VOYAddReportDataViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(VOYLinkTableViewCell.self), for: indexPath) as! VOYLinkTableViewCell
        cell.setupCell(data: links[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
