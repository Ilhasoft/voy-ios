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

    @IBOutlet var mediaViews: [VOYAddMediaView]!
    @IBOutlet var lbTitle: UILabel!

    var imagePickerController: UIImagePickerController!
    var actionSheetController: VOYActionSheetViewController!
    var presenter: VOYAddReportAttachPresenter!

    var mediaList = [VOYMedia]() {
        didSet {
            self.navigationItem.rightBarButtonItem?.isEnabled = !mediaList.isEmpty
        }
    }

    var cameraDataList = [VOYCameraData]() {
        didSet {
            self.navigationItem.rightBarButtonItem?.isEnabled = !cameraDataList.isEmpty
        }
    }

    var cameraData: VOYCameraData! {
        didSet {
            cameraDataList.append(cameraData)
            setupMediaView()
        }
    }

    var tappedMediaView: VOYAddMediaView!

    private init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    init(report: VOYReport? = nil) {
        super.init(nibName: "VOYAddReportAttachViewController", bundle: nil)
        if let report = report {
            self.presenter = VOYAddReportAttachPresenter(view: self, report: report)
        } else {
            self.presenter = VOYAddReportAttachPresenter(view: self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        // Setup mediaView delegates
        for mediaView in mediaViews {
            mediaView.delegate = self
        }

        addNextButton()
        setupLocalization()
        presenter.onViewDidLoad()
    }

    private func addNextButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: localizedString(.next),
            style: .plain,
            target: self,
            action: #selector(onTapNextButton)
        )
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    @objc func onTapNextButton() {
        presenter.onNextButtonTapped()
    }

    func setupMediaView() {
        tappedMediaView.setupWithMedia(cameraData: self.cameraData)
    }

    // MARK: - Localization

    private func setupLocalization() {
        self.title = localizedString(.addReport)
        lbTitle.text = localizedString(.addPhotosAndVideos)
    }
}

extension VOYAddReportAttachViewController: VOYAddReportAttachContract {

    func loadFromReport(mediaList: [VOYMedia], cameraDataList: [VOYCameraData]) {
        self.mediaList = mediaList
        self.cameraDataList = cameraDataList
        for (index, mediaView) in self.mediaViews.enumerated() {
            if index < mediaList.count {
                let media = mediaList[index]
                mediaView.setupWithMedia(media: media)
            } else if index < mediaList.count + cameraDataList.count {
                let cameraData = cameraDataList[index - mediaList.count]
                mediaView.setupWithMedia(cameraData: cameraData)
            }
        }
    }

    func navigateToNextScreen(report: VOYReport) {
        report.cameraDataList = cameraDataList
        self.navigationController?.pushViewController(
            VOYAddReportDataViewController(savedReport: report),
            animated: true
        )
    }
}

extension VOYAddReportAttachViewController: VOYAddMediaViewDelegate {

    func mediaViewDidTap(mediaView: VOYAddMediaView) {
        tappedMediaView = mediaView
        actionSheetController = VOYActionSheetViewController(
            buttonNames: [localizedString(.movie), localizedString(.photo)],
            icons: [#imageLiteral(resourceName: "noun1018049Cc"), #imageLiteral(resourceName: "noun938989Cc")]
        )
        actionSheetController.delegate = self
        actionSheetController.show(true, inViewController: self)
    }

    func removeMediaButtonDidTap(mediaView: VOYAddMediaView) {
        if let cameraData = mediaView.cameraData {
            for (index, value) in cameraDataList.enumerated() where value.id == cameraData.id {
                self.cameraDataList.remove(at: index)
                break
            }
            presenter.onCameraDataRemoved(cameraData)
        } else if let media = mediaView.media {
            for (index, value) in mediaList.enumerated() where value.id == media.id {
                mediaList.remove(at: index)
                break
            }
            presenter.onMediaRemoved(media)
        }
    }
}

extension VOYAddReportAttachViewController: VOYActionSheetViewControllerDelegate {

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
        } else {
            imagePickerController.mediaTypes = [kUTTypeImage as String]
        }
        present(imagePickerController, animated: true, completion: nil)
    }

    func cancelButtonDidTap(actionSheetViewController: VOYActionSheetViewController) {
        actionSheetViewController.close()
    }
}
