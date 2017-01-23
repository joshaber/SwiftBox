//
//  Node.swift
//  SwiftBox
//
//  Created by Josh Abernathy on 2/6/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

import Foundation

public struct Edges {
	public let left: CGFloat
	public let right: CGFloat
	public let bottom: CGFloat
	public let top: CGFloat

	fileprivate var asTuple: (Float, Float, Float, Float) {
		return (Float(left), Float(top), Float(right), Float(bottom))
	}

	public init(left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, top: CGFloat = 0) {
		self.left = left
		self.right = right
		self.bottom = bottom
		self.top = top
	}

	public init(uniform: CGFloat) {
		self.left = uniform
		self.right = uniform
		self.bottom = uniform
		self.top = uniform
	}
}

public enum Direction: UInt32 {
	case column = 0
	case row = 1
}

public enum Justification: UInt32 {
	case flexStart = 0
	case center = 1
	case flexEnd = 2
	case spaceBetween = 3
	case spaceAround = 4
}

public enum ChildAlignment: UInt32 {
	case flexStart = 1
	case center = 2
	case flexEnd = 3
	case stretch = 4
}

public enum SelfAlignment: UInt32 {
	case auto = 0
	case flexStart = 1
	case center = 2
	case flexEnd = 3
	case stretch = 4
}

/// A node in a layout hierarchy.
public struct Node {
	/// Indicates that the value is undefined, for the flexbox algorithm to
	/// fill in.
	public static let Undefined: CGFloat = nan("SwiftBox.Node.Undefined")

	public let size: CGSize
	public let children: [Node]
	public let direction: Direction
	public let margin: Edges
	public let padding: Edges
	public let wrap: Bool
	public let justification: Justification
	public let selfAlignment: SelfAlignment
	public let childAlignment: ChildAlignment
	public let flex: CGFloat
	public let measure: ((CGFloat) -> CGSize)?

	public init(size: CGSize = CGSize(width: Undefined, height: Undefined), children: [Node] = [], direction: Direction = .column, margin: Edges = Edges(), padding: Edges = Edges(), wrap: Bool = false, justification: Justification = .flexStart, selfAlignment: SelfAlignment = .auto, childAlignment: ChildAlignment = .stretch, flex: CGFloat = 0, measure: ((CGFloat) -> CGSize)? = nil) {
		self.size = size
		self.children = children
		self.direction = direction
		self.margin = margin
		self.padding = padding
		self.wrap = wrap
		self.justification = justification
		self.selfAlignment = selfAlignment
		self.childAlignment = childAlignment
		self.flex = flex
		self.measure = measure
	}

	fileprivate func createUnderlyingNode() -> NodeImpl {
		let node = NodeImpl()
		node.node.pointee.style.dimensions = (Float(size.width), Float(size.height))
		node.node.pointee.style.margin = margin.asTuple
		node.node.pointee.style.padding = padding.asTuple
		node.node.pointee.style.flex = Float(flex)
		node.node.pointee.style.flex_direction = css_flex_direction_t(direction.rawValue)
		node.node.pointee.style.flex_wrap = css_wrap_type_t(wrap ? 1 : 0)
		node.node.pointee.style.justify_content = css_justify_t(justification.rawValue)
		node.node.pointee.style.align_self = css_align_t(selfAlignment.rawValue)
		node.node.pointee.style.align_items = css_align_t(childAlignment.rawValue)
		if let measure = measure {
			node.measure = measure
		}
		node.children = children.map { $0.createUnderlyingNode() }
		return node
	}

	/// Lay out the receiver and all its children with an optional max width.
    public func layout(maxWidth: CGFloat? = nil) -> Layout {
		let node = createUnderlyingNode()
		if let maxWidth = maxWidth {
			node.layout(withMaxWidth: maxWidth)
		} else {
			node.layout()
		}

		let children = createLayoutsFromChildren(node)
		return Layout(frame: node.frame, children: children)
	}
}

private func createLayoutsFromChildren(_ node: NodeImpl) -> [Layout] {
	return node.children.map {
		let child = $0 as! NodeImpl
		let frame = child.frame
		return Layout(frame: frame, children: createLayoutsFromChildren(child))
	}
}

public extension CGPoint {
	var isUndefined: Bool {
		return x.isNaN || y.isNaN
	}
}

public extension CGSize {
	var isUndefined: Bool {
		return width.isNaN || height.isNaN
	}
}

public extension CGRect {
	var isUndefined: Bool {
		return origin.isUndefined || size.isUndefined
	}
}
