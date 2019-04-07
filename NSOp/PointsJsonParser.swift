//
//  PointsJsonParser.swift
//  NSOp
//
//  Created by macbook on 4/6/19.
//  Copyright © 2019 jaminya. All rights reserved.
//

import Foundation

struct PointsJsonParser: JSONDecodable {
    private (set) var forecastUrl: String = ""
    //private (set) var forecastHourlyUrl: String = ""
    private (set) var zoneUrl: String = ""
    
    init?(JSON: Any) {
        guard let JSON = JSON as?  [String: AnyObject] else { return nil }
        
        if let link = JSON["properties"]?["forecast"] as? String { self.forecastUrl = link }
        if let zone = JSON["properties"]?["forecastZone"] as? String {self.zoneUrl = zone}
    }
}
