//
//  ParseWxOperation.swift
//  NSOp
//
//  Created by macbook on 4/7/19.
//  Copyright © 2019 jaminya. All rights reserved.
//

import Foundation

final class ParseWxOperation: BaseOperation {
    
    var rawWxData: Data? = nil
    private(set) var jsonData: Any? = nil
    
    
    override func main() {
        if isCancelled {
            completeOperation()
            return
        }
        print("ParseWxOperation")
        jsonData = decodeJson(inData: rawWxData)
        completeOperation()
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
}
