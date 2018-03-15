//
//  VOYReportListDataSource.swift
//  Voy
//
//  Created by Rubens Pessoa on 15/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Foundation

protocol VOYReportListDataSource {
    func getReportCount(themeId: Int, status: VOYReportStatus, mapper: Int, completion: @escaping (Int?, Error?) -> ())
}
