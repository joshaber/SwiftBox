//
//  Layout+View.swift
//  SwiftBox
//
//  Created by Josh Abernathy on 2/1/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

import Foundation

#if os(iOS)
	public typealias ViewType = UIView
#else
	public typealias ViewType = NSView
#endif

extension Layout {
	/// Apply the layout to the given view hierarchy.
	public func apply(view: ViewType) {
		node.layout()
		applyRecursively(view, node: node)
	}

	private func applyRecursively(view: ViewType, node: NodeImpl) {
		view.frame = CGRectIntegral(node.frame)

		for (s, n) in Zip2(view.subviews, node.children) {
			let subview = s as NSView
			let childNode = n as NodeImpl
			applyRecursively(subview, node: childNode)
		}
	}
}
