//
//  APIHandler.swift
//  KarooooSampleApp
//
//  Created by Halcyon Tek on 11/03/23.
//

import Foundation
import Alamofire

enum NetworkError: Error{
    case error(message: String)
    case networkError(message:String)
    var localizedString: String{
        switch self {
        case .error(let message):
            return message
        case .networkError(let message):
            return message
        }}}


open class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }}


enum Methods{
    case get
}


struct ApiHandler{
    static func getParse(urlString: String,parameters: Parameters?,headers:HTTPHeaders?,method:Methods,completion: @escaping (Result<Data,NetworkError>) -> Void){
        guard let url = URL(string: urlString) else {
            print("Error: Cannot create URL from string")
            return
        }
        print(url)
        print(parameters ?? "")
        print(method)
        switch method{
        case .get:
            AF.request(urlString, method: .get, parameters: parameters,encoding: URLEncoding.default,headers: headers).responseData{ response in
                guard Connectivity.isConnectedToInternet else{
                    completion(.failure(.networkError(message: "No Internet connection")))
                    return
                }
                guard let data = response.data else{
                    return completion(.failure(.error(message: "Data is nil")))
                }
                switch response.result{
                case .success(_):
                    if response.response?.statusCode == 200{
                        completion(.success(data))
                    }else if response.response?.statusCode == 404{
                        completion(.failure(.error(message: "Not Found")))
                    }else if response.response?.statusCode == 401{
                        completion(.failure(.error(message: "Bad Request")))
                    }else{
                        completion(.failure(.error(message: "Somethig went wrong please try again after some time")))
                    }
                case .failure(let error):
                    if response.response?.statusCode == 500 {
                        completion(.failure(.error(message: "Somethig went wrong")))
                    }else{
                        completion(.failure(.error(message: error.localizedDescription.description)))
                    }
                }
            }
        }
    }
}
