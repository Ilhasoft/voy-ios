//
//  VOYReportDetailsViewController.swift
//  Voy
//
//  Created by Dielson Sales on 27/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import TagListView

class VOYReportDetailsViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbDescription: UILabel!
    @IBOutlet var viewTags: TagListView!

    init(report: VOYReport) {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lbDescription.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor" +
        "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco" +
        "laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit" +
        " esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa" +
        " qui officia deserunt mollit anim id est laborum." +
        "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco" +
        "laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit" +
        " esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa" +
        " qui officia deserunt mollit anim id est laborum." +
        "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco" +
        "laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit" +
        " esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa" +
        " qui officia deserunt mollit anim id est laborum." +
        "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco" +
        "laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit" +
        " esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa" +
        " qui officia deserunt mollit anim id est laborum."
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ContentSize: \(scrollView.contentSize.height)")
    }
}
