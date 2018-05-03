//
//  VOYReportListPresenter.swift
//  Voy
//
//  Created by Dielson Sales on 09/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

enum VOYAddReportErrorType {
    case willStart
    case ended
    case outOfBouds

    func getMessage() -> String {
        var alertText: String = ""
        switch self {
        case .willStart:
            alertText = localizedString(.weArePreparingThisTheme)
        case .ended:
            alertText = localizedString(.periodForReportEnded)
        case .outOfBouds:
            alertText = localizedString(.outsideThemesBounds)
        }
        return alertText
    }
}

class VOYReportListPresenter {

    private weak var view: VOYReportListContract?
    private var dataSource: VOYReportListDataSource!
    var countApprovedReports: Int?
    var countPendingReports: Int?
    var countNotApprovedReports: Int?

    var locationManager: VOYLocationManager!

    init(view: VOYReportListContract, dataSource: VOYReportListDataSource, locationManager: VOYLocationManager) {
        self.view = view
        self.dataSource = dataSource
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }

    func onAddReportAction() {
        guard let theme = VOYTheme.activeTheme() else { return }
        if let error = getDateError(theme: theme, currentDate: Date()) {
            view?.showAlert(text: error.getMessage())
        } else {
            view?.showProgress()
            locationManager.getCurrentLocation()
        }
    }

    func onReportSelected(object: [String: Any]) {
        if let report = VOYReport(JSON: object) {
            view?.navigateToReportDetails(report: report)
        }
    }

    func countReports(themeId: Int, status: VOYReportStatus, mapper: Int) {
        switch status {
        case .approved:
            dataSource.getReportCount(themeId: themeId, status: status, mapper: mapper) { count, _ in
                self.countApprovedReports = count
            }
        case .pendent:
            dataSource.getReportCount(themeId: themeId, status: status, mapper: mapper) { count, _ in
                self.countPendingReports = count
            }
        case .notApproved:
            dataSource.getReportCount(themeId: themeId, status: status, mapper: mapper) { count, _ in
                self.countNotApprovedReports = count
            }
        }
    }

    // MARK: Private methods

    private func getDateError(theme: VOYTheme, currentDate: Date) -> VOYAddReportErrorType? {
        guard var startAt = theme.start_at, var endAt = theme.end_at else { return nil } // No errors here
        startAt = "\(startAt) 00:00"
        endAt = "\(endAt) 23:59"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "UTC")

        guard let startDate = dateFormatter.date(from: startAt),
            let endDate = dateFormatter.date(from: endAt) else { return nil }

        if startDate >= currentDate || endDate <= currentDate {
            return (startDate >= currentDate) ? .willStart : .ended
        } else {
            return nil
        }
    }
}

extension VOYReportListPresenter: VOYLocationManagerDelegate {
    func didGetUserLocation(latitude: Float, longitude: Float, error: Error?) {
        guard let theme = assertExists(optionalVar: VOYTheme.activeTheme()) else {
            return
        }

        let myLocation = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(latitude),
            longitude: CLLocationDegrees(longitude)
        )

        var locationCoordinate2dList = [CLLocationCoordinate2D]()
        for point in theme.bounds {
            let locationCoordinate2D = CLLocationCoordinate2D(latitude: point[0], longitude: point[1])
            locationCoordinate2dList.append(locationCoordinate2D)
        }

        let statePolygonRenderer = MKPolygonRenderer(polygon:
            MKPolygon(coordinates: locationCoordinate2dList, count: locationCoordinate2dList.count)
        )
        let testMapPoint: MKMapPoint = MKMapPointForCoordinate(myLocation)
        let statePolygonRenderedPoint: CGPoint = statePolygonRenderer.point(for: testMapPoint)
        let intersects: Bool = statePolygonRenderer.path.contains(statePolygonRenderedPoint)

        view?.hideProgress()

        if !intersects {
            view?.showAlert(text: localizedString(.outsideThemesBounds))
        } else {
            view?.navigateToAddReport()
        }
    }

    func userDidntGivePermission() {
        view?.hideProgress()
        view?.showGpsPermissionError()
    }
}
