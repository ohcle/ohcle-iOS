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

class CalenderData: ObservableObject {
    @Published var year: String = "2023"
    @Published var month: String = "03"
    @Published var isClimbingMemoAdded: Bool = false
    @Published var data: [Int: [CalenderViewModel]] = [:]
    
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
    
    private func divideWeekData2(_ data: [CalenderViewModel]) -> [Int: [CalenderViewModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier:
                                        "kr")
        let calendar = Calendar.current
        var dividedData: [Int: [CalenderViewModel]] = [:]
        
        print(data)
        data.map { data in
            let dateString = data.when
            let date = dateFormatter.date(from: dateString)
            
            let weekOfMonth = calendar.component(.weekOfMonth, from: date ?? Date())
            if (dividedData[weekOfMonth]) != nil {
                dividedData[weekOfMonth]?.append(data)
            } else {
                dividedData.updateValue([data], forKey: weekOfMonth)
            }
        }
        
        return dividedData
    }
}

struct CalenderView: View {
    @State private var isSelected: Bool = false
    @State private var isDismissed: Bool = true
    
    @ObservedObject var calenderData: CalenderData = CalenderData()
    
    private func fetchCalenderData() async {
        do {
            let fetchedData = try await fetchData(urlString: URLs.generateMonthRecordURLString(year: self.calenderData.year, month: self.calenderData.month), method: .get)
            print(fetchedData)
            let decoded = try JSONDecoder().decode([CalenderViewModel].self, from: fetchedData)
            print(decoded)
            
            let divided = divideWeekData2(decoded)
            
            self.calenderData.data = divided
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                UpperBar()
                Text("클라이밍 히스토리")
                    .font(.title)
                    .padding(.bottom, 10)
                
                Button {
                    self.isDismissed.toggle()
                } label: {
                    Text("\(self.calenderData.year)")
                        .foregroundColor(.gray)
                }
                
                Button {
                    self.isDismissed.toggle()
                } label: {
                    Text("\(self.calenderData.month)")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                }
                
                VStack(spacing: 0) {
                    let data = self.calenderData.data
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
            .task {
                await fetchCalenderData()
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
    
    private func divideWeekData2(_ data: [CalenderViewModel]) -> [Int: [CalenderViewModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier:
                                        "kr")
        let calendar = Calendar.current
        var dividedData: [Int: [CalenderViewModel]] = [:]
        
        print(data)
        data.map { data in
            let dateString = data.when
            let date = dateFormatter.date(from: dateString)
            
            let weekOfMonth = calendar.component(.weekOfMonth, from: date ?? Date())
            if (dividedData[weekOfMonth]) != nil {
                dividedData[weekOfMonth]?.append(data)
            } else {
                dividedData.updateValue([data], forKey: weekOfMonth)
            }
        }
        
        return dividedData
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
