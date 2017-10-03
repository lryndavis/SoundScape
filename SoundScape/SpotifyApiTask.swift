import Foundation
import Alamofire
import BoltsSwift
import Unbox

struct SpotifyApiTask {
    
    static func buildRequest(_ action: URLRequestConvertible) -> Task<Any> {
        return buildRequest(action, taskResult: {$0})
    }
    
    static func buildRequest<T>(_ action: URLRequestConvertible, taskResult: @escaping (Any) throws -> T) -> Task<T> {
        
        let taskCompletionSource = TaskCompletionSource<T>()
        
        Alamofire.request(action).responseJSON { response in
            
            if let status = response.response?.statusCode {
                if status == 200 {
                    if let value: Any = response.result.value as Any? {
                        do {
                            let resultValue = try taskResult(value)
                            taskCompletionSource.set(result: resultValue)
                        } catch {
                            taskCompletionSource.set(error: error)
                        }
                    }
                }
            }
        }
        return taskCompletionSource.task
    }
    
}

extension SpotifyApiTask {
    
    static func createUnboxedObject<T>(obj: Any) throws -> T where T: Unboxable {
        
        var result: T?
        guard let resultDict = obj as? UnboxableDictionary else {
            throw SoundscapeError.couldNotCastAsUnboxableDict
        }
        do {
            result = try unbox(dictionary: resultDict)
        } catch {
            print(error)
            throw SoundscapeError.couldNotUnboxResult
        }
        
        if let result = result {
            return result
        } else {
            throw SoundscapeError.unknownUnboxError
        }
    }
    
    //unbox nested json arrays 
    static func createUnboxedArray<T>(obj: Any, key: String, isNestedAtKeyPath: Bool = false) throws -> [T] where T: Unboxable {
    
        var result: [T]?
        guard let resultDict = obj as? [String: Any] else {
            throw SoundscapeError.couldNotCastAsDictionary
        }
        
        do {
            if isNestedAtKeyPath {
                result = try unbox(dictionary: resultDict, atKeyPath: key)
            } else {
                result = try unbox(dictionary: resultDict, atKey: key)
            }
        } catch {
            print(error)
            throw SoundscapeError.couldNotUnboxAtKey
        }
        
        if let result = result {
            return result
        } else {
            throw SoundscapeError.unknownUnboxError
        }
    }
    
}
 


