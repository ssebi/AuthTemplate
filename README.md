# Authentication UI Template in iOS

## Introduction

The purpose of this project is to teach you how to create a scrolling view that displays a couple of different view controllers and also contains static buttons that stay in place when the view controllers transition from one to the other. We will focus this project on creating a user authentication flow. 

There are a couple of ways this can be achieved, each having advantages and disadvantages. We could use a `UIPageViewController`, `UIScrollView` or `UINavigationViewController`. However, in most cases the easiest solution is also the best one so we'll go with the one I find easiest, and that's using a `UINavigationViewController`.
The previous two require some work in order to go from one screen to the other. In the case of `UIScrollView` we need to write some functions that manually scroll the views in place and in the case of `UIPageViewController` we have to mess with its `dataSource` a little and set the next view controller using the `setViewControllers` method. The latter is probably not that bad, but I prefer using the `UINavigationViewController` method.

## How we're going to do this

We're going to have a `container view` in for the top part which will hold all other view controllers in our authentication flow. In the bottom part we're going to have two buttons that control the movement of the views above.

Embedded in the `container view` we have the `UINavigationController` which will, in turn hold all the other views. Tapping `Next` will push the next view controller to the navigation stack and tapping `Previous` will pop the current view controller.

## Let's start

### Part One

First the easy parts, let's add the two buttons on the bottom part. 

- Add two buttons and embed them in a vertical `UIStackView`. Set the title of the top one `Next` and the bottom one `Previous`. Then add `leading`, `trailing` and `bottom` constraints with constants of `20`. That's all, our buttons are done.
- Now add a `Container View` and constraint it to all four edges with a constant of `20` again. I guess you can add a little more space on the bottom constraint.
- Click on the newly created view controller (the one that's embedded in the container view) and go to `Editor -> Embed In -> Navigation Controller`.
- Now for the last touch, click the `Navigation Bar` in the `UINavigationController` and thick `Prefers Large Titles`.

That's our first view controller covered.

### Part Two

Now we're going to create the necessary view controllers for the authentication process.

- Add a new `UIViewController` in the `Storyboard`, then add a `UILabel` inside of it and two `UITextFields`. Set the `UILabel's` text to "*What's your name*" and set the placeholders for the `UITextFields` to "*First Name*" and "*Last Name*".
- Select the two `UITextFields` and embed them in a vertical `UIStackView` with a spacing of `10`.
- Select the previously created `UIStackView` and and `UILabel` and embed them in another vertical `UIStackView` with a higher spacing, of `40`.
- Now set the `UIViewController's` title to "*Let's get started*". And that's the UI for the first view controller in the flow done.
- Click the previously created view controller and tap `CMD + D` to duplicate it, set the `UILabel's` text to "*What's your email*", remove one of the `UITextFields` and set the placeholder of the remaining one to "*Email*". Set the `UIViewController's` title to "*Hi John*" and that's it.
- Now duplicate the last `UIViewController` and replace the `UILabel's` text with "*What's your phone number?*" and the placeholder text in the `UITextField` to "*Phone Number*". Change the `UIViewController's` title to "*Just one more thing*" and the UI stuff is done.

### Part Three

Now let's get into some coding. We'll start by creating `UIViewController` classes for all of our authentication view controllers. 

- First of all, create a new folder called "*AuthViewControllers*"
- Press `CMD + N`, type "*cocoa*" and pick `Cocoa Touch Class`, then type "*NameViewController*".
- Repeat the previous step to create another two classes called "*EmailViewController*" and "*PhoneViewController*".
- Put them all in the "*AuthViewControllers*" folder to keep things tidy.
- Now create another `Cocoa Touch Class` called "*ContainerViewController*". This class will hold and orchestrate all of the auth view controllers.
- One last step. Go to the `Main.storyboard` again and in the `Identity Inspector` set the custom classes that we've created for every `UIVIewController`.

#### ViewController

Now we'll add some code in each class that we've created. Let's start with the existing "*ViewController*".

- We need to be able to communicate with the container view so let's create a property that references it.

```swift
    private var containerViewController: ContainerViewController? {
        ((self.children.first as? UINavigationController)?.viewControllers.first as? ContainerViewController)
    }
```

- What this code does is it takes the first `ChildViewController`, cast it to `UINavigationController`, then take it's first view controller and cast it to `ContainerViewController` which is our custom class. 
- Create some `@IBActions` for the button taps and that's all

```swift
    @IBAction func primaryButtonTapped(_ sender: Any) { }

    @IBAction func secondaryButtonTapped(_ sender: Any) { }
```

#### ContainerViewController

We have to do more work here, in the "*ContainerViewController*". Let's start by creating an `Enum` to hold our Auth View Controllers. You can define it inside the "*ContainerViewController*".

```swift
    enum AuthViewControllers {
        case name
        case email
        case phone
    }
```

- Now add a property to hold the current view controller

```swift
    private var currentViewController: AuthViewControllers = .name
```

- Before we go further, let's make our lives easier and add a handy extension to make it easier to load `UIViewControllers` from `UIStoryboard`. Create a new class, you can call it `UIStoryboard+Extensions.swift` and add these lines:

```swift
extension UIStoryboard {

    func instantiateViewController<T>(ofType type: T.Type) -> T {
        let identifier = String(describing: type)
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Cannot instantiate view controller")
        }
        return viewController
    }

}

extension UIStoryboard {

    static let main = UIStoryboard(name: "Main", bundle: nil)

}
```

- Because Swift enums are so cool, we can write additional code in our enum to aid us in retrieving the right `UIViewController`. So add the following functions to the "*AuthViewControllers*" enum:

```swift
    func initial() -> UIViewController {
        switch self {
            case .name:
                return UIStoryboard.main.instantiateViewController(ofType: NameViewController.self)
            case .email:
                return UIStoryboard.main.instantiateViewController(ofType: EmailViewController.self)
            case .phone:
                return UIStoryboard.main.instantiateViewController(ofType: PhoneViewController.self)
        }
    }

    mutating func next() -> UIViewController {
        switch self {
            case .name:
                self = .email
                return UIStoryboard.main.instantiateViewController(ofType: EmailViewController.self)
            case .email:
                self = .phone
                return UIStoryboard.main.instantiateViewController(ofType: PhoneViewController.self)
            case .phone:
                self = .name
                return UIStoryboard.main.instantiateViewController(ofType: NameViewController.self)
        }
    }
```

- Notice the `mutating` before the `next()` func. It means that inside the function we're also modifying the current instance of the enum. That's really convenient since we don't have to do it in the `ContainerViewController` after we call the function.
- Now we can call the `initial()` function in the `ContainerViewController`, so put this line of code in the `viewWillAppear` function:

```swift
navigationController?.pushViewController(currentViewController.initial(), animated: false)
```

- The last thing we need to add is some functions to push and pop view controllers

```swift
    func goToNextViewController() {
        navigationController?.pushViewController(currentViewController.next())
    }

    func goToPreviousViewController() {
        navigationController?.popViewController(animated: true)
    }
```

#### ViewController again

Now that we have everything in place, we can complete the actions when tapping the buttons:

```swift
    @IBAction func primaryButtonTapped(_ sender: Any) {
        containerViewController?.goToNextViewController()
    }

    @IBAction func secondaryButtonTapped(_ sender: Any) {
        containerViewController?.goToPreviousViewController()
    }
```

### Part Four

Now you can finally run the app and hopefully everything works just fine. You should be able to go back and forth between those auth view controllers.

But you might have noticed that the result is not very visually appealing. That default push and pop navigation transition doesn't look good at all when embedded in a `Container View`. So how can we fix this? Create a new class called `UINavigationController+Extensions.swift` and add the following lines:

```swift
public extension UINavigationController {

    func pop(transitionType type: CATransitionType, subtype: CATransitionSubtype, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, subtype: subtype, duration: duration)
        self.popViewController(animated: false)
    }

    func push(viewController: UIViewController, transitionType type: CATransitionType, subtype: CATransitionSubtype, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, subtype: subtype, duration: duration)
        self.pushViewController(viewController, animated: false)
    }

    private func addTransition(transitionType type: CATransitionType, subtype: CATransitionSubtype, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = type
        transition.subtype = subtype
        self.view.layer.add(transition, forKey: nil)
    }

}
```

- This `extension` adds the ability add custom transitions on the `UINavigationController`
- Now we can go back in the `ContainerViewController` and replace the contents of the `goToNextViewController()` and `goToPreviousViewController()` functions with:

```swift 
    func goToNextViewController() {
        navigationController?.push(viewController: currentViewController.next(), transitionType: .push, subtype: .fromRight)
    }

    func goToPreviousViewController() {
        navigationController?.pop(transitionType: .push, subtype: .fromLeft)
    }
```

## One last touch

Notice that we didn't do anything about the `Back` button in the `UINavigationViewController`. We definitely shouldn't be able to see and interact with it. To fix this, we need to go into every one of the auth view controllers and add this line in the `viewDidLoad()` method:

```swift
navigationItem.setHidesBackButton(true, animated: false)
```

## Finished

That was it. I hope that you've enjoyed it and that you've at least learnt a few new tricks.
