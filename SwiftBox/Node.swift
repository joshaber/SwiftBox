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
	public let start: CGFloat
	public let end: CGFloat

	private var asTuple: (Float, Float, Float, Float, Float, Float) {
		return (Float(left), Float(top), Float(right), Float(bottom), Float(start), Float(end))
	}

	private var asCompactTuple: (Float, Float, Float, Float) {
		return (Float(left), Float(top), Float(right), Float(bottom))
	}

	public init(left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, top: CGFloat = 0, start: CGFloat = 0, end: CGFloat = 0) {
		self.left = left
		self.right = right
		self.bottom = bottom
		self.top = top
		self.start = start
		self.end = end
	}

	public init(uniform: CGFloat) {
		self.left = uniform
		self.right = uniform
		self.bottom = uniform
		self.top = uniform
		self.start = uniform
		self.end = uniform
	}
}

public enum FlexDirection: UInt32 {
	case Column = 0
	case ColumnReverse = 1
	case Row = 2
	case RowReverse = 3
}

public enum Justification: UInt32 {
	case FlexStart = 0
	case Center = 1
	case FlexEnd = 2
	case SpaceBetween = 3
	case SpaceAround = 4
}

public enum ChildAlignment: UInt32 {
	case FlexStart = 1
	case Center = 2
	case FlexEnd = 3
	case Stretch = 4
}

public enum SelfAlignment: UInt32 {
	case Auto = 0
	case FlexStart = 1
	case Center = 2
	case FlexEnd = 3
	case Stretch = 4
}

public enum Direction: UInt32 {
	case Inherit = 0
	case LeftToRight = 1
	case RightToLeft = 2
}

public enum PositionType: UInt32 {
	case Relative = 0
	case Absolute = 1
}

/// A node in a layout hierarchy.
public struct Node {
	/// Indicates that the value is undefined, for the flexbox algorithm to
	/// fill in.
	public static let Undefined: CGFloat = nan("SwiftBox.Node.Undefined")

	public let size: CGSize
	public let minSize: CGSize
	public let maxSize: CGSize
	public let children: [Node]
	public let flexDirection: FlexDirection
	public let direction: Direction
	public let margin: Edges
	public let padding: Edges
	public let border: Edges
	public let position: Edges
	public let wrap: Bool
	public let justification: Justification
	public let selfAlignment: SelfAlignment
	public let childAlignment: ChildAlignment
	public let contentAlignment: ChildAlignment
	public let flex: CGFloat
	public let positionType: PositionType
	public let measure: (CGFloat -> CGSize)?

	public init(size: CGSize = CGSize(width: Undefined, height: Undefined), minSize: CGSize = CGSize(width: 0, height: 0), maxSize: CGSize = CGSize(width: Undefined, height: Undefined), children: [Node] = [], flexDirection: FlexDirection = .Column, direction: Direction = .Inherit, margin: Edges = Edges(), padding: Edges = Edges(), border: Edges = Edges(), position: Edges = Edges(), wrap: Bool = false, justification: Justification = .FlexStart, selfAlignment: SelfAlignment = .Auto, childAlignment: ChildAlignment = .Stretch, contentAlignment: ChildAlignment = .Stretch, flex: CGFloat = 0, positionType: PositionType = .Relative, measure: (CGFloat -> CGSize)? = nil) {
		self.size = size
		self.minSize = minSize
		self.maxSize = maxSize
		self.children = children
		self.flexDirection = flexDirection
		self.direction = direction
		self.margin = margin
		self.padding = padding
		self.border = border
		self.position = position
		self.wrap = wrap
		self.justification = justification
		self.selfAlignment = selfAlignment
		self.childAlignment = childAlignment
		self.contentAlignment = contentAlignment
		self.flex = flex
		self.positionType = positionType
		self.measure = measure
	}

	private func createUnderlyingNode() -> NodeImpl {
		let node = NodeImpl()
		node.node.memory.style.dimensions = (Float(size.width), Float(size.height))
		node.node.memory.style.minDimensions = (Float(minSize.width), Float(minSize.height))
		node.node.memory.style.maxDimensions = (Float(maxSize.width), Float(maxSize.height))
		node.node.memory.style.margin = margin.asTuple
		node.node.memory.style.padding = padding.asTuple
		node.node.memory.style.border = border.asTuple
		node.node.memory.style.position = position.asCompactTuple
		node.node.memory.style.position_type = css_position_type_t(positionType.rawValue)
		node.node.memory.style.flex = Float(flex)
		node.node.memory.style.flex_direction = css_flex_direction_t(flexDirection.rawValue)
		node.node.memory.style.direction = css_direction_t(direction.rawValue)
		node.node.memory.style.flex_wrap = css_wrap_type_t(wrap ? 1 : 0)
		node.node.memory.style.justify_content = css_justify_t(justification.rawValue)
		node.node.memory.style.align_self = css_align_t(selfAlignment.rawValue)
		node.node.memory.style.align_items = css_align_t(childAlignment.rawValue)
		node.node.memory.style.align_content = css_align_t(contentAlignment.rawValue)
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
			node.layoutWithMaxWidth(maxWidth, parentDirection: node.node.memory.style.direction)
		} else {
			node.layout()
		}

		let children = createLayoutsFromChildren(node)
		return Layout(frame: node.frame, children: children)
	}
}

private func createLayoutsFromChildren(node: NodeImpl) -> [Layout] {
	return node.children.map {
		let child = $0 as! NodeImpl
		let frame = child.frame
		return Layout(frame: frame, children: createLayoutsFromChildren(child))
	}
}

public extension CGPoint {
	var isUndefined: Bool {
		return isnan(x) || isnan(y)
	}
}

public extension CGSize {
	var isUndefined: Bool {
		return isnan(width) || isnan(height)
	}
}

public extension CGRect {
	var isUndefined: Bool {
		return origin.isUndefined || size.isUndefined
	}
}
