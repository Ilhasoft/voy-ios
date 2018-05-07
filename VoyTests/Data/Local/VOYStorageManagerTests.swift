//
//  VOYStorageManagerTests.swift
//  VoyTests
//
//  Created by Dielson Sales on 06/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYStorageManagerTests: XCTestCase {

    let storageManager: VOYStorageManager = VOYDefaultStorageManager()

    override func setUp() {
        super.setUp()
        storageManager.clearAllOfflineData()
    }

    func testSaveAndRemoveProjects() {
        let project = VOYProject()
        project.id = 24
        project.name = "Ilhasoft"

        storageManager.setProjects([project])
        var retrievedProjects = storageManager.getProjects()
        XCTAssertEqual(retrievedProjects.count, 1)
        XCTAssertEqual(retrievedProjects[0].id, Optional(24))
        XCTAssertEqual(retrievedProjects[0].name, Optional("Ilhasoft"))

        storageManager.setProjects([])
        retrievedProjects = storageManager.getProjects()
        XCTAssertEqual(retrievedProjects.count, 0)
    }

    func testSaveAndRemoveThemes() {
        let project = VOYProject()
        project.id = 24
        project.name = "Ilhasoft"

        let theme1 = VOYTheme()
        theme1.id = 466
        theme1.name = "Theme1"
        theme1.description = "Theme created for a test"
        theme1.tags = ["tag1", "tag2"]
        theme1.color = "62ae7e"

        let theme2 = VOYTheme()
        theme2.id = 467
        theme2.name = "Theme2"
        theme2.description = "Another description"
        theme2.tags = ["tag3", "tag4"]
        theme2.color = "d6bd7d"

        storageManager.setThemes(forProject: project, [theme1, theme2])
        var retrievedThemes = storageManager.getThemes(forProject: project)
        XCTAssertEqual(retrievedThemes.count, 2)
        XCTAssertEqual(retrievedThemes[0].id, Optional(466))
        XCTAssertEqual(retrievedThemes[0].name, Optional("Theme1"))
        XCTAssertEqual(retrievedThemes[0].description, Optional("Theme created for a test"))
        XCTAssertEqual(retrievedThemes[0].tags, Optional(["tag1", "tag2"]))
        XCTAssertEqual(retrievedThemes[0].color, Optional("62ae7e"))

        XCTAssertEqual(retrievedThemes[1].id, Optional(467))
        XCTAssertEqual(retrievedThemes[1].name, Optional("Theme2"))
        XCTAssertEqual(retrievedThemes[1].description, Optional("Another description"))
        XCTAssertEqual(retrievedThemes[1].tags, Optional(["tag3", "tag4"]))
        XCTAssertEqual(retrievedThemes[1].color, Optional("d6bd7d"))
    }

    /**
     * Saves a report and checks if it's actually stored in the pending list. Then removes it and checks if it has been
     * actually removed.
     */
    func testSaveAndRemoveReport() {
        let report = VOYReport()
        report.id = 20
        report.name = "Test Report"

        // Test save the report
        storageManager.addPendingReport(report)
        XCTAssertEqual(storageManager.getPendingReports().count, 1)

        // Checks if the report was stored offline
        let savedReport = storageManager.getPendingReports().first!
        let reportId = savedReport["id"] as! Int
        let reportName = savedReport["name"] as! String
        XCTAssertEqual(reportId, report.id!)
        XCTAssertEqual(reportName, report.name!)

        // Overrides the report with a new value
        report.name = "Changed name"
        storageManager.addPendingReport(report)
        XCTAssertEqual(storageManager.getPendingReports().count, 1)
        let savedReport2 = storageManager.getPendingReports().first!
        let changedReportName = savedReport2["name"] as! String
        XCTAssertEqual(reportId, report.id!)
        XCTAssertEqual(changedReportName, report.name!)

        storageManager.removePendingReport(report: report)
        XCTAssertEqual(storageManager.getPendingReports().count, 0)
    }

    func testSaveAndRemoveCameraData() {
        let cameraData = VOYCameraData(
                image: nil,
                thumbnail: nil,
                thumbnailFileName: "thumbnail.jpg",
                fileName: "image.jpg",
                type: .image
        )
        cameraData.id = "040"

        // Checks if the cameraData was stored offline
        storageManager.addPendingCameraData(cameraData: cameraData, reportID: 20)
        XCTAssertEqual(storageManager.getPendingCameraData().count, 1)
        let savedCameraData = storageManager.getPendingCameraData().first!
        XCTAssertEqual(savedCameraData["id"] as! String, cameraData.id!)
        XCTAssertEqual(savedCameraData["path"] as! String, cameraData.fileName!)
        XCTAssertEqual(savedCameraData["thumbnailPath"] as! String, cameraData.thumbnailFileName!)

        // Overrides the cameraData with a chaged value
        cameraData.fileName = "image_changed.jpg"
        storageManager.addPendingCameraData(cameraData: cameraData, reportID: 20)
        XCTAssertEqual(storageManager.getPendingCameraData().count, 1)
        let savedCameraData2 = storageManager.getPendingCameraData().first!
        XCTAssertEqual(savedCameraData2["path"] as! String, cameraData.fileName!)
    }
}
