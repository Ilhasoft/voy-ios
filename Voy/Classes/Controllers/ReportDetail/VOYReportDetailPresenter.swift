//
//  VOYReportDetailPresenter.swift
//  Voy
//
//  Created by Dielson Sales on 13/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYReportDetailPresenter {

    private weak var view: VOYReportDetailContract?
    private var report: VOYReport!
    
    init(view: VOYReportDetailContract, report: VOYReport) {
        self.view = view
        self.report = report
    }
    
    func onCommentButtonTapped() {
        view?.navigateToCommentsScreen(report: report)
    }
    
    func onShareButtonTapped() {
        guard let reportId = self.report.id else { return }
        // TODO: make this translatable
        let textToShare = "Hello, I reported a problem in this region, take a look: https://voy-dev.ilhasoft.mobi/project/Ilhasoft/report/\(reportId)"
        view?.shareText(textToShare)
    }
    
    func onTapImage(image: UIImage?) {
        if let image = image {
            view?.showPictureScreen(image: image)
        }
    }
    
    func onTapVideo(videoURL: URL) {
        view?.showVideoScreen(videoURL: videoURL)
    }

}
