# ⭕ Circular Animation
![](https://media.giphy.com/media/1UX5ssfrxGqoMClh3C/giphy.gif)
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
