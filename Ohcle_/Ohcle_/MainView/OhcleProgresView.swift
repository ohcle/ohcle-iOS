//
//  OhcleProgresView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/12/05.
//

import SwiftUI

struct OhcleProgresView: View {
    @Binding var isActivated: Bool
    let progressView = ProgressView()
    
    var body: some View {
        if self.isActivated {
            progressView
        }
    }
}


struct OhcleProgresView_Previews: PreviewProvider {
    @State static var isActivated: Bool = false

    static var previews: some View {
        OhcleProgresView(isActivated: $isActivated)
    }
}
