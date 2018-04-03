//
//  VOYAddReportDataSource.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYAddReportDataSource {
    func save(report: VOYReport, completion: @escaping(Error?, Int?) -> Void)
    func saveLocal(report: VOYReport)
}
