import UIKit

public protocol ChildViewControllerEmbeddable {
    associatedtype ChildViewControllerContainer
    
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
        
        // TODO: This should almost certainly be done via AutoLayout rather than by frame. Although it doesn't seem to matter... What is up with that? Autoresizing mask?
        childVC.view.frame = containerView.bounds
        
        containerView.addSubview(childVC.view)
        
        childVC.didMove(toParentViewController: self)
        previousChildVC?.view.removeFromSuperview()
        previousChildVC?.removeFromParentViewController()
        
        set(childViewController: childVC, forContainer: container)
    }
}
