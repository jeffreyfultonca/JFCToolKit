import UIKit

/**
 Enables UIViewController subclasses to be programmatically instantiated from a UIStoryboard by type rather then "magic strings".
 
 Usage Requirements:
 - Add conformance to UIViewController subclass. i.e. `extension SignInViewController: StoryboardIdentifiable`.
 - In Interface Builder set ViewController's Storyboard ID to name of subclass in identity inspector. i.e. `Storyboard ID: SignInViewController`.
 
 Conforming UIViewController subclasses can then be programatically instantiated from a UIStoryboard via included generic function. i.e.
 ```
 let signInVC: SignInViewController = signInStoryboard.instantiateViewController
 ```
 */
public protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    /// Defaults to name of type. i.e. `class SignInViewController: UIViewController` has a default storyboardIdentifier of `SignInViewController`.
    ///
    /// Set explicitly by implementing this property in conforming types.
    public static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    /// Programatically instantiate a `StoryboardIdentifiable` `UIViewController` subclass with inferred type. i.e. 
    /// ```
    /// let signInVC: SignInViewController = signInStoryboard.instantiateViewController
    /// ```
    public func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Could not instantiate view controller with identifier \(T.storyboardIdentifier) in storyboard \(self)")
        }
        
        return viewController
    }
}
