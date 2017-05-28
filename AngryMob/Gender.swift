//
//  Gender.swift
//  AngryMob
//
//  Created by Wiktor Wielgus on 28.05.2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import Mapper

struct Gender {
    
    let female: Int
    let male: Int
    
}

extension Gender: Mappable {
    init(map: Mapper) throws {
        female = try map.from("Female")
        male = try map.from("Male")
    }
}
