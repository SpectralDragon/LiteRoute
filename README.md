# LightRoute
LightRoute is easy transition between VIPER modules and not only. Written in Swift 3.

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
      .openModuleStoryboard(identifier: viewControllerIdentifier, for: SecondViperViewControllerModuleInput.self)
				
      // Set animate for transition.
      .transition(animate: false)

      // Set transition case.
      .from(case: TransitionCase.navigationController(case: .push))

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
		// Initialize code..
  }

}
```


LightRoute can transition for new storyboard instance like this:

```swift

// We remeber this class :)
func openModule(userIdentifier: String) {

  let storyboard = UIStoryboard(name: "NewStoryboard", bundle: Bundle.main)
  let factory = StoryboardFactory(storyboard: storyboard)

  transitionHandler

  // Initiates the opening of a new view controller from custom `UIStoryboard`.
  .openModuleStoryboard(factory: factory, for: SecondViperViewControllerModuleInput.self)
  // Requires user to set the transition between controllers.
  .transition { (source, destination) in
     source.present(destination, animated: true, completion: nil)
  }
	
  // REMEBER: This methods not works with this case, because transition set as `Protected`.
  //.transition(animate: false)
  //.from(case: TransitionCase.navigationController(case: .push))

	
  // View controller init block. 
  .then { moduleInput in 
    moduleInput.configure(with: userIdentifier)
  } // If you don't want initialize view controller, we should be use `.push()`
}

```

