//
//  SwiftBoxTests.swift
//  SwiftBoxTests
//
//  Created by Josh Abernathy on 2/1/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftBox

class SwiftBoxTests: XCTestCase {
    func testDescription() {
		let parent = Node(size: CGSize(width: 300, height: 300),
                    childAlignment: .Center,
                    children: [
			Node(flex: 75,
                 margin: Edges(left: 10, right: 10, top: 0, bottom: 0),
                 size: CGSize(width: 0, height: 100)),
			Node(flex: 25,
                 size: CGSize(width: 0, height: 50)),
		])

		let layout = parent.layout()
		XCTAssert("\(layout)".utf16Count > 0, "Has a description.")
    }
}
