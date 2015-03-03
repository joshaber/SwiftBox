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
					direction: .Row,
                    children: [
			Node(flex: 75,
                 margin: Edges(left: 10, right: 10),
                 size: CGSize(width: 0, height: 100)),
			Node(flex: 15,
				 margin: Edges(right: 10),
                 size: CGSize(width: 0, height: 50)),
			Node(flex: 10,
				 margin: Edges(right: 10),
				 size: CGSize(width: 0, height: 180)),
		])

		let layout = parent.layout()
		XCTAssert("\(layout)".utf16Count > 0, "Has a description.")
    }

	func testSizeParentBasedOnChildren() {
		let parent = Node(children: [
			Node(size: CGSize(width: 100, height: 200)),
			Node(size: CGSize(width: 300, height: 150)),
		])

		let layout = parent.layout()
		XCTAssertEqual(layout.frame.size.width, CGFloat(300));
		XCTAssertEqual(layout.frame.size.height, CGFloat(350));
	}
}
