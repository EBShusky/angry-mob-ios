//
//  APIClient.swift
//  AngryMob
//
//  Created by Wiktor Wielgus on 26.05.2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Mapper
import Moya_ModelMapper

protocol Requesting {
    func uploadImage(image: Data, fileName: String)
}

class APIClient: Requesting {
    
    static let sharedInstance = APIClient()
    private init() {}
    
    let provider: RxMoyaProvider<Router> = RxMoyaProvider<Router>(endpointClosure:endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true)])
    
    let disposeBag = DisposeBag()
    
    func uploadImage(image: Data, fileName: String) {
        provider.request(.image(imageData: image, fileName: fileName))
            .subscribe(onNext: { response in

            }).addDisposableTo(disposeBag)
    }
    
    func getGenderSummary(from: String, to: String) -> Observable<Gender> {
        return provider.request(.genderSummary(dateFrom: from, dateTo: to))
            .mapObject(type: Gender.self)
    }
    
    func getEmotionSummary(from: String, to: String) -> Observable<EmotionModel> {
        return provider.request(.emotions(dateFrom: from, dateTo: to))
            .mapObject(type: EmotionModel.self)
    }

    func getAgeSummary(from: String, to: String) -> Observable<Age> {
        return provider.request(.ageSummary(dateFrom: from, dateTo: to))
            .mapObject(type: Age.self)
    }

}
