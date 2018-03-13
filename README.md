# LightRoute
[![Pod version](https://badge.fury.io/co/LightRoute.svg)](https://badge.fury.io/co/LightRoute)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SpectralDragon/LightRoute/blob/master/LICENSE.txt)
![Swift](https://img.shields.io/badge/Swift-4.0-green.svg)

## Description
LightRoute is easy transition between VIPER modules, who implemented on pure Swift.
We can transition between your modules very easy from couple lines of codes.

## Install
**CocoaPods**

Add to your podfile:

```ruby
pod "LightRoute"
```

**Swift Package Manager**

Once you have your Swift package set up, adding LightRoute as a dependency is as easy as adding it to the dependencies value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/SpectralDragon/LightRoute.git", majorVersion: 2)
]
```

## Example

- Demo project [Viper-LightRoute-Swinject](https://github.com/SpectralDragon/Viper-LightRoute-Swinject)

## About LightRoute

LightRoute can work with `Segue`, `UINavigationController` and default view controller presenting.

For all transition, returns  `TransitionNode` instance, who managed current transition. You can change transition flow, how you want.


## How to use

For example, we will make the transition between the two VIPER modules:

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

      try? transitionHandler
				
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
In this case, you make default transition between viewControllers and configure moduleInput how you want.
But also, you can use just viewController, example:

```swift
.forCurrentStoryboard(resterationId: viewControllerIdentifier, to: SecondViperPresenter.self)
/// and etc..
```

**Note❗️**
`moduleInput` - by default that property contain your `output` property in destination view controller. You can change that use methods `selector:`.
You can use next for get custom moduleInput:
- by string: `selector(_ selector: String)`
- by selector: `selector(_ selector: Selector)`
- by keyPath:  `selector(_ selector: KeyPath)`

## Transition case 
For example we analyze this code, then contain two case for work with transition:


**First case:**

This default case, with default LightRoute implementation. If you want just present new module, then use that:

```swift

try? transitionHandler

// Initiates the opening of a new view controller.
.forCurrentStoryboard(resterationId: viewControllerIdentifier, to: SecondViperViewControllerModuleInput.self)

// Setup module input.
.then { moduleInput in 
  moduleInput.configure(with: "Hello!")
}

```


**Second case:**

But first way can't be flexible, for that has `customTransition()` method. This method returns `CustomTransitionNode`. This node not support default `TransitionNode` methods.
`CustomTransitionNode` is class, who return method flexible settings your transition, but for this transition flow, you should be implement your transition logic, and call `them(_:)` or `perform()` method for activate transition.

Example:

```swift

try? transitionHandler

// Initiates the opening of a new view controller.
.forCurrentStoryboard(resterationId: viewControllerIdentifier, to: SecondViperViewControllerModuleInput.self)

// Activate custom transition.
.customTransition()

// Custom transition case.
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

This methods can animate your current transition.

```swift
.transition(animate: false)
```

**Change presentation**

Method `to(preffered:)`, have responsobility for change presentation style. He work with UINavigationController, UISplitViewController and default presentation.

```swift
.to(preferred: TransitionStyle)
```

**Configure you destination controller**

Sometimes you need add additional dependency in your controller. For this case, will be add method `apply(to:)`. That method return destination controller and you can configurate him.

````swift

try? transitionHandler
  .forSegue(identifier: "LightRouteSegue", to: SecondViperViewControllerModuleInput.self)
  .apply(to: { controller in
    // configure your controller.
  })
  .then { moduleInput in
    // configure your module
  }
  
````

## Transition on new storyboard

Also LightRoute can transition on new storyboard instance like this:

```swift

// We remeber this class :)
func openModule(userIdentifier: String) {

  let storyboard = UIStoryboard(name: "NewStoryboard", bundle: Bundle.main)
  let factory = StoryboardFactory(storyboard: storyboard)

  try? transitionHandler

  // Initiates the opening of a new view controller from custom `UIStoryboard`.
  .forStoryboard(factory: factory, to: SecondViperViewControllerModuleInput.self)

	// Set animate for transition.
  .transition(animate: false)

  // View controller init block. 
  .then { moduleInput in 
    moduleInput.configure(with: userIdentifier)
  } // If you don't want initialize view controller, we should be use `.perform()`
}

```

## Transition for Segue

And finish, you can initiate transition from `UIStoryboardSegue` like this:

```swift

func openModule(userIdentifier: String) {
  try? transitionHandler
       // Performs transition from segue and cast to need type
       .forSegue(identifier: "LightRouteSegue", to: SecondViperViewControllerModuleInput.self)
       .then { moduleInput in
        moduleInput.setup(text: "Segue transition!")
      }
}

```

## Close current module

If you want initiate close current module, you should be use:

```swift
.closeCurrentModule()
```

And after this you can use `perform()` method for initiate close method.

**Animate close transition**

This methods can animate your current transition.

```swift
.transition(animate: false)
```

Note: Default `true`

**Custom close style**

If you wanna close pop controller or use popToRoot controller, you must perform method `preferred(style:)`.
That method have different styles for your close transition.

If you need call `popToViewController(:animated)` for your custom controller, you must perform method `find(pop:)`.

````swift
try? transitionHandler
  .closeCurrentModule()
  .find(pop: { controller -> Bool
    return controller is MyCustomController
  })
  .preferred(style: .navigation(style: .findedPop))
  .perform()
````

## Support UIViewControllerTransitioningDelegate

LightRoute 2.0 start support UIViewControllerTransitioningDelegate for your transition. We can work with that use next methods:

```swift
.add(transitioningDelegate: UIViewControllerTransitioningDelegate)
```


## Note

- Mastermind: [ViperMcFlurry](https://github.com/rambler-digital-solutions/ViperMcFlurry)
- License: `MIT`
- Author: Vladislav Prusakov / hipsterknights@gmail.com

Thanks for watching.
