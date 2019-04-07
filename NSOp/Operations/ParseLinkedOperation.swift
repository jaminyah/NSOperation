//
//  ParseLinkedOperation.swift
//  NSOp
//
//  Created by macbook on 4/6/19.
//  Copyright © 2019 jaminya. All rights reserved.
//

import Foundation

final class ParseLinkedOperation: BaseOperation {

    private(set) var forecastUrl: URL? = nil
    var linkedData: Data? = nil
        
    override func main() {
        print("ParseLinkedOperation")
        
        var jsonData: Any? = nil
        
        if isCancelled {
            completeOperation()
            return
        }
        
        jsonData = decodeJson(inData: linkedData)
        guard let data = jsonData else { return }
        
        forecastUrl = parseLinkedJson(json: data)
        completeOperation()
        
        // Debug
        if let url = forecastUrl {
            print("forecastUrl: \(url)")
        } else {
            print("forecastUrl Error!")
        }

    }
    
    private func decodeJson(inData: Data?) -> Any? {
        var json: Any? = nil
        guard let data = inData else { return nil }
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: [])
            print(json!)
        } catch let jsonError {
            print(jsonError)
        }
        return json
    }
    
    private func parseLinkedJson(json: Any) -> URL? {
        var forecastLink: URL? = nil
        
        if let jsonParser = PointsJsonParser(JSON: json) {
            let urlString = jsonParser.forecastUrl
            forecastLink = URL(string: urlString)
        }
        return forecastLink
    }
}
