//
//  ViewController.swift
//  NSOp
//
//  Created by macbook on 4/5/19.
//  Copyright © 2019 jaminya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        executeOps()
    }
    
    func executeOps() -> Void {
        
        let queue = OperationQueue()
        var operations: [Operation] = []
        
        var fetchLinkedOp: FetchLinkedOperation
        let parseLinkedOp = ParseLinkedOperation()
        let fetchWxOp = FetchWxOperation()
        let parseWxOp = ParseWxOperation()
        
        queue.maxConcurrentOperationCount = 1
        
        let urlString = "http://cdn.jaminya.com/json/links_akq.json"
        //let urlString = "https://api.weather.gov/points/36.9751,-76.3496"
        
        if let url = URL(string: urlString) {
            fetchLinkedOp = FetchLinkedOperation(withLink: url)
        } else {
            print("There is fetchLinked error.")
            return
        }
        
        let adapter = BlockOperation() { [unowned fetchLinkedOp, unowned parseLinkedOp] in
            parseLinkedOp.linkedData = fetchLinkedOp.linkedData
        }
        
        // Dependencies
        adapter.addDependency(fetchLinkedOp)
        parseLinkedOp.addDependency(adapter)
        
        let adapter2 = BlockOperation() { [unowned parseLinkedOp, unowned fetchWxOp] in
            fetchWxOp.forecastUrl = parseLinkedOp.forecastUrl
        }
        
        adapter2.addDependency(parseLinkedOp)
        fetchWxOp.addDependency(adapter2)
        
        let adapter3 = BlockOperation() { [unowned fetchWxOp, unowned parseWxOp] in
            parseWxOp.rawWxData = fetchWxOp.rawWxData
        }
        
        adapter3.addDependency(fetchWxOp)
        parseWxOp.addDependency(adapter3)
        
        operations = [fetchLinkedOp, adapter, parseLinkedOp, adapter2, fetchWxOp, adapter3, parseWxOp]
        queue.addOperations(operations, waitUntilFinished: true)
        print("Operations complete.")
    }
}
