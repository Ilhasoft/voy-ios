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
    
    init(report: VOYReport?, dataSource: VOYAddReportDataSource, view: VOYAddReportTagsContract) {
        self.report = report
        self.dataSource = dataSource
        self.view = view
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
        let location = "POINT(\(VOYLocationData.longitude) \(VOYLocationData.latitude))"
        report.location = location

        view?.showProgress()

        // TODO: separate this into its own method
        for cameraDataToRemove in report.removedCameraData {
            if let fileName = cameraDataToRemove.fileName,
                let filePath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(fileName) {
                VOYFileUtil.removeFile(URL(fileURLWithPath: filePath))
            }
            if let fileName = cameraDataToRemove.thumbnailFileName,
                let filePath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(fileName) {
                VOYFileUtil.removeFile(URL(fileURLWithPath: filePath))
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
}
