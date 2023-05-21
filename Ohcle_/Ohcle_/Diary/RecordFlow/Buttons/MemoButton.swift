//
//  OhcleButton.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI
import Foundation

enum FatalError: Error {
    case invalidStatusCode
}

enum MemoState: String {
    case edit = "수정하기"
    case save = "저장하기"
}

struct MemoButton: View {
    private var title: String {
        get {
            if self.isEdited {
                return MemoState.edit.rawValue
            } else {
                return MemoState.save.rawValue
            }
        }
    }
    
    private let memoButtonColor: String = "editButton"
    private let memoButtonRadius: CGFloat = 8.0
    @Binding var isEdited: Bool
    
    @State var action: (() -> ())?
    
    var body: some View {
        Button {
            action?()
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

struct OhcleButton_Previews: PreviewProvider {
    @State static var isEdited = true
    
    static var previews: some View {
        MemoButton(isEdited: $isEdited)
    }
}
