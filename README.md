# ⭕ Circular Animation
![](https://media.giphy.com/media/7NOuHho49iyuVcxoDb/giphy.gif)

## Properties:
- **`views`**: Array of views to be animated.
- **`radius`**: Virtual circle radius, which views will animate around its center.
- **`origin`**: Virtual circle center.
- **`sourceAngle`**: Angle which views start animating from, measured in **degrees**.
  - Valid value must lay in range **[0, 360]**.
- **`startAngle`**: The beginning angle which views distribute themselves starting from it, measured in **degrees**.
  - Valid value must lay in range **[0, 360]**.
- **`degrees`**: Amount of degrees used to distribute views within them starting from `startAngle`.
  - Valid value must lay in range **[-360, 360]**.
  - Positive value will result in a **clockwise** animation.
  - Negative value will result in a **counter-clockwise** animation.
- **`fullCircle`**: Indicates whether the final shape is meant to be a full circle or not.
  - Generally, mark it as `true` if both first and last views overlap on each other.
- **`duration`**: Duration of animation for each view in **seconds**.
- **`delay`**: The delay between animating views in **seconds**.
- **`timingFunction`**: A timing function defining the pacing of the animation.
  - Default value is `CircularAnimation.TimingFunction.easeOutQuint()`.
- **`animatingOrder`**: The order which views will be animated in.
  - Default value is `CircularAnimation.AnimatingOrder.default`.
  - Using `.reversed` order will result in animating the last view in `views` array first,
  then the view which precedes it, and so on. Alternating between `.default` and `.reversed` will change only
  the order of animations execution, not their locations on screen.

## Methods:
- **`animate`**: This method starts the animation, and it accepts two parameters:
  - `mode: CircularAnimation.Mode`: Indicates the animation mode.
    - `.enter` mode will animate the views starting from the source location to their final locations.
    - `.exit` mode will animate the views back to the source location.
    - `.exit` mode **doesn't** rely on `.enter` mode to be executed first.
  - `options: CircularAnimation.Options?`: Provide this parameter to override temporarily
  the current animation properties with the provided ones in `options` object.
  Its default value is `nil`.

## Usage Example:
```swift
let animation = CircularAnimation()
animation.views.append(movingView)
animation.views.append(movingView2)
animation.views.append(movingView3)
animation.views.append(movingView4)
animation.views.append(movingView5)
animation.origin = CGPoint(x: 50, y: view.bounds.height / 2)
animation.radius = Float(self.view.bounds.width / 2)
animation.duration = 0.8
animation.delay = 0.1

animation.sourceAngle = 240
animation.startAngle = 60
animation.degrees = -130
animation.animatingOrder = .reversed

// Uncomment code blocks to test different variations

/*
animation.sourceAngle = 120
animation.startAngle = 290
animation.degrees = 130
animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
*/

/*
animation.origin = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
animation.radius = Float(self.view.bounds.width / 3 - 40)
animation.sourceAngle = 0
animation.startAngle = 0
animation.degrees = 360
animation.fullCircle = true
animation.timingFunction = CircularAnimation.TimingFunction.easeOutExpo()
*/

animation.animate(mode: .enter)
```
