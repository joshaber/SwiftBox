# SwiftBox

A Swift wrapper around Facebook's [implementation](https://github.com/facebook/css-layout) of CSS's flexbox.

This is just the core layout logic. This doesn't interaction directly with the view layer at all.

## Example

```swift

let parent = Layout(size: CGSize(width: 300, height: 300),
                    childAlignment: .Center,
                    children: [
	Layout(flex: 75,
           margin: Edges(left: 10, right: 10, top: 0, bottom: 0),
           size: CGSize(width: 0, height: 100)),
	Layout(flex: 25,
           size: CGSize(width: 0, height: 50)),
])

```
