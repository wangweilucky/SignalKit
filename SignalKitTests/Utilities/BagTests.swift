//
//  BagTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class BagTests: XCTestCase {
    
    func testInsertItem() {
        
        var bag = Bag<Int>()
        
        let token = bag.insertItem(1)
        
        let item = bag.items[token]
        
        XCTAssertEqual(bag.items.count, 1, "Should insert an item")
        XCTAssertEqual(item, 1, "Should contain the inserted item")
        XCTAssertNotEqual(token, "", "Should return a removal token")
    }
    
    func testProduceRemovalTokens() {
        
        var bag = Bag<Int>()
        var token = ""
        let expectedToken = "10"
        
        for i in 0..<10 {
            
            token = bag.insertItem(i)
        }
        
        XCTAssertEqual(token, expectedToken, "Should produce incremental removal tokens")
    }
    
    func testProduceSequenceOfRemovalTokens() {
        
        var bag = Bag<Int>()
        var token = ""
        let expectedToken = "\(UInt16.max)123"
        let elementsCount = Int(UInt16.max) + 123
        
        for i in 0..<elementsCount {
            
            token = bag.insertItem(i)
        }
        
        XCTAssertEqual(token, expectedToken, "Should produce a sequence of removal tokens")
    }
}
