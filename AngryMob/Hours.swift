//
//  Hours.swift
//  AngryMob
//
//  Created by Radoslaw Halski on 28/05/2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import Mapper

struct Hours {
    
    var hoursArray: [Int]
    
    
}

extension Hours: Mappable {
    init(map: Mapper) throws {
        hoursArray = Array<Int>()
        for index in 0...24 {
            let value:Int? = map.optionalFrom("\(index)")
            
            if let value = value {
                hoursArray.append(value)
            }
            else {
                hoursArray.append(0)
            }
        }
    }
}
