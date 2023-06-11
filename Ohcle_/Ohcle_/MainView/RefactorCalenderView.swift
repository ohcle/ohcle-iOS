//
//  RefacotCalenderView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/05/04.
//

import SwiftUI
import Combine

typealias DividedMonthDataType = [Int: [Int: CalenderModel]]

func getDayOfWeek(dateString: String) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "kr")
    let date = dateFormatter.date(from: dateString) ?? Date()
    
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.weekday], from: date)
    guard let weekday = components.weekday else {
        return .zero
    }
    
    return weekday - 1
}

class CalenderData: ObservableObject {
    @Published var year: String = "2023"
    @Published var month: String = OhcleDate.currentMonthString ?? ""
    @Published var switchWhenMemoChanged: Bool = false
    @Published var data: DividedMonthDataType = [:]
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $year.combineLatest($month)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] year, month in
                self?.fetchCalenderData()
                self?.changeSelectedDate()
            }
            .store(in: &cancellables)
        
        $switchWhenMemoChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] changedValue in
                self?.fetchCalenderData()
            }
            .store(in: &cancellables)
    }
    
    func fetchCalenderData() {
        guard let url = URL(string: OhcleURLs.generateMonthRecordURLString(year: self.year, month: self.month)) else {
            return
        }
        
        do {
            var request = try URLRequest(url: url, method: .get)
//            request.setValue("token \(LoginManager.shared.ohcleID)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode != 200 {
                    print(response.statusCode)
                }
                
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode([CalenderModel].self, from: data)
                        let divided = self.divideWeekData(decoded)
                        
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
    
    private func divideWeekData(_ data: [CalenderModel]) -> DividedMonthDataType {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "kr")
        let calendar = Calendar(identifier: .gregorian)
        var dividedData: DividedMonthDataType = [1: [:], 2: [:], 3: [:], 4: [:], 5: [:]]
        
        data.map { data in
            let dateString = data.when
            let date = dateFormatter.date(from: dateString) ?? Date()
            
            let weekOfMonth = calendar.component(.weekOfMonth, from: date)
            let dayOfWeek = getDayOfWeek(dateString: dateString)
            
            dividedData[weekOfMonth]?.updateValue(data, forKey: dayOfWeek)
        }
        
        return dividedData
    }
    
    private lazy var selectedDate: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM yyyy"
        let dateString = self.month + " " + self.year
        
        if let selectedDate = dateFormatter.date(from: dateString) {
            return selectedDate
        } else {
            print("Invalid date format")
            return Date()
        }
    }()
    
    private let calendar: Calendar = {
        var calender =  Calendar.current
        calender.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calender.locale = Locale(identifier: "ko_KR")
        return calender
    }()
    
    
    func changeSelectedDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM yyyy"
        let dateString = self.month + " " + self.year
        if let selectedDate = dateFormatter.date(from: dateString) {
            self.selectedDate = selectedDate
            print(dateFormatter.string(from: selectedDate))
        } else {
            print("Invalid date format")
        }
    }
    
    private var startDate: Date {
        let components = calendar.dateComponents([.month, .day], from: selectedDate)
        return calendar.date(from: components)!
    }
    
    private var endDate: Date {
        let components = DateComponents(month: 1, day: -1)
        return calendar.date(byAdding: components, to: startDate)!
    }
    
    private var monthOfSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private func isSameMonth(date: Date) -> Bool {
        return calendar.isDate(date, equalTo: startDate, toGranularity: .month)
    }
    
    private func dayOfMonth(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private func nextMonth() {
        selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate)!
    }
    
    private func previousMonth() {
        selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate)!
    }
    
    func dateRange() -> [(date: Date, isCurrentMonth: Bool)] {
        var dates: [(date: Date, isCurrentMonth: Bool)] = []
            
            let components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
            let startDate = calendar.date(from: components)!
            
            let startComponents = calendar.dateComponents([.year, .month, .weekday], from: startDate)
            let startWeekday = startComponents.weekday!
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: startDate)!.count
            
            // Calculate the number of days to display from the previous month
            let previousMonthOffset = (startWeekday - calendar.firstWeekday + 7) % 7
            let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: startDate)!
            let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonthDate)!
            
            // Add dates from the previous month
            for day in (previousMonthRange.upperBound - previousMonthOffset)..<previousMonthRange.upperBound {
                let components = calendar.dateComponents([.year, .month], from: previousMonthDate)
                let date = calendar.date(byAdding: .day, value: day - (previousMonthRange.upperBound - previousMonthOffset), to: previousMonthDate)!
                dates.append((date, false))
            }
            
            // Add dates from the current month
            for day in 1...numberOfDaysInMonth {
                let components = calendar.dateComponents([.year, .month], from: startDate)
                let date = calendar.date(byAdding: .day, value: day - 1, to: startDate)!
                dates.append((date, true))
            }
            
            // Calculate the number of days to display from the next month
            let remainingDays = 42 - (previousMonthOffset + numberOfDaysInMonth)
            let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
            let nextMonthRange = calendar.range(of: .day, in: .month, for: nextMonthDate)!
            
            // Add dates from the next month
            for day in 1...remainingDays {
                let components = calendar.dateComponents([.year, .month], from: nextMonthDate)
                let date = calendar.date(byAdding: .day, value: day - 1, to: nextMonthDate)!
                dates.append((date, false))
            }
            
            return dates
    }
}

struct RefacotCalenderView: View {
    @State private var isSelected: Bool = false
    @State private var isDismissed: Bool = true
    @State private var isModal: Bool = true
    
    @ObservedObject var calenderData: CalenderData = CalenderData()
    
    var body: some View {
        ZStack {
            VStack {
                UpperBar {
                    calenderData.fetchCalenderData()
                }
                Spacer()
                CalenderMiddleView(yearString: self.calenderData.year,
                                   monthString: self.calenderData.month) {
                    self.isDismissed = false
                }
                
                CalenderHolderView(calenderData: calenderData)
                
                Spacer()
            }
            
            if !self.isDismissed {
                withAnimation {
                    DateFilterView(currentYear: 2023, isSelected: $isSelected,
                                   isDismissed: $isDismissed, calenderData: calenderData)
                    .frame(width: 250, height: 250, alignment: .center)
                    .background(Color.white)
                    .padding(.top, 20)
                    .onDisappear {
                        self.calenderData.changeSelectedDate()
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

struct CalenderHolderView: View {
    @ObservedObject var calenderData: CalenderData
    @State private var isModal: Bool = false
    @State private var diaryID: Int = .zero
    
    init(calenderData: CalenderData) {
        self.calenderData = calenderData
        self.isModal = isModal
        self.diaryID = diaryID
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(1...5, id:\.self) { week in
                HStack(spacing: 0) {
                    ForEach(1...7, id: \.self) { day in
                        let level = calenderData.data[week]?[day]?.level ?? 11
                        let holderColor: HolderColorNumber = HolderColorNumber(rawValue: "\(level)") ?? .red
                        let holderType = HolderType(holderColor: holderColor, nil)
                        
                        CalenderHolderGridView(isClimbedDate: true,
                                               holderType: holderType,
                                               date: calenderData.dateRange()[((week - 1) * 7 + day)])
                        .onTapGesture {
                            if let recordID = calenderData.data[week]?[day]?.id {
                                diaryID = recordID
                                self.isModal = true
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isModal) {
            NewMemoView(isModalView: $isModal,
                        isMemoChanged: $calenderData.switchWhenMemoChanged, id: $diaryID)
        }
    }
    
}

struct CalenderMiddleView<Content>: View {
    let content: () -> Content
    let title: String
    var yearString: String
    var monthString: String
    
    init(title: String = "클라이밍 히스토리",
         yearString: String,
         monthString: String,
         content: @escaping () -> Content) {
        self.title = title
        self.yearString = yearString
        self.monthString = monthString
        self.content = content
    }
    
    var body: some View {
        Text(title)
            .font(.title)
            .padding(.bottom, 10)
        Button {
            content()
        } label: {
            VStack {
                Text("\(yearString)")
                    .foregroundColor(.gray)
                Text("\(monthString)")
                    .font(.system(size: 50))
                    .foregroundColor(.black)
            }
        }
    }
}

struct UpperBar: View {
    var action: (() -> ())?
    var body: some View {
        HStack {
            Button {
                action?()
            } label: {
                Image("MainRefresh")
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct RefacotCalenderView_Previews: PreviewProvider {
    static var previews: some View {
        RefacotCalenderView()
    }
}
