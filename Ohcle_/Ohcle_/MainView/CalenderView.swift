//
//  CalenderView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/01/23.
//

import SwiftUI

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class CalenderData: ObservableObject {
    @Published var year: String = "2024"
    @Published var month: String = "04"
    @Published var isClimbingMemoAdded: Bool = false
    @Published var data: [Int: [CalenderViewModel]] = [:]

}

struct CalenderView: View {
    private var year: String = "2024"
    private var month: String = "04"
    @ObservedObject var calenderData: CalenderData = CalenderData()
    
    private var mockData: [CalenderViewModel] {
        let emptyArray: [CalenderViewModel] = []
        let decoder = JSONDecoder()
        
        guard let path = Bundle.main.path(forResource: "CalenderViewMockData", ofType: "json") else {
            return emptyArray
        }
        
        guard let jsonString = try? String(contentsOfFile: path) else {
            return emptyArray
        }
        
        guard let data = jsonString.data(using: .utf8) else {
            return emptyArray
        }
        
        do {
            let mockData = try decoder.decode([CalenderViewModel].self, from: data)
            return mockData
        } catch {
            print(error)
            return emptyArray
        }
    }
    
    
    var body: some View {
        VStack {
            UpperBar()
            Spacer()
            Text("클라이밍 히스토리")
                .font(.title)
                .padding(.bottom, 10)
            Text("\(OhcleDate.currentYear ?? "2023")")
                .foregroundColor(.gray)
            Text("\(OhcleDate.currentMonth ?? 0)")
                .font(.system(size: 60))
            
            VStack(spacing: 0) {
                let data = divideWeekData()
                ForEach(1...5, id:\.self) { week in
                    HStack(spacing: 0) {
                        ForEach(0...6, id: \.self) { day in
                            if (data[week]?[safe: day]) == nil {
                                CalenderHolderGridView(holderType: nil)
                            } else {
                                let level = data[week]?[day].level ?? 11
                                
                                let holderColor: HolderColorNumber = HolderColorNumber(rawValue: "\(level)") ?? .red
                                let holderType = HolderType(holderColor: holderColor, nil)
                                CalenderHolderGridView(isClimbedDate: true, holderType: holderType)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func divideWeekData() -> [Int: [CalenderViewModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier:
                                        "kr")
        let calendar = Calendar.current
        var dividedData: [Int: [CalenderViewModel]] = [:]
        
        self.mockData.map { data in
            let dateString = data.when
            let date = dateFormatter.date(from: dateString)
            
            let weekOfMonth = calendar.component(.weekOfMonth, from: date ?? Date())
            if (dividedData[weekOfMonth]) != nil {
                dividedData[weekOfMonth]?.append(data)
            } else {
                dividedData.updateValue([data], forKey: weekOfMonth)
            }
            return dividedData
        }
        
        return [:]
    }
    
    private func generateRandomHolderBackground(_ typeNumber: Int) -> HolderLocatedType {
        if typeNumber == .zero {
            return HolderLocatedType.big
        } else {
            return HolderLocatedType.small
        }
    }
}

struct UpperBar: View {
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image("MainRefresh")
            }
            
            Spacer()
            
            Button {
            } label: {
                Image("MainShare")
            }
        }
        .padding(.horizontal)
    }
}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        CalenderView()
    }
}
