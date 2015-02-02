# SwiftBox

A Swift wrapper around Facebook's [implementation](https://github.com/facebook/css-layout) of CSS's flexbox.

## Example

```swift

let parent = Layout(size: CGSize(width: 300, height: 300),
                    childAlignment: .Center,
                    children: [
	Layout(flex: 75,
           margin: Edges(left: 10, right: 10),
           size: CGSize(width: 0, height: 100)),
	Layout(flex: 25,
           size: CGSize(width: 0, height: 50)),
])

parent.layout()
println(parent)

// {{0, 0}, {300, 300}}
//	[{{10, 100}, {210, 100}}
//	, {{230, 125}, {70, 50}}
//	]
```

Alternatively, you could apply the layout to a view hierarchy (after ensuring Auto Layout is off):

```swift
parent.apply(someView)
```
