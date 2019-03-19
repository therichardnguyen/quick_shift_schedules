//
//  DateFormatters.swift
//  Homebase Client Engineering Question
//
//  Created by Richard Nguyen on 3/18/19.
//  Copyright © 2019 Richard Nguyen. All rights reserved.
//

import Foundation

struct Formatter {
    struct date {
        static let api: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
            formatter.timeZone = TimeZone(identifier: "UTC")
            return formatter
        }()
    }
}
