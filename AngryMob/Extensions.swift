//
//  Extensions.swift
//  AngryMob
//
//  Created by Wiktor Wielgus on 27.05.2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import UIKit

// MARK: DateFormatter Extensions

enum Formatter {
    case Date
    case Time
    case Fulldate
    case DateComment
    case ActivityDate
}

extension DateFormatter {
    convenience init(formatter: Formatter) {
        self.init()
        switch formatter {
        case .Date:
            self.dateFormat = "dd-MM-yyyy"
        case .Time:
            self.dateFormat = "HH:mm"
        case .Fulldate:
            self.dateFormat = "dd.MM.yyyy HH:mm"
        case .ActivityDate:
            self.dateFormat = "dd-MM-yyyy HH:mm"
        case .DateComment:
            self.dateFormat = "dd/MM/yyyy"
        }
    }
    
}

// MARK: Date Extensions

extension Date {
    
    struct Formatter {
        static let date = DateFormatter(formatter: .Date)
        static let time = DateFormatter(formatter: .Time)
        static let dateComment = DateFormatter(formatter: .DateComment)
        static let fullDate = DateFormatter(formatter: .Fulldate)
    }
    
    var date: String {
        return Formatter.date.string(from: self)
    }
    
    var time: String {
        return Formatter.time.string(from: self)
    }
    
    var fulldate: String {
        return Formatter.fullDate.string(from: self)
    }
    
    var dateComment: String {
        return Formatter.dateComment.string(from: self)
    }
}

struct Colors {
    static let happyColor = UIColor(red:0.42, green:0.83, blue:0.88, alpha:1.0)
    static let sadColor = UIColor(red:0.79, green:0.42, blue:0.28, alpha:1.0)
    static let amusedColor = UIColor(red:0.47, green:0.31, blue:0.50, alpha:1.0)
    static let astonishedColor = UIColor(red:0.85, green:0.66, blue:0.36, alpha:1.0)
    static let boredColor = UIColor(red:0.38, green:0.49, blue:0.55, alpha:1.0)
    static let confusedColor = UIColor(red:0.69, green:0.85, blue:0.51, alpha:1.0)
    static let afraidColor = UIColor(red:1.00, green:0.31, blue:0.31, alpha:1.0)
}
