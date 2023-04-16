//
//  SplashView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/09.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        Image("main_logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.all, 40)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
