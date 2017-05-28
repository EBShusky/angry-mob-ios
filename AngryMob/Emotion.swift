//
//  Emotion.swift
//  AngryMob
//
//  Created by Wiktor Wielgus on 28.05.2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import Mapper

struct EmotionModel {
    let happy: Int?
    let sad: Int?
    let angry: Int?
    let confused: Int?
    let disgusted: Int?
    let surprised: Int?
    let calm: Int?
    let unknown: Int?
}

extension EmotionModel: Mappable {
    init(map: Mapper) throws {
        happy = map.optionalFrom("HAPPY")
        sad = map.optionalFrom("SAD")
        angry = map.optionalFrom("ANGRY")
        confused = map.optionalFrom("CONFUSED")
        disgusted = map.optionalFrom("DISGUSTED")
        surprised = map.optionalFrom("SURPRISED")
        calm = map.optionalFrom("CALM")
        unknown = map.optionalFrom("UNKNOWN")
    }
}
