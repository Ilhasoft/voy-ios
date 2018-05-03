//
//  VOYAddReportTagsPresenter.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYAddReportTagsPresenter {
    var dataSource: VOYAddReportDataSource!
    var view: VOYAddReportTagsContract?
    private var report: VOYReport?
    private var locationManager: VOYLocationManager!

    init(report: VOYReport?, dataSource: VOYAddReportDataSource, view: VOYAddReportTagsContract, locationManager: VOYLocationManager) {
        self.report = report
        self.dataSource = dataSource
        self.view = view
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }

    func onViewDidLoad() {
        guard let activeTheme = assertExists(optionalVar: VOYTheme.activeTheme()) else { return }
        let selectedTags = report?.tags ?? []
        view?.loadTags(themeTags: activeTheme.tags.sorted(), selectedTags: selectedTags)
    }

    func saveReport(selectedTags: [String]) {
        guard let report = self.report, let activeTheme = VOYTheme.activeTheme() else { return }
        report.tags = selectedTags
        report.theme = activeTheme.id

        view?.showProgress()
        locationManager.getCurrentLocation()
    }
}

extension VOYAddReportTagsPresenter: VOYLocationManagerDelegate {
    func didGetUserLocation(latitude: Float, longitude: Float, error: Error?) {
        guard let report = self.report else { return }

        report.location = "POINT(\(longitude) \(latitude))"

        // TODO: separate this into its own method
        for cameraDataToRemove in report.removedCameraData {
            if let fileName = cameraDataToRemove.fileName {
                VOYFileUtil.removeFile(with: fileName)
            }
            if let fileName = cameraDataToRemove.thumbnailFileName {
                VOYFileUtil.removeFile(with: fileName)
            }
            if var cameraDataList = report.cameraDataList {
                let indexToRemove = cameraDataList.index(where: {
                    if let fileName = $0.fileName, fileName == cameraDataToRemove.fileName {
                        return true
                    }
                    return false
                })
                if let indexToRemove = indexToRemove {
                    cameraDataList.remove(at: indexToRemove)
                }
                report.cameraDataList = cameraDataList
            }
        }
        report.removedCameraData.removeAll()

        dataSource.saveLocal(report: report)

        self.view?.dismissProgress()
        self.view?.navigateToSuccessScreen()
    }

    func userDidntGivePermission() {
        // This can be safely ignored, but do we have to consider the case where the user removes the permission while
        // the app is running?
    }
}
