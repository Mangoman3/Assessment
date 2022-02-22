//
//  ExerciseWorker.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import Foundation
import Combine

protocol ExerciseListingApi: AnyObject{
    func getExerciseList() -> Future<[Exercise], Error>
}

class ExerciseListingApiImpl: ExerciseListingApi{
    let apiManager: ApiManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(apiManager:ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    /**
     Api caller for exercise list
     - returns: Future<[Exercise], Error>
     */
    func getExerciseList() -> Future<[Exercise], Error>{
        return Future<[Exercise], Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(NetworkError.unknown))
            }
            self.apiManager.getData(endpoint: Endpoint.getVideCategories(), type: ExerciseResult.self)
                .sink { completion in
                    switch completion {
                    case .failure(let err):
                        promise(.failure(err))
                    case .finished:
                        break
                    }
                }
                receiveValue: {
                    promise(.success($0.results ?? []))
                }
                .store(in: &self.cancellables)
        }
    }
    
    
}
