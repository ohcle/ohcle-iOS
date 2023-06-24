//
//  BackgroundHolderView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/06/24.
//

import SwiftUI

struct BackgroundHolderView: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(1...5, id:\.self) { week in
                HStack(spacing: 0) {
                    ForEach(1...7, id: \.self) { day in
                        CalenderHolderGridView(holderType: nil, date: nil)
                    }
                }
            }
        }
    }
}

struct BackgroundHolderView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundHolderView()
    }
}
