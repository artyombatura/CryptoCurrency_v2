//
//  ChartData.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/13/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ChartData {
    
    var time: Double = 0.0
    var value: Double = 0.0
    
    init(time: Double, value: Double) {
        self.time = time
        self.value = value
    }
    
    init() {
        
    }
    
    static func getDataArray(fromJSON json: JSON) -> [ChartData] {
        var chartDataArray = [ChartData]()
        let dataArray = json[0]["Data"]["Data"].array
        
        if let dataArrayUnwrapped = dataArray {
            for data in dataArrayUnwrapped {
                let chartData = ChartData()
                if let time = data["time"].double {
                    chartData.time = time
                }
                if let value = data["high"].double {
                    chartData.value = value
                }
                chartDataArray.append(chartData)
            }
        }
        
        return chartDataArray
    }
}
