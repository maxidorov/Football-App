//
//  RegistrationPresenter.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 13.12.2021.
//

import FirebaseAuth

protocol RegistrationViewPresenterProtocol: AnyObject {
    func loggingIn()
    func singingUp()
}

class RegistrationViewPresenter: RegistrationViewPresenterProtocol {
    weak var view: RegistrationView?
    
    func loggingIn() {
        Auth.auth().signIn(withEmail: view?.email ?? "", password: view?.password ?? "", completion: {
            result, error in
            guard let error = error else {
                self.view?.onLoggingInSuccess()
                return
            }
            self.view?.onLoggingInFailure(error)
        })
    }
    
    func singingUp() {
        Auth.auth().createUser(withEmail: view?.email ?? "", password: view?.password ?? "", completion: {
            result, error in
            guard let error = error else {
                self.view?.onSigningUpSuccess()
                return
            }
            self.view?.onSigningUpFailure(error)
        })
    }
    
}


