import UIKit

/**
 Type with associated `TypedSegue: RawRepresentable` which allows conforming UIViewControler subclasses to create explicit Segue types rather than rely on "magic strings".
 */
public protocol TypedSegueHandling {
    associatedtype TypedSegue: RawRepresentable
    func typedSegue(
        for segue: UIStoryboardSegue,
        file: StaticString,
        line: UInt
    ) -> TypedSegue
}

public extension TypedSegueHandling where Self: UIViewController, TypedSegue.RawValue == String {
    /**
     Returns the TypedSegue corresponding to `segue`'s identifier. `fatalError` occurs if segue.identifier is nil or empty or does not corresponding to any raw value of and `TypeSegue`s.
     */
    public func typedSegue(
        for segue: UIStoryboardSegue) throws -> TypedSegue
    {
        guard
            let identifier = segue.identifier,
            let identifierCase = TypedSegue(rawValue: identifier)
        else {
            throw TypedSegueError.unableToCreateTypedSegue("Could not map segue identier -- \(String(describing: segue.identifier)) -- to segue case; Source: \(type(of: segue.source)), Destination: \(type(of: segue.destination))")
        }
        
        return identifierCase
    }
    
    /**
     Performs segue with raw value of typedSegue as the segue.identifier.
     */
    public func performSegue(for typedSegue: TypedSegue, sender: Any?) {
        self.performSegue(withIdentifier: typedSegue.rawValue, sender: sender)
    }
}
