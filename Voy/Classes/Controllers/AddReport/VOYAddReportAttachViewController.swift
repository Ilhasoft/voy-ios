//
//  VOYAddReportAttachViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class VOYAddReportAttachViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var mediaViews:[VOYAddMediaView]!
    @IBOutlet var lbTitle:UILabel!

    var locationManager:VOYLocationManager!
    var theme:VOYTheme!
    
    init() {
        super.init(nibName: "VOYAddReportAttachViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.theme = VOYTheme.activeTheme()!
        locationManager = VOYLocationManager(delegate: self)
        locationManager.getCurrentLocation()
        self.startAnimating()
        
        self.title = "Add Report"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setupMediaViewDelegate()
        addNextButton()
        checkBounds()
    }
    
    func checkBounds() {

    }
    
    func addNextButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(openNextController))
    }
    
    @objc func openNextController() {
        self.navigationController?.pushViewController(VOYAddReportDataViewController(), animated: true)
    }
    
    func setupMediaViewDelegate() {
        for mediaView in mediaViews {
            mediaView.delegate = self
        }
    }
    
}

extension VOYAddReportAttachViewController : VOYAddMediaViewDelegate {
    func mediaViewDidTap(mediaView: VOYAddMediaView) {
        let actionSheetController = VOYActionSheetViewController(buttonNames: ["Movie","Photo"], icons: [#imageLiteral(resourceName: "noun1018049Cc"),#imageLiteral(resourceName: "noun938989Cc")])
        actionSheetController.delegate = self
        actionSheetController.show(true, inViewController: self)
    }
    func removeMediaButtonDidTap(mediaView: VOYAddMediaView) {
        
    }
}

extension VOYAddReportAttachViewController : VOYActionSheetViewControllerDelegate {
    func buttonDidTap(actionSheetViewController: VOYActionSheetViewController, button: UIButton, index: Int) {
        //TODO: Implement actions
    }
    func cancelButtonDidTap(actionSheetViewController:VOYActionSheetViewController) {
        actionSheetViewController.close()
    }
}

extension VOYAddReportAttachViewController : VOYLocationManagerDelegate {
    func didGetUserLocation(latitude: Float, longitude: Float, error: Error?) {
        self.stopAnimating()
        let myLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        var loctionCoordinate2dList = [CLLocationCoordinate2D]()
        for point in theme.bounds {
            let locationCoordinate2D = CLLocationCoordinate2D(latitude: point[0], longitude: point[1])
            loctionCoordinate2dList.append(locationCoordinate2D)
        }
        
        let statePolygonRenderer = MKPolygonRenderer(polygon: MKPolygon(coordinates: loctionCoordinate2dList, count: loctionCoordinate2dList.count))
        let testMapPoint: MKMapPoint = MKMapPointForCoordinate(myLocation)
        let statePolygonRenderedPoint: CGPoint = statePolygonRenderer.point(for: testMapPoint)
        let intersects: Bool = statePolygonRenderer.path.contains(statePolygonRenderedPoint)
        if !intersects {
            let alertViewController = VOYAlertViewController(title: "Alert", message: "You are outside this theme's bounds. You couldn't create a report.")
            alertViewController.view.tag = 1
            alertViewController.delegate = self
            alertViewController.show(true, inViewController: self)
        }
    }
    
    func userDidntGivePermission() {
        self.stopAnimating()
        let alertViewController = VOYAlertViewController(title: "No GPS Permission", message: "You need provide GPS permission before create a report.")
        alertViewController.view.tag = 2
        alertViewController.delegate = self
        alertViewController.show(true, inViewController: self)
    }
}

extension VOYAddReportAttachViewController : VOYAlertViewControllerDelegate {
    func buttonDidTap(alertController: VOYAlertViewController, button: UIButton, index: Int) {
        alertController.close()
        self.navigationController?.popViewController(animated: true)
        if alertController.view.tag == 1 {
        }else if alertController.view.tag == 2 {
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
}
