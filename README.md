# LightRoute
[![Pod version](https://badge.fury.io/co/LightRoute.svg)](https://badge.fury.io/co/LightRoute)

## Description
LightRoute is easy transition between VIPER modules, who implemented on pure Swift.
We can transition between your modules very easy from couple lines of codes.

## Install
**CocoaPods**

Add to your podfile:

```ruby
pod "LightRoute"
```

## Example

For example, we will make the transition between the two VIPER modules.

```swift
import LightRoute

// MARK: - The module initiating the transition.

protocol FirstViperRouterInput: class {
  func openModule(userIdentifier: String)
}

final class FirstViperRouter: FirstViperRouterInput {

  // This property contain protocol protected view controller for transition.
  weak var transitionHandler: TransitionHandler!

  // View controller identifier for current storyboard.
  let viewControllerIdentifier = "SecondViperViewController"


  func openModule(userIdentifier: String) {

      transitionHandler
				
      // Initiates the opening of a new view controller.
      .forCurrentStoryboard(resterationId: viewControllerIdentifier, to: SecondViperViewControllerModuleInput.self)
				
      // Set animate for transition.
      .transition(animate: false)

      // Set transition case.
      .to(preffered: TransitionStyle.navigationController(prefferedStyle: .push))

      // View controller init block. 
      .then { moduleInput in 
        moduleInput.configure(with: userIdentifier)
      }
  }
} 

// MARK: - The module at which the jump occurs.

// Module input protocol for initialize
protocol SecondViperViewControllerModuleInput: class {
  func configure(with userIdentifier: String)
}


final class SecondViperPresenter: SecondViperViewControllerModuleInput, ... {
	
  // Implementation protocol
  func configure(with userIdentifier: String) {
		print("User identifier", userIdentifier) // Print it!
    // Initialize code..
  }

}
```

## About this

LightRoute can work with `Segue`, `UINavigationController` and default view controller presenting.

For all transition, returns main `TransitionPromise` class, who managed current transition. You can change transition flow, how you want.

## Transition case 
For example we analyze this code, then contain two case for work with transition:


**First case:**

This default case, with default LightRoute implementation. If you want just present new module, then use that:

```swift

transitionHandler

// Initiates the opening of a new view controller.
.forCurrentStoryboard(resterationId: viewControllerIdentifier, to: SecondViperViewControllerModuleInput.self)

// Setup module input.
.then { moduleInput in 
  moduleInput.configure(with: "Hello!")
}

```


**Second case:**

But first way can't be flexible, for that has `customTransition()` method. This method returns `CustomTransitionPromise`, who can't be changed with `TransitionPromise` ways. 
CustomTransitionPromise is class, who return method flexible settings your transition, but for this transition flow, you should be implement your transition logic, and call `them(_:)` or `push()` method for activate transition.

Example:

```swift

transitionHandler

// Initiates the opening of a new view controller.
.forCurrentStoryboard(resterationId: viewControllerIdentifier, to: SecondViperViewControllerModuleInput.self)

// Activate custom transition.
.customTransition()

// Custom transition case.
// REMEBER, that flow is protected and can't be changed :)
.transition { source, destination in 
  // Implement here your transition logic, like that:
	// source.present(destination, animated: true, completion: nil)
}

// Setup module input.
.then { moduleInput in 
  moduleInput.configure(with: "Hello custom transition!")
}

```

## Customize transition

For customize your transition you can change transition presentation and set animation.

**Animate transition**

This methods can animete your current transition, if transition flow not protected.

```swift
transition(animate: false)
```

**Change presentation**

For this there is method `to(preffered:)`, who can change presentation style. He work with UINavigationController and default presentation.

```swift
to(preferred: TransitionStyle)
```

## Transition on new storyboard

Also LightRoute can transition on new storyboard instance like this:

```swift

// We remeber this class :)
func openModule(userIdentifier: String) {

  let storyboard = UIStoryboard(name: "NewStoryboard", bundle: Bundle.main)
  let factory = StoryboardFactory(storyboard: storyboard)

  transitionHandler

  // Initiates the opening of a new view controller from custom `UIStoryboard`.
  .forStoryboard(factory: factory, to: SecondViperViewControllerModuleInput.self)

	// Set animate for transition.
  .transition(animate: false)

  // View controller init block. 
  .then { moduleInput in 
    moduleInput.configure(with: userIdentifier)
  } // If you don't want initialize view controller, we should be use `.push()`
}

```

## Transition for Segue

And finish, you can initiate transition from `UIStoryboardSegue` like this:

```swift

func openModule(userIdentifier: String) {
  transitionHandler
     // Performs transition from segue and cast to need type
    .forSegue(identifier: "LightRouteSegue", to: SecondViperViewControllerModuleInput.self) { moduleInput in 
      moduleInput.setup(text: "Segue transition!") 
    }
}

```
But, for this case, you can't change transition flow.


## Note

- Mastermind: [ViperMcFlurry](https://github.com/rambler-digital-solutions/ViperMcFlurry)
- License: `MIT`
- Author: Vladislav Prusakov / vlad@webant.ru

Thanks for watching.
