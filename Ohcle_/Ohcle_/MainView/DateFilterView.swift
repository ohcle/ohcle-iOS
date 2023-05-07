//
//  DateFilterView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/22.
//

import SwiftUI

class CalenderData {
    
}

struct DateFilterView: View {
    @State var currentYear: Int
    @State var monthData: [String] = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    @State var selectedMonth = ""
    @Binding var isSelected: Bool
    @Binding var isDismissed: Bool
    
    var calenderData: CalenderData
    
    private let defaultYear = "2023"
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
                    CircleDate(title: month,
                               color: Color("holder_background"), touchedColor: .orange) {
                        self.isSelected = true

                        withAnimation {
                            self.isDismissed = true
                            self.selectedMonth = month
//                            self.calenderData.month = selectedMonth
//                            self.calenderData.year = "\(currentYear)"
                        }
                    }
                }
            }
            .padding(.all)
        }
        .padding(.all)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 0.5)
        )
    }
}

//struct DateFilterView_Previews: PreviewProvider {
//    @State static var isSelected = true
//    @State static var isdismissed = true
//    
////    @ObservedObject static var calenderData: CalenderData = CalenderData()
//    static var previews: some View {
//        DateFilterView(currentYear: 2023, isSelected: $isSelected, isDismissed: $isdismissed, calenderData: calenderData)
//    }
//}
