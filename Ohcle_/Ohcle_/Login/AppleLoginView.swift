//
//  AppleLoginView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct AppleLoginView: View {
    @ObservedObject var vm = LoginViewModel()
    
    var body: some View {
        CustomSocialButton() {
            vm.performAppleSignIn()
        }
        .onReceive(vm.$isSuccessed) { isSuccessed in
            if !isSuccessed {
                AlertManager.shared.showAlert(message: "\(vm.errorMessage)")
                vm.isSuccessed = true
            }
        }
        
    }
}

final class LoginViewModel: NSObject, ASAuthorizationControllerDelegate, ObservableObject {
    
    @Published var isSuccessed: Bool = true
    @Published var errorMessage: String?
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            Task {
                await LoginManager.shared.singInWithAppleAccount(appleIdCredential)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        self.isSuccessed = false
        self.errorMessage = error.localizedDescription
    }
    
    func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}

struct CustomSocialButton: View {
    var image: String = "koreanAppleLoginButtonImage"
    var action: (() -> ())?
    
    var body: some View{
        HStack{
            Button(
                action: {
                    action?()
                },
                label: {
                    Image(image)
                        .resizable()
                        .frame(width : UIScreen.main.bounds.width * 0.813)
                        .aspectRatio(CGSize(width: 7, height: 1.1),
                                     contentMode: .fit)
                })
        }
    }
}
