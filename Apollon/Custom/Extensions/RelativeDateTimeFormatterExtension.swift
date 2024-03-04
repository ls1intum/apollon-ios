//
//  RelativeDateTimeFormatterExtension.swift
//  Apollon
//
//  Created by Maximilian Sölch on 04.03.24.
//

import Foundation

extension RelativeDateTimeFormatter {
    /// Gives a relative date description.
    ///
    /// Example: 45 minutes ago
    static var namedAndSpelledOut: RelativeDateTimeFormatter {
        let relativeDateTimeFormatter = RelativeDateTimeFormatter()
        relativeDateTimeFormatter.dateTimeStyle = .named
        relativeDateTimeFormatter.unitsStyle = .full
        relativeDateTimeFormatter.locale = .autoupdatingCurrent
        return relativeDateTimeFormatter
    }
}
