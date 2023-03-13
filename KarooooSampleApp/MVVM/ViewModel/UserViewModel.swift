//
//  UserViewModel.swift
//  KarooooSampleApp
//
//  Created by Halcyon Tek on 10/03/23.
//

import Foundation

///Loader delegate for to show loader for long running tasks
protocol LoaderDelegate{
    func isLoad(loading:Bool)
}

class UserViewModel{
    
    //MARK: - Properties
    var onShowError: ((_ message: String) -> Void)?
    var delegate:LoaderDelegate?
    private var apiService = Service.shared
    
    
    func userService(username:String,password:String,completion: @escaping ([UserModel])->Void){
        delegate?.isLoad(loading: true)
        
        self.apiService.userService() {[weak self] (result) in
            guard let self = self else {return}
            self.delegate?.isLoad(loading: false)
            switch result{
            case .success(let response):
                print(response)
                    completion(response)
                
            case .failure(let failure):
                print(failure)
                self.onShowError?(failure.localizedString)
            }}}}

