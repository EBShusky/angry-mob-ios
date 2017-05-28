//
//  Age.swift
//  AngryMob
//
//  Created by Radoslaw Halski on 28/05/2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import Mapper

struct Age {
    
    var ageArray: [Int]

    
}

extension Age: Mappable {
    init(map: Mapper) throws {
        ageArray = Array<Int>()
        for index in 0...100 {
            let value:Int? = map.optionalFrom("\(index)")
            
            if let value = value {
                ageArray.append(value)
            }
            else {
                ageArray.append(0)
            }
        }
    }
}
