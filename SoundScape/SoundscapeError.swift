
import Foundation

enum SoundscapeError: Error {
    
    //unbox errors
    case couldNotCastAsUnboxableDict
    case couldNotUnboxResult
    case couldNotCastAsDictionary
    case couldNotUnboxAtKey
    case unknownUnboxError
    
    //TODO: api request errors 
    
    var errorDescription: String {
        switch self {
        case .couldNotCastAsUnboxableDict:
            return "Unbox error: could not cast object as Unboxable Dictionary"
        case .couldNotUnboxResult:
            return "Unbox error: could not unbox result"
        case .couldNotCastAsDictionary:
            return "Unbox error: could not cast as [String: Any]"
        case .couldNotUnboxAtKey:
            return "Unbox error: could not unbox result at key"
        case .unknownUnboxError:
            return "Unbox error: unknown unbox error"
        }
    }
}
