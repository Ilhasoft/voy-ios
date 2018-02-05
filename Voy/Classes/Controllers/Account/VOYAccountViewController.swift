//
//  VOYAccountViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandCollectionView

class VOYAccountViewController: UIViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var viewUserName: VOYTextFieldView!
    @IBOutlet weak var viewEmail: VOYTextFieldView!
    @IBOutlet weak var viewPassword: VOYTextFieldView!
    @IBOutlet weak var btLogout: UIButton!
    @IBOutlet weak var collectionAvatar: ISOnDemandCollectionView!
    @IBOutlet weak var heightCollectionAvatar: NSLayoutConstraint!
    
    init() {
        super.init(nibName: "VOYAccountViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAvatars))
        self.imgAvatar.addGestureRecognizer(tapGesture)
        setupLayout()
        setupCollectionView()
    }

    func setupLayout() {
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupCollectionView() {
        collectionAvatar.register(UINib(nibName: "VOYAvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VOYAvatarCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionAvatar.setLayout(to: layout)
        collectionAvatar.onDemandDelegate = self
        collectionAvatar.interactor = VOYAvatarCollectionViewProvider()
        collectionAvatar.loadContent()
        
    }
    
    @objc func save() {
        
    }
    
    @objc func showAvatars() {
        self.heightCollectionAvatar.constant = self.heightCollectionAvatar.constant == 0 ? 400 : 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btLogoutTapped() {
        UIViewController.switchRootViewController(UINavigationController(rootViewController:VOYLoginViewController()), animated: true) {}
    }
    
}

extension VOYAccountViewController : ISOnDemandCollectionViewDelegate {
    func onDemandCollectionView(_ collectionView: ISOnDemandCollectionView, reuseIdentifierForItemAt indexPath: IndexPath) -> String {
        return "VOYAvatarCollectionViewCell"
    }
    
    func onDemandCollectionView(_ collectionView: ISOnDemandCollectionView, onContentLoadFinishedWithNewObjects objects: [Any]?, error: Error?) {
        
    }
    
    func onDemandCollectionView(_ collectionView: ISOnDemandCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 70, height: 70)
        return size
    }
    
    func onDemandCollectionView(_ collectionView: ISOnDemandCollectionView, didSelect cell: ISOnDemandCollectionViewCell, at indexPath: IndexPath) {
        let cell = cell as! VOYAvatarCollectionViewCell
        self.imgAvatar.image = cell.imgAvatar.image
        self.showAvatars()
    }
    
}
