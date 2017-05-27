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

protocol Requesting {
    func uploadImage(image: Data, fileName: String)
}

class APIClient: Requesting {
    
    let provider: RxMoyaProvider<Router>
    let disposeBag = DisposeBag()
    
    init() {
        self.provider = RxMoyaProvider<Router>(endpointClosure:endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true)])
    }
    
    func uploadImage(image: Data, fileName: String) {
        provider.request(.image(imageData: image, fileName: fileName))
            .subscribe(onNext: { response in

            }).addDisposableTo(disposeBag)
    }
}
