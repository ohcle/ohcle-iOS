//
//  MemoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/29.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}

struct MemoView: View {
    private let mapImageName: String = "map"
    private let memoBackgroundColor = Color("DiaryBackgroundColor")

    @EnvironmentObject var currentPageType: MyPageType
    
    @Binding var isModal: Bool
    
    @State private var keyboardHeight: CGFloat = 0
    
    @State private var climbingLocationPlaceHolder: String = CalendarDataManger.shared.record.climbingLocation.name
    @State private var typedText: String =  CalendarDataManger.shared.record.temMemo
    @State private var color = Color.convert(from: CalendarDataManger.shared.record.temLevel)
    @State private var date = CalendarDataManger.shared.record.temDate
    @State private var score =  CalendarDataManger.shared.record.temScore
    @State private var photoData =  CalendarDataManger.shared.record.temPhoto
    @State private var isEdited = false
    
    @Binding var selectedTab: Int
    
    @State private var showAlert = false
    @State private var alertMsg  = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                .padding(.top, 20)
            
            Text("\(date.convertToOhcleDateLiteral())")
                .font(.title)
            
            HStack(spacing: 5) {
                Image(systemName: mapImageName)
                Text(climbingLocationPlaceHolder)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, -5)
            
            HStack() {
                ScoreStar(rating: .constant(Int(score)))
            }
            
            VStack(alignment: .leading) {
                Text("MEMO")
                    .font(.title)
                    .bold()
                    .padding(.top, 10)
                
                Divider()
                    .frame(minHeight: 2)
                    .overlay(Color.black)
                    .padding(.top, -10)
                
                if photoData.isEmpty == false {
                    HStack {
                        Spacer()
                        Image(uiImage: UIImage(data: CalendarDataManger.shared.record.temPhoto) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                        Spacer()
                    }
                }
                
                
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                    if #available(iOS 16.0, *) {
                        TextEditor(text: $typedText)
                            .scrollContentBackground(.hidden)
                            .background(memoBackgroundColor)
                            .foregroundColor(Color.black)
                            .lineSpacing(5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onChange(of: typedText) { newValue in
                                if newValue.count >= 100 {
                                    typedText = String(typedText.prefix(100))
                                    
                                    alertMsg = "최대글자는 100자 제한입니다."
                                    showAlert = true
                                }
                            }
                    } else {
                        TextEditor(text: $typedText)
                            .background(memoBackgroundColor)
                            .foregroundColor(Color.black)
                            .lineSpacing(5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onChange(of: typedText) { newValue in
                                if newValue.count >= 100 {
                                    typedText = String(typedText.prefix(100))
                                    
                                    alertMsg = "최대글자는 100자 제한입니다."
                                    showAlert = true
                                }
                            }
                    }
                        
                    
                    if typedText.isEmpty {
                        Text(" 오늘의 클라이밍은 어땠나요?")
                            .foregroundColor(.gray)
                            .lineSpacing(5)
                            .padding(.top,10)
                    }

                }

            }
            Spacer()
            HStack {
                Spacer()
                MemoButton(isEdited: $isEdited) {
                        CalendarDataManger.shared.record.saveTemporaryMemo(typedText)
                        RecNetworkManager.shared.saveDiaryToServer { res in
                            if !res {

                            } else {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        currentPageType.type = .done
                                        currentPageType.type = .calender
                                    }
                                }
                                NotificationCenter.default.post(name: NSNotification.Name("fetchCalendarData"),
                                                                object: nil, userInfo: nil)
                                self.selectedTab = 1
                                CalendarDataManger.shared.record.clearRecord()
                            }
                        }
                }
                Spacer()
            }
            Spacer()
        }
        .offset(y: -self.keyboardHeight)

        .padding(.leading, 30)
        .padding(.trailing, 30)
        .ignoresSafeArea(.keyboard)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return
                }
                
                self.keyboardHeight = keyboardFrame.height / 2
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                
                self.keyboardHeight = 0
            }
        }
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMsg))
        }
        
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)

        }
    }
}
//struct MemoView_Previews: PreviewProvider {
//    static let mocRecorded = RecordedMemo(id:0,date: "dd", location: "dd", level: "Ddd", score: 2, imageData: Data(), memo: "ddd")
//    @State static var isEdited: Bool = false
//    @State static var isModal: Bool = false
//    @State static var selectedTab:Int = 2
//
//    static var previews: some View {
//        MemoView(isModal: $isModal, selectedTab: $selectedTab)
//    }
//}
