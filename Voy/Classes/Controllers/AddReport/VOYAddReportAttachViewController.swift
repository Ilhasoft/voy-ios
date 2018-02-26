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
import MobileCoreServices

class VOYAddReportAttachViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var mediaViews:[VOYAddMediaView]!
    @IBOutlet var lbTitle:UILabel!

    var locationManager:VOYLocationManager!
    var theme:VOYTheme!
    var imagePickerController:UIImagePickerController!
    var actionSheetController:VOYActionSheetViewController!
    
    var report:VOYReport?
    var removedMedias = [VOYMedia]()
    
    var mediaList = [VOYMedia]() {
        didSet {
            self.navigationItem.rightBarButtonItem!.isEnabled = !mediaList.isEmpty
        }
    }
    
    var cameraDataList = [VOYCameraData]() {
        didSet {
            self.navigationItem.rightBarButtonItem!.isEnabled = !cameraDataList.isEmpty
        }
    }
    var cameraData:VOYCameraData! {
        didSet {
            cameraDataList.append(cameraData)
            setupMediaView()
        }
    }
    
    var tappedMediaView:VOYAddMediaView!
    
    init(report:VOYReport) {
        self.report = report
        super.init(nibName: "VOYAddReportAttachViewController", bundle: nil)
    }
    
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
        loadFromReport()
    }
    
    func loadFromReport() {
        guard let report = self.report else { return }        
        mediaList = report.files
        for (index,mediaView) in self.mediaViews.enumerated() {
            guard index < report.files.count else { return }
            mediaView.setupWithMedia(media: mediaList[index])
        }
    }
    
    func addNextButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(openNextController))
        self.navigationItem.rightBarButtonItem!.isEnabled = false
    }
    
    @objc func openNextController() {
        let addReportDataViewController = self.report != nil ? VOYAddReportDataViewController(savedReport: self.report!) : VOYAddReportDataViewController(cameraDataList:self.cameraDataList)
        self.navigationController?.pushViewController(addReportDataViewController, animated: true)
    }
    
    func setupMediaViewDelegate() {
        for mediaView in mediaViews {
            mediaView.delegate = self
        }
    }
    
    func setupMediaView() {
        tappedMediaView.setupWithMedia(cameraData:self.cameraData)
    }
    
}

extension VOYAddReportAttachViewController : VOYAddMediaViewDelegate {
    func mediaViewDidTap(mediaView: VOYAddMediaView) {
        tappedMediaView = mediaView
        actionSheetController = VOYActionSheetViewController(buttonNames: ["Movie","Photo"], icons: [#imageLiteral(resourceName: "noun1018049Cc"),#imageLiteral(resourceName: "noun938989Cc")])
        actionSheetController.delegate = self
        actionSheetController.show(true, inViewController: self)
    }
    func removeMediaButtonDidTap(mediaView: VOYAddMediaView) {
        if let cameraData = mediaView.cameraData {
            let index = self.cameraDataList.index{($0.id == cameraData.id)}
            if let index = index {
                self.cameraDataList.remove(at: index)
            }
        }else if let media = mediaView.media {
            let index = self.mediaList.index{($0.id == media.id)}
            if let index = index {
                self.mediaList.remove(at: index)
                self.removedMedias.append(media)
            }
            self.report!.removedMedias = self.removedMedias
        }
    }
}

extension VOYAddReportAttachViewController : VOYActionSheetViewControllerDelegate {
    func buttonDidTap(actionSheetViewController: VOYActionSheetViewController, button: UIButton, index: Int) {
        actionSheetController.close()
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        if index == 0 {
            imagePickerController.mediaTypes = [kUTTypeMovie as String]
            imagePickerController.videoQuality = .type640x480
            imagePickerController.videoMaximumDuration = 30
            imagePickerController.allowsEditing = true
        }else {
            imagePickerController.mediaTypes = [kUTTypeImage as String]
        }
        self.present(imagePickerController, animated: true) {
            
        }
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
