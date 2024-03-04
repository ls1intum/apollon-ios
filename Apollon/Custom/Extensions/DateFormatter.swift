//
//  DateFormatter.swift
//  Apollon
//
//  Created by Maximilian Sölch on 04.03.24.
//

import Foundation

extension DateFormatter {
    /// Formatter that includes the date as well as the time.
    ///
    /// Example: September 3, 2018 at 3:38 PM
    public static let dateAndTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter
    }()
}
