//
//  SwiftUIView.swift
//  Ohcle_
//
//  Created by yeongbin ro on 2023/03/29.
//

import SwiftUI


struct OnBoardingView: View {
    private var pageCount = 4
    @State private var curPage = 0
    let completeProcess: () -> ()
    
    init(completeProcess: @escaping () -> Void) {
        self.completeProcess = completeProcess
    }
    
    let upperViews:[AnyView] = [
        AnyView(UpperView01()),
        AnyView(UpperView02()),
        AnyView(UpperView03()),
        AnyView(UpperView04())
    ]
    
    let bottomImages:[AnyView] = [
        AnyView(Image("OnBoarding01"))
        ,AnyView(Image("OnBoarding02"))
        ,AnyView(Image("OnBoarding03"))
        ,AnyView(Image("OnBoarding04"))
    ]

    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    if curPage + 1 < pageCount {
                        curPage = (curPage + 1) % pageCount
                    }
                }
            
            
            VStack {
                    
                    upperViews[curPage]
                    
                    HStack {
                        ForEach(0..<4) { index in
                            Circle()
                                .fill(curPage == index ? .orange : .gray)
                                .frame(width: 10, height: 10)
                                .animation(.spring().delay(Double(abs(curPage - index)) * 0.1), value: true)
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 38)
                    .padding(.bottom, 90)
                    .padding(.top, 20)
                    

                    VStack {
                        bottomImages[curPage]
                        
                        if curPage+1 == pageCount {

                            Button(action: {
                                self.completeProcess()
                            }, label: {
                                Text("기록시작하기")
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .frame(width: 320, height: 70)
                                    .background(Color("editButton"))
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                                
                            })
                            .padding(.top, 80)
                            .padding(.bottom, 40)
                        }
                    }
                    .frame(height: UIScreen.main.bounds.size.height / 2, alignment: .bottom)
                    
                    
                }
                .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .bottom)
                .padding(.top, 50)
                .onTapGesture {
                    if curPage + 1 < pageCount {
                        curPage = (curPage + 1) % pageCount
                    }
                }
//            .background(.white)
        }

    }
    
    
}


extension EnvironmentValues {
    var bigFont: Font {
        get { self[bigFontKey.self] }
        set { self[bigFontKey.self] = newValue }
    }
    var smallFont: Font {
        get { self[smallFontKey.self] }
        set { self[smallFontKey.self] = newValue }
    }
    
}

struct bigFontKey: EnvironmentKey {
    static let defaultValue: Font = Font.system(size: 36)
}

struct smallFontKey: EnvironmentKey {
    static let defaultValue: Font = Font.system(size: 16)
}



struct UpperView01: View {
    @Environment(\.bigFont) var bigFont: Font
    
    var body: some View {
        HStack(spacing: 0) {
            Text("저번에")
                .font(bigFont)
            
            Text("어디서")
                .font(bigFont)
                .bold()
                .background(Color("TextBackground"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 38)
        Text("클라이밍 했더라?")
            .font(bigFont)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 38)
    }
}

struct UpperView02: View {
    @Environment(\.bigFont) var bigFont: Font
    
    var body: some View {
        HStack(spacing: 0) {
            Text("저번에")
                .font(bigFont)
            
            Text("언제")
                .font(bigFont)
                .bold()
                .background(Color("TextBackground"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 38)
        Text("클라이밍 했더라?")
            .font(bigFont)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 38)
    }
}


struct UpperView03: View {
    @Environment(\.bigFont) var bigFont: Font
    
    var body: some View {
        HStack(spacing: 0) {
            Text("저번에")
                .font(bigFont)
            
            Text("무슨 레벨로")
                .font(bigFont)
                .bold()
                .background(Color("TextBackground"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 38)
        Text("클라이밍 했더라?")
            .font(bigFont)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 38)
    }
}

struct UpperView04: View {
    @Environment(\.bigFont) var bigFont: Font
    @Environment(\.smallFont) var smallFont: Font
    
    var body: some View {
        VStack (alignment: .leading){
            Text("기록해두지 않으면 잊어버리니까!")
                .font(smallFont)
            
            HStack(spacing: 0) {
                Text("오늘의 클라이밍")
                    .font(bigFont)
                    .bold()
                Text("에")
                    .font(bigFont)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 38)
        Text("적어두세요")
            .font(bigFont)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 38)
    }
}




//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnBoardingView()
//    }
//}
