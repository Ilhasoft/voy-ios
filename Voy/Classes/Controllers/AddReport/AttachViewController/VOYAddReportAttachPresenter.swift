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
        let mediaList: [VOYMedia] = report.files ?? []
        let cameraDataList: [VOYCameraData] = report.cameraDataList ?? []
        view?.loadFromReport(mediaList: mediaList, cameraDataList: cameraDataList)
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
