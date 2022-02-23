//
//  ExerciseDetailListWorker.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//
//
//
//
//import Foundation
//import Combine
//
//protocol ExerciseDetailListWorkerApi: AnyObject{
//    func getExerciseData(id: Int) -> Future<Exercise, Error>
//}
//
//class ExerciseDetailListWorker: ExerciseDetailListWorkerApi{
//    let apiManager: ApiManagerProtocol
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(apiManager:ApiManagerProtocol) {
//        self.apiManager = apiManager
//    }
//    
//    /**
//     Api caller for exercise list
//     - returns: Future<[Exercise], Error>
//     */
//    func getExerciseData(id: Int)  -> Future<Exercise, Error>{
//        return Future<Exercise, Error> { [weak self] promise in
//            guard let self = self else {
//                return promise(.failure(NetworkError.unknown))
//            }
//            self.apiManager.getData(endpoint: Endpoint.getVideCategories(String(id)), type: Exercise.self)
//                .sink { completion in
//                    switch completion {
//                    case .failure(let err):
//                        promise(.failure(err))
//                    case .finished:
//                        break
//                    }
//                }
//                receiveValue: {
//                    promise(.success($0))
//                }
//                .store(in: &self.cancellables)
//        }
//    }
//    
//    
//}
