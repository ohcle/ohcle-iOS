//
//  AddNewDiary.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct AddNewDiary: View {
    @State private var imageSize = CGSize()
    var body: some View {
        VStack{
            DiaryHeader()
            Spacer()
            
            Group {
                Image("add-diary")
                    .readSize { size in
                        imageSize = size
                    }
                Text("아직 기록이 없어요! \n +버튼을 눌러 기록해주세요")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

struct AddNewDiary_Previews: PreviewProvider {
    static var previews: some View {
        AddNewDiary()
    }
}
