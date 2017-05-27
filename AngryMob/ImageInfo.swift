//
//  ImageInfo.swift
//  AngryMob
//
//  Created by Wiktor Wielgus on 27.05.2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import Mapper

struct ImageInfo {
    let ageRange: AgeRange
    let smile: Bool
    let eyeglasses: Bool
    let sunglasses: Bool
    let gender: String
    let beard: Bool
    let mustache: Bool
    let eyesOpen: Bool
    let mouthOpen: Bool
    let emotions: [Emotion]
}

extension ImageInfo: Mappable {
    init(map: Mapper) throws {
        ageRange = try map.from("")
        smile = try map.from("")
        eyeglasses = try map.from("")
        sunglasses = try map.from("")
        gender = try map.from("")
        beard = try map.from("")
        mustache = try map.from("")
        eyesOpen = try map.from("")
        mouthOpen = try map.from("")
        emotions = try map.from("")
    }
}

struct AgeRange {
    let low: Int
    let high: Int
}

extension AgeRange: Mappable {
    init(map: Mapper) throws {
        low = try map.from("")
        high = try map.from("")
    }
}

struct Emotion {
    
}

extension Emotion: Mappable {
    init(map: Mapper) throws {
        
    }
}

//"ageRange" : {
//    "low" : 26,
//    "high" : 43
//},
//"smile" : {
//    "value" : true,
//    "confidence" : 99.67157
//},
//"eyeglasses" : {
//    "value" : false,
//    "confidence" : 99.83898
//},
//"sunglasses" : {
//    "value" : false,
//    "confidence" : 93.358765
//},
//"gender" : {
//    "value" : "Female",
//    "confidence" : 100.0
//},
//"beard" : {
//    "value" : false,
//    "confidence" : 99.96915
//},
//"mustache" : {
//    "value" : false,
//    "confidence" : 99.06514
//},
//"eyesOpen" : {
//    "value" : true,
//    "confidence" : 98.9919
//},
//"mouthOpen" : {
//    "value" : true,
//    "confidence" : 99.87603
//},
//"emotions" : [ {
//"type" : "HAPPY",
//"confidence" : 96.73413
//}, {
//"type" : "SURPRISED",
//"confidence" : 3.6450565
//}, {
//"type" : "ANGRY",
//"confidence" : 0.6297767
//} ],
