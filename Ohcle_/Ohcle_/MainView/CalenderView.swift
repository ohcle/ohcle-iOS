//
//  CalenderView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/01/23.
//

import SwiftUI

struct CalenderView: View {
    @State private var dummy: Bool = false

    var body: some View {
        
        VStack {
            Text("클라이밍 히스토리")
                .font(.title)
                .padding(.bottom, 10)
            Text("\(OhcleDate.currentYear ?? "2023")")
                .foregroundColor(.gray)
            Text("\(OhcleDate.currentMonth ?? 0)")
                .font(.system(size: 60))
                
 
            VStack(spacing: 0) {
                ForEach(0...4, id:\.self) { _ in
                    HStack(spacing: 0) {
                        ForEach(1...7, id: \.self) { _ in
                            let randomNumber: Int = (0...1).randomElement()!
                            CalenderHolderGridView(isClimbedDate: $dummy,
                                                   holderLocatedType: generateRandomHolderBackground(randomNumber),
                                                   holderType: .init(color: .gray,
                                                                     date: "ddddd", holderShape: .red_1))
                        }
                    }
                }
            }
        }
        
        
    }
    
    private func generateRandomHolderBackground(_ typeNumber: Int) -> HolderLocatedType {
        if typeNumber == .zero {
            return HolderLocatedType.big
        } else {
            return HolderLocatedType.small
        }
    }
}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        CalenderView()
    }
}
