//
//  ViewController.swift
//  HappyAppleIDLogin
//
//  Created by 王冠之 on 2020/5/24.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)

        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
    }
    
    @objc
    func didTapAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        //用來實作登入成功、失敗的邏輯、來告知ASAuthorizationController該呈現在哪個 Window 上
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secVC = segue.destination as? secondViewController, let user = sender as? User {
            secVC.user = user
        }
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        //只有第一次登入時，會取得除了 User ID 的資料。
        //所以必須得將其資料存放在 Server 端，以利後續使用。
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = User(credentials: credentials)
            performSegue(withIdentifier: "segue", sender: user)
            
        default: break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("something bad happened", error)
    }
}

//告知 ASAuthorizationController 該呈現在哪個 Window 上
extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

