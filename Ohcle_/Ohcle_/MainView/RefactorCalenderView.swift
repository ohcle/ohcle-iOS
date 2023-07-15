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

final class CalenderData: ObservableObject {
    @Published var year: String = "2023"
    @Published var month: String = OhcleDate.currentMonthString ?? ""
    @Published var switchWhenMemoChanged: Bool = false
    @Published var data: DividedMonthDataType = [:]
    @Published var weekCnt = 5
    
    private(set) var dateRange: [(date: Date, isCurrentMonth: Bool)]?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $year.combineLatest($month)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] year, month in
                self?.setWeekCnt()
                self?.fetchCalenderData()
                self?.changeSelectedDate()
                self?.dateRange = self?.organizeDateRange()
            }
            .store(in: &cancellables)
        
        $switchWhenMemoChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] changedValue in
                self?.fetchCalenderData()
            }
            .store(in: &cancellables)
        
        setWeekCnt()
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveFetchCalendarNotification(_:)), name: NSNotification.Name("fetchCalendarData"), object: nil)
    }
    
    @objc func didRecieveFetchCalendarNotification(_ notification: Notification) {
        print("Fetch")
        fetchCalenderData()
     }
    
    func fetchCalenderData() {
        guard let url = URL(string: OhcleURLs.generateMonthRecordURLString(year: self.year, month: self.month)) else {
            return
        }
        
        do {
            var request = try URLRequest(url: url, method: .get)
            
            request.headers.add(name: "Authorization",
                                 value: "Bearer " + LoginManager.shared.ohcleAccessToken)
            print(LoginManager.shared.ohcleAccessToken, "💜")
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode != 200 {
                    print(response.statusCode)
                }
                
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode([CalenderModel].self, from: data)
                        let divided = self.divideWeekData(decoded)
                        print(divided)
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
        var dividedData: DividedMonthDataType = [1: [:], 2: [:], 3: [:],
                                                 4: [:], 5: [:], 6:[:]]
        print("dividedData", dividedData)
        
        _ = data.map { data in
            let dateString = data.when
            let date = dateFormatter.date(from: dateString) ?? Date()
            
            let weekOfMonth = calendar.component(.weekOfMonth, from: date)
            let dayOfWeek = getDayOfWeek(dateString: dateString)
            // 0: 일요일, 1: 월, 2: 화, 3: 수
            if dayOfWeek == 0 {
                dividedData[weekOfMonth - 1]?.updateValue(data, forKey: 7)
            } else {
                dividedData[weekOfMonth]?.updateValue(data, forKey: dayOfWeek)

            }
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
    
    func organizeDateRange() -> [(date: Date, isCurrentMonth: Bool)] {
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
                _ = calendar.dateComponents([.year, .month], from: previousMonthDate)
                let date = calendar.date(byAdding: .day, value: day - (previousMonthRange.upperBound - previousMonthOffset),
                                         to: previousMonthDate)!
                dates.append((date, false))
            }
            
            // Add dates from the current month
            for day in 1...numberOfDaysInMonth {
                let date = calendar.date(byAdding: .day, value: day - 1, to: startDate)!
                dates.append((date, true))
            }
            
            // Calculate the number of days to display from the next month
            let remainingDays = 42 - (previousMonthOffset + numberOfDaysInMonth)
            let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
            
            // Add dates from the next month
            for day in 1...remainingDays {
                let date = calendar.date(byAdding: .day, value: day - 1, to: nextMonthDate)!
                dates.append((date, false))
            }
            
            print("💜",dates, "💜")
            return dates
    }
    
    func setWeekCnt() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "kr")
        let calendar = Calendar(identifier: .gregorian)
        
        guard let startDate = dateFormatter.date(from: self.year + "-" + self.month + "-" + "01") else { return }
        guard let lastDayOfMonth = calendar.range(of: .day, in: .month, for: startDate) else { return }
        guard let lastDate = dateFormatter.date(from: self.year + "-" + self.month + "-" + String(lastDayOfMonth.upperBound-1)) else { return }
        guard let startWeekday = calendar.dateComponents([.year, .month, .weekday], from: startDate).weekday else { return }

        var curDate = 1
        var weekCnt = 1 + Int(((lastDayOfMonth.upperBound - 1) - curDate) / 7)
        curDate = curDate + Int(((lastDayOfMonth.upperBound - 1) - curDate) / 7) * 7
        let remainDay = (lastDayOfMonth.upperBound - 1) - curDate
        if (startWeekday + remainDay) > 7 {
            weekCnt += 1
        }
        
        self.weekCnt = weekCnt
    }
    
}

struct RefactorCalenderView: View {
    @State private var isSelected: Bool = false
    @State private var isDismissed: Bool = true
    @State private var isModal: Bool = true
    
    @ObservedObject var calenderData: CalenderData
    
    var body: some View {
        ZStack {
            VStack {
                UpperBar {
                    calenderData.fetchCalenderData()
                }
                
                Spacer()
                
                CalenderMiddleView(yearString: self.calenderData.year,
                                   monthString: self.calenderData.month,
                                   isDismissed: $isDismissed)
                CalenderHolderView(calenderData: calenderData)
                
                Spacer()
            }
            .padding(.all, 10)
            
            if !self.isDismissed {
                withAnimation {
                    DateFilterView(currentYear: 2023, isSelected: $isSelected,
                                   isDismissed: $isDismissed, calenderData: calenderData)
                    .frame(minWidth: 250, idealWidth: 250, maxWidth: 250, minHeight: 250,
                           idealHeight: 250, maxHeight: 250, alignment: .center)
                    .background(Color.white)
                    .padding(.top, -30)
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
    @State private var dateRange:  [(date: Date, isCurrentMonth: Bool)]?
    // 해당 월이 몇 주까지 가지고 있는지
    init(calenderData: CalenderData) {
        self.calenderData = calenderData
        self.isModal = isModal
        self.diaryID = diaryID
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(1...calenderData.weekCnt, id:\.self) { week in
                HStack(spacing: 0) {
                    ForEach(0...6, id: \.self) { day in
                        let level = calenderData.data[week]?[day]?.level ?? 11
                        let holderColor: HolderColorNumber = HolderColorNumber(rawValue: "\(level)") ?? .red
                        let holderType = HolderType(holderColor: holderColor, nil)
                        
                        CalenderHolderGridView(isClimbedDate: true,
                                               holderType: holderType,
                                               date: calenderData.dateRange?[((week - 1) * 7 + day)])
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
                        isMemoChanged: $calenderData.switchWhenMemoChanged,
                        id: $diaryID)
        }
    }
}

struct CalenderMiddleView: View {
    private let title: String = "클라이밍 히스토리"
    var yearString: String
    var monthString: String
    @Binding var isDismissed: Bool
    
    var body: some View {
        Text(title)
            .font(.title)
            .padding(.bottom, 10)
        Button {
            self.isDismissed.toggle()
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
