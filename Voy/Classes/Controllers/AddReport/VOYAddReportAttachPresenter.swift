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
    var report: VOYReport?
    var locationManager: VOYLocationManager!

    init(view: VOYAddReportAttachContract, report: VOYReport? = nil) {
        self.view = view
        locationManager = VOYLocationManager(delegate: self)
        locationManager.getCurrentLocation()
        if let theme = VOYTheme.activeTheme() {
            validateDateLimit(theme: theme)
        }
    }

    func validateDateLimit(theme: VOYTheme) {
        if let startAt = theme.start_at, let endAt = theme.end_at {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "UTC")
            
            if let startDate = dateFormatter.date(from: startAt), let endDate = dateFormatter.date(from: endAt) {
                let currentDate = Date()
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
        
        let alertViewController = VOYAlertViewController(
            title: localizedString(.alert),
            message: alertText
        )
        alertViewController.view.tag = 1
        view?.showAlert(alert: alertViewController)
    }
    
    func onNextButtonTapped() {
        view?.navigateToNextScreen()
    }
}

extension VOYAddReportAttachPresenter: VOYLocationManagerDelegate {
    func didGetUserLocation(latitude: Float, longitude: Float, error: Error?) {
        guard let theme = VOYTheme.activeTheme() else {
            #if DEBUG
                fatalError("VOYTheme.activeTheme is null")
            #else
                return
            #endif
        }

        view?.stopAnimating()
        let myLocation = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(latitude),
            longitude: CLLocationDegrees(longitude)
        )

        var loctionCoordinate2dList = [CLLocationCoordinate2D]()
        for point in theme.bounds {
            let locationCoordinate2D = CLLocationCoordinate2D(latitude: point[0], longitude: point[1])
            loctionCoordinate2dList.append(locationCoordinate2D)
        }

        let statePolygonRenderer = MKPolygonRenderer(polygon:
            MKPolygon(coordinates: loctionCoordinate2dList, count: loctionCoordinate2dList.count)
        )
        let testMapPoint: MKMapPoint = MKMapPointForCoordinate(myLocation)
        let statePolygonRenderedPoint: CGPoint = statePolygonRenderer.point(for: testMapPoint)
        let intersects: Bool = statePolygonRenderer.path.contains(statePolygonRenderedPoint)

        if !intersects {
            view?.showOutsideThemeBoundsError()
        }
    }

    func userDidntGivePermission() {
        view?.stopAnimating()
        view?.showGpsPermissionError()
    }
}
