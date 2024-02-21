import Foundation

extension String {
    func insertSpaceBeforeCapitalLetters() -> String {
        var result = ""
        for (index, char) in self.enumerated() {
            if char.isUppercase && index != 0 {
                result.append(" ")
            }
            result.append(char)
        }
        return result
    }
}
