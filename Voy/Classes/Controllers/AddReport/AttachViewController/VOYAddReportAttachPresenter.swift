//
//  VOYAddReportAttachPresenter.swift
//  Voy
//
//  Created by Dielson Sales on 15/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

enum VOYAddReportErrorType {
    case willStart
    case ended
    case outOfBouds
}

class VOYAddReportAttachPresenter {

    weak var view: VOYAddReportAttachContract?
    var report: VOYReport
    var locationManager: VOYLocationManager!

    init(view: VOYAddReportAttachContract, report: VOYReport = VOYReport()) {
        self.view = view
        self.report = report
        locationManager = VOYDefaultLocationManager(delegate: self)
        locationManager.getCurrentLocation()
    }

    func onViewDidLoad() {
        if let theme = VOYTheme.activeTheme() {
            validateDateLimit(theme: theme, currentDate: Date())
        }
        if let mediaList = report.files {
            view?.loadFromReport(mediaList: mediaList)
        } else if let cameraDataList = report.cameraDataList {
            view?.loadFromReport(cameraDataList: cameraDataList)
        }
    }

    func validateDateLimit(theme: VOYTheme, currentDate: Date) {
        if var startAt = theme.start_at, var endAt = theme.end_at {
            startAt = "\(startAt) 00:00"
            endAt = "\(endAt) 23:59"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "UTC")

            if let startDate = dateFormatter.date(from: startAt), let endDate = dateFormatter.date(from: endAt) {
                if startDate >= currentDate || endDate <= currentDate {
                    (startDate >= currentDate) ? showAlert(alert: .willStart) : showAlert(alert: .ended)
                }
            }
        }
    }

    func showAlert(alert: VOYAddReportErrorType) {
        var alertText: String = ""
        switch alert {
        case .willStart:
            alertText = localizedString(.weArePreparingThisTheme)
        case .ended:
            alertText = localizedString(.periodForReportEnded)
        case .outOfBouds:
            alertText = localizedString(.outsideThemesBounds)
        }
        view?.showAlert(text: alertText)
    }

    func onNextButtonTapped() {
        view?.navigateToNextScreen(report: report)
    }

    func onCameraDataRemoved(_ cameraData: VOYCameraData) {
        report.removedCameraData.append(cameraData)
    }

    func onMediaRemoved(_ media: VOYMedia) {
        if var removedMedias = report.removedMedias {
            removedMedias.append(media)
        } else {
            report.removedMedias = [ media ]
        }
    }
}

extension VOYAddReportAttachPresenter: VOYLocationManagerDelegate {
    func didGetUserLocation(latitude: Float, longitude: Float, error: Error?) {
        guard let theme = assertExists(optionalVar: VOYTheme.activeTheme()) else {
            return
        }

        view?.stopAnimating()
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

        if !intersects {
            view?.showAlert(text: localizedString(.outsideThemesBounds))
        }
    }

    func userDidntGivePermission() {
        view?.stopAnimating()
        view?.showGpsPermissionError()
    }
}
