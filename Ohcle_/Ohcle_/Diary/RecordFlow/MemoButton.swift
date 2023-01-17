//
//  OhcleButton.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

enum MemoState: String {
    case edit = "수정하기"
    case save = "저장하기"
}

struct MemoButton: View {
    @State private var title: String = MemoState.save.rawValue
    private let memoButtonColor: String = "editButton"
    private let memoButtonRadius: CGFloat = 8.0

    var body: some View {
        GeometryReader { geometry in
            Button {
                
            } label: {
                Text(title)
                    .fontWeight(.bold)
                    .font(.title3)
                    .padding()
                    .background(Color(memoButtonColor))
                    .cornerRadius(memoButtonRadius)
                    .foregroundColor(.white)
            }
        }
    }
    
    func changeButtonTitleToEdit() {
        self.title = MemoState.edit.rawValue
    }
}

struct OhcleButton_Previews: PreviewProvider {
    static var previews: some View {
        MemoButton()
    }
}
