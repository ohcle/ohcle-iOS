//
//  CalenderView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/01/23.
//

import SwiftUI
import Combine

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

typealias DividedMonthDataType = [Int: [Int: CalenderViewModel]]

class CalenderData: ObservableObject {
    @Published var year: String = "2023"
    @Published var month: String = "03"
    @Published var isClimbingMemoAdded: Bool = false
    @Published var data: DividedMonthDataType = [:]
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $year.combineLatest($month)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] year, month in
                self?.fetchCalenderData()
            }
            .store(in: &cancellables)
    }
    
    private func fetchCalenderData() {
        guard let url = URL(string: URLs.generateMonthRecordURLString(year: self.year, month: self.month)) else {
            return
        }
        
        do {
            let request = try URLRequest(url: url, method: .get)
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode != 200 {
                    print(response.statusCode)
                }
                
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode([CalenderViewModel].self, from: data)
                        let divided = self.divideWeekData2(decoded)
                        
                        DispatchQueue.main.async {
                            self.data = divided
                        }
                    } catch {
                        print(error)
                    }
                    
                }
            }.resume()
            
        } catch {
            print(error)
        }
    }
    
    private func getDayOfWeek(dateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "kr")
        let date = dateFormatter.date(from: dateString) ?? Date()
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: date)
        guard let weekday = components.weekday else {
            return .zero
            
        }
        
        return weekday
    }
    
    private func divideWeekData2(_ data: [CalenderViewModel]) -> DividedMonthDataType {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier:
                                        "kr")
        let calendar = Calendar(identifier: .gregorian)
        var dividedData: DividedMonthDataType = [1: [:], 2: [:], 3: [:], 4: [:], 5: [:]]
        
        print(data)
        data.map { data in
            let dateString = data.when
            let date = dateFormatter.date(from: dateString) ?? Date()
            
            let weekOfMonth = calendar.component(.weekOfMonth, from: date)
            let dayOfWeek = getDayOfWeek(dateString: dateString)
            
            print(weekOfMonth, dayOfWeek, dateString)

            dividedData[weekOfMonth]?.updateValue(data, forKey: dayOfWeek)
        }
        
        print(dividedData)
        return dividedData
    }
}

struct CalenderView: View {
    @State private var isSelected: Bool = false
    @State private var isDismissed: Bool = true
    
    @ObservedObject var calenderData: CalenderData = CalenderData()
    
    var body: some View {
        ZStack {
            VStack {
                UpperBar()
                Spacer()
                Text("클라이밍 히스토리")
                    .font(.title)
                    .padding(.bottom, 10)
                
                Button {
                    self.isDismissed = false
                } label: {
                    VStack {
                        Text("\(self.calenderData.year)")
                            .foregroundColor(.gray)
                        Text("\(self.calenderData.month)")
                            .font(.system(size: 50))
                            .foregroundColor(.black)
                    }
                }
                
                VStack(spacing: 0) {
                    let data = self.calenderData.data
                    ForEach(1...5, id:\.self) { week in
                        HStack(spacing: 0) {
                            ForEach(1...7, id: \.self) { date in
                                if (data[week]?[date] != nil) {
                                    let level = data[week]?[date]?.level ?? 11

                                    let holderColor: HolderColorNumber = HolderColorNumber(rawValue: "\(level)") ?? .red
                                    
                                    let holderType = HolderType(holderColor: holderColor, nil)
                                    
                                    CalenderHolderGridView(isClimbedDate: true, holderType: holderType)
                                } else {
                                    CalenderHolderGridView(holderType: nil)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            
            if !self.isDismissed {
                withAnimation {
                    DateFilterView(currentYear: 2023, isSelected: $isSelected, isDismissed: $isDismissed, calenderData: calenderData)
                        .frame(width: 250, height: 250, alignment: .center)
                        .background(Color.white)
                        .padding(.top, 20)
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

struct UpperBar: View {
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image("MainRefresh")
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        CalenderView()
    }
}
