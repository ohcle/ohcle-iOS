//
//  DateFilterView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/22.
//

import SwiftUI

struct DateFilterView: View {
    @State var currentYear: Int
    @State var monthData: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    
    private let defaultYear = "2030"
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = ""
        return numberFormatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                Button("<") {
                    self.currentYear -= 1
                }
                .padding(.trailing, 50)
                .foregroundColor(.black)
                
                Text("\(numberFormatter.string(for: currentYear) ?? defaultYear)")
                Button(">") {
                    self.currentYear += 1
                }
                .padding(.leading, 50)
                .foregroundColor(.black)
            }
            
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()], alignment: .center, spacing: CGFloat(20)) {
                ForEach(monthData, id: \.self) { month in
                    CircleDate(title: month, color: Color.gray, touchedColor: .orange) {
                        
                    }
                }
            }
            .padding(.all)
        }
        .padding(.all)
    }
}

struct DateFilterView_Previews: PreviewProvider {
    static var previews: some View {
        DateFilterView(currentYear: 2023)
    }
}
