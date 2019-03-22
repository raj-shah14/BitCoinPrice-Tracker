//
//  Formatter.swift
//  BitcoinTicker
//
//  Created by Raj on 3/22/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation
import UIKit
import Charts

class Formatter:NSObject,IAxisValueFormatter{
    var xvalues: [String]! = ["Year","6 Months","3 Months","Month","Week","Today"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xvalues[Int(value)]
    }
    
    
}
