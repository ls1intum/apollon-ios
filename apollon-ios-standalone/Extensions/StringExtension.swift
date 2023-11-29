import Foundation

extension String {
    func insertSpaceBeforeCapitalLetters() -> String {
        var result = ""
        for char in self {
            if char.isUppercase {
                result.append(" ")
            }
            result.append(char)
        }
        return result
    }
}
