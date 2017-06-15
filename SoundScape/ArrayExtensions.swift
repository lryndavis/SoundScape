
import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index
            ? self[index]
            : nil
    }
}
