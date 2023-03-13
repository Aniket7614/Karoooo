//
//  Service.swift
//  KarooooSampleApp
//
//  Created by Halcyon Tek on 11/03/23.
//

import Foundation

class Service{
    
    static let shared = Service()
    
    //MARK: - Login Service
    func userService(completion: @escaping (Result<[UserModel],NetworkError>)->Void){
        
        ApiHandler.getParse(urlString: "https://jsonplaceholder.typicode.com/users", parameters: nil, headers: nil, method: .get) { (result:Result<Data,NetworkError>) in
            
            switch result{
            case .success(let success):
                do{
                    let userModel = try JSONDecoder().decode([UserModel].self, from: success)
                    completion(.success(userModel))
                }catch{
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion(.failure(.error(message: error.localizedString )))
            }
            
        }
    }
    
}

