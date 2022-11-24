//
//  MyPageLogoutView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct MyPageLogoutView: View {
    var body: some View {
        GeometryReader { geometry in

            VStack(alignment: .center, spacing: 20) {
                Image("mypage-logout-placeholder")
                
                (Text("계정\n")
                    .foregroundColor(.gray)
                +
                Text("annamong@gmail.com"))
                .multilineTextAlignment(.center)

                    Button() {
                        
                    } label: {
                        Text("로그아웃")
                            .font(.body)
                            .frame(width: geometry.size.width * 8/10
                            )
                            .padding()
                            .background(Color("saveButtonColor"))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 76)
                Text("탈퇴하기")
                
            }.padding()

        }
    }
}


struct MyPageLogoutView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageLogoutView()
    }
}
