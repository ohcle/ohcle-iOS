//
//  LoginView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/28.
//

import SwiftUI
import UIKit

enum GreetingTextOptions: String {
    case todaysClimbing = "오늘의 클라이밍"
    case timeToStart = "시작할 시간!"
}

struct LoginView: View {
    private let mainLogoTitle: String
    private let url: URL
    
    init(mainLogoTitle: String, receptionURL: URL?) {
        self.mainLogoTitle = mainLogoTitle
        if let url = receptionURL {
            self.url = url
        } else {
            self.url = URL(string: "http://www.google.com")!
        }
    }

    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(mainLogoTitle)
                .resizable()
                .scaledToFit()
                .aspectRatio(16.0 / 11.0, contentMode: .fit)
            
            HStack{
                Text(GreetingTextOptions.todaysClimbing.rawValue)
                    .font(.title)
                    .bold()
                
                Text(GreetingTextOptions.timeToStart.rawValue)
                    .font(.title)
                   
                
            }.padding(.horizontal, 10)
            
            Link("문의하기", destination: url)
                .font(.title3)
                .bold()
                .foregroundColor(.black)
                .padding(.vertical, 32)
        }

    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(mainLogoTitle: "main logo", receptionURL: URL(string: ""))
    }
}
