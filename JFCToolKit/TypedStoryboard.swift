import UIKit

/**
 Type with associated `StoryboardType` used to extend `UIStoryboard` and enable programmatic instantiation by type rather then by "magic strings".
 
 **Usage Requirements**
 - Extend `UIStoryboard` with `enum StoryboardType: FileNameable` defining a case and filename for each storyboard you need to instantiate programmatically. i.e.
     ```
     extension UIStoryboard: TypedStoryboard {
         public enum StoryboardType: FileNameable {
             case main
             case userAuthentication
             
             public var filename: String {
                 switch self {
                     case .main: return "Main"
                     case .userAuthentication: return "UserAuthentication"
                 }
             }
         }
    }
    ```
 - Use included convenience initializer to instantiate by type. i.e.
     ```
     let mainStoryboard = UIStoryboard(ofType: .main)
     ```
 */
public protocol TypedStoryboard {
    associatedtype StoryboardType: FileNameable
}

public protocol FileNameable {
    var filename: String { get }
}

public extension TypedStoryboard where Self: UIStoryboard  {
    
    // MARK: - Convenience Initializers
    
    public init(ofType storyboardType: Self.StoryboardType, bundle: Bundle? = nil) {
        self.init(name: storyboardType.filename, bundle: bundle)
    }
}

// Example not to be included in framework.
//extension UIStoryboard: TypedStoryboard {
//    public enum StoryboardType: FileNameable {
//        case main
//        case userAuthentication
//        
//        public var filename: String {
//            switch self {
//            case .main: return "Main"
//            case .userAuthentication: return "UserAuthentication"
//            }
//        }
//    }
//}
