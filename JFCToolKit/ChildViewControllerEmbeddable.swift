import UIKit

/**
 Enables easy, safe embedding of child view controllers inside conforming UIViewContoller subclasses.
 
 **Usage**
 
 1. Define the associated `ChildViewControllerContainer` type as an enum with a `String` raw value nested inside the conforming type. Each case corresponds to a container `UIView` which will hold child view controllers:
 
     ```
     class ViewController: ChildViewControllerEmbeddable {
         enum ChildViewControllerContainer: String {
             case map
             case table
         }
     }
     ```
 
 2. Add `embeddedChildVCs` property to conforming type:
    ```
    var embeddedChildVCs: [ChildViewControllerContainer: UIViewController] = [:]
    ```
 
 3. Implement `containerView(for container:) -> UIView` on conforming type mapping each enum case to a corresponding container view:
    
    ```
     func containerView(
         for container: ChildViewControllerContainer) -> UIView
     {
         switch container {
         case .main: return self.mainContainerView
         case .lower: return self.lowerContainerView
         }
     }
    ```
 */
public protocol ChildViewControllerEmbeddable: class {
    associatedtype ChildViewControllerContainer: Hashable
    
    var embeddedChildVCs: [ChildViewControllerContainer: UIViewController] { get set }
    
    func embed(
        childViewController childVC: UIViewController,
        inContainer container: ChildViewControllerContainer
    )
    
    func childViewController(
        for container: ChildViewControllerContainer
    ) -> UIViewController?
    
    func set(
        childViewController childVC: UIViewController,
        forContainer container: ChildViewControllerContainer
    )
    
    func containerView(
        for container: ChildViewControllerContainer
    ) -> UIView
}

public extension ChildViewControllerEmbeddable where Self: UIViewController {
    public func embed(
        childViewController childVC: UIViewController,
        inContainer container: ChildViewControllerContainer)
    {
        let previousChildVC = childViewController(for: container)
        previousChildVC?.willMove(toParentViewController: nil)
        
        self.addChildViewController(childVC)
        
        let containerView = self.containerView(for: container)
        
        childVC.view.frame = containerView.bounds
        
        containerView.addSubview(childVC.view)
        
        childVC.didMove(toParentViewController: self)
        previousChildVC?.view.removeFromSuperview()
        previousChildVC?.removeFromParentViewController()
        
        set(childViewController: childVC, forContainer: container)
    }
    
    public func childViewController(
        for container: ChildViewControllerContainer) -> UIViewController?
    {
        return embeddedChildVCs[container]
    }
    
    public func set(
        childViewController childVC: UIViewController,
        forContainer container: ChildViewControllerContainer)
    {
        embeddedChildVCs[container] = childVC
    }
}
