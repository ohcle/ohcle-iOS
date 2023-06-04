//
//  NewMemoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/05/07.
//

import SwiftUI
import UIKit

extension String {
    func convertToOhcleDateLiteral() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: self) else {
            fatalError("Failed to parse date")
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년 M월 d일"
        let formattedDate = outputFormatter.string(from: date)
        return formattedDate
    }
}

struct NewMemoView: View {
    private let mapImageName: String = "map"
    private let memoBackgroundColor = Color("DiaryBackgroundColor")
    
    @EnvironmentObject var currentPageType: MyPageType
    @Binding var isModalView: Bool
    @Binding var isMemoChanged: Bool

    @State private var isEdited = true
    @State private var isLevelCircleTapped = false
    @State private var isDateTapped = false
    @State private var isPhotoPickerTapped = false
    
    @Binding var id: Int
//    @State private var climbingLocation: String? = "클라임웍스 클라이밍"
    @State private var climbingLocation: ClimbingLocation = ClimbingLocation()
    @State private var typedText = ""
    @State private var levelColor = Color.yellow
    @State private var levelColorInt = 0
    @State private var date = "2020-02-02"
    @State private var score = 0
    
    @State private var photoData = Data()
    @State private var photo: Image?
    @State private var selectedPhoto: UIImage?
    @State private var convertedPhotoFilename: String?
    
    @State private var selectedColor: Color = .clear
    @State private var selectedDate: Date = Date()
    
    var deleteCompletion: ((Int) -> (Void))?
    
    private let colors: [Color] = [.red, .orange, .yellow,
                                   .green, .blue, .purple, .black, .gray, .white]
    
    private func converToLevelInt(color: Color) -> Int {
        switch color {
        case .red:
            return 1
        case .orange:
            return 2
        case .yellow:
            return 3
        case .green:
            return 4
        case .blue:
            return 5
        case .indigo:
            return 6
        case .purple:
            return 7
        case .black:
            return 8
        case .white:
            return 9
        case .gray:
            return 10
        default:
            return .zero
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                HStack{
                    Spacer()
                    Button {
                        Task {
                            await deleteMemo(id: self.id)
                            self.isModalView.toggle()
                            deleteCompletion?(self.id)
                        }
                        
                    } label: {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                    }
                }
                Button {
                    self.isLevelCircleTapped = true
                } label: {
                    Circle()
                        .fill(levelColor)
                        .frame(width: 30, height: 30)
                    
                    if isLevelCircleTapped {
                        Picker("", selection: $selectedColor) {
                            ForEach(colors, id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .pickerStyle(.wheel)
                        .background(.clear)
                        .cornerRadius(15)
                        .padding()
                        .onChange(of: selectedColor) { newValue in
                            withAnimation {
                                self.levelColor = selectedColor
                                self.isLevelCircleTapped = false
                                let colorInt = converToLevelInt(color: self.selectedColor)
                                self.levelColorInt = colorInt
                            }
                        }
                    }
                }
                
                Button {
                    self.isDateTapped = true
                } label: {
                    Text("\(date.convertToOhcleDateLiteral())")
                        .font(.title)
                        .foregroundColor(.black)
                    if isDateTapped {
                        DatePicker("Select a date",
                                   selection: $selectedDate,
                                   displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                    }
                }
                .onChange(of: selectedDate) { newValue in
                    withAnimation {
                        self.isDateTapped = false
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateString = dateFormatter.string(from: newValue)
                        self.date = dateString
                    }
                }
                
                HStack(spacing: 5) {
                    NavigationLink {
                        ClimbingLocationSearch(selectedLocation: $climbingLocation, selectedname: $climbingLocation.name)
                    } label: {
                        Image(systemName: mapImageName)
                            .foregroundColor(.gray)
                        Text(climbingLocation.name.isEmpty ? "오클 클라이밍" : climbingLocation.name)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(.bottom, -5)
                
// <<<<<<< develop_tacocat
//                 HStack {
//                     Spacer()
//                     photo?
//                         .resizable()
//                         .scaledToFit()
//                     PickerView(isShowingGalleryPicker: $isPhotoPickerTapped,
//                                selectedImage: $selectedPhoto)
//                     .sheet(isPresented: $isPhotoPickerTapped) {
//                         GalleryPickerView(isPresented: $isPhotoPickerTapped,
//                                           selectedImage: $selectedPhoto)
//                     }
//                     Spacer()
// =======
                HStack() {
                    ScoreStar(rating: $score)
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
                    
                    HStack {
                        Spacer()
                        photo?
                            .resizable()
                            .scaledToFit()
                        PickerView(isShowingGalleryPicker: $isPhotoPickerTapped,
                                   selectedImage: $selectedPhoto)
                        .sheet(isPresented: $isPhotoPickerTapped) {                 GalleryPickerView(isPresented: $isPhotoPickerTapped,
                                                                                                      selectedImage: $selectedPhoto)
                        }
                        Spacer()
                    }
                    
                    TextEditor(text: $typedText)
                        .scrollContentBackground(.hidden)
                        .background(memoBackgroundColor)
                        .foregroundColor(Color.black)
                        .lineSpacing(5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//>>>>>>> develop
                }
                
                Spacer()
                HStack {
                    Spacer()
                    MemoButton(isEdited: $isEdited) {
                        withAnimation {
                            self.isModalView.toggle()
                        }
                        
                        Task {
                            let sendableData = SendableClibmingMemo(whereID: self.climbingLocation.id,
                                                                    when: self.date,
                                                                    level: levelColorInt,
                                                                    score: Double(self.score),
                                                                    memo: self.typedText, picture: [""],
                                                                    video: "", tags: [""])
                            await saveDiary(sendableData)
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .preferredColorScheme(.light)
        .padding(.leading, 30)
        .padding(.trailing, 30)
        .onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }
        .task {
            let data = await requestDetailMemo(id: self.id)
            await decodeData(data ?? Data())
        }
    }
}

struct SendableClibmingMemo: Codable {
    let whereID: Int
    let when: String
    let level: Int
    let score: Double
    let memo: String
    let picture: [String]
    let video: String?
    let tags: [String]?
}

extension NewMemoView {
    private func deleteMemo(id: Int) async {
        guard let url = URL(string: "https://api-gw.todayclimbing.com/v1/climbing/\(id)") else {
            return
        }
        
        do {
            let reqeust = try URLRequest(url: url, method: .delete)
            let (_, response) = try await URLSession.shared.data(for: reqeust)
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print(response.statusCode)
            }
            
            refreshCalenderView()
            
        } catch {
            
        }
    }
    
    private func saveDiary(_ diary: SendableClibmingMemo) async {
        let urlStr = "https://api-gw.todayclimbing.com/v1/climbing/\(self.id)/"
        
        guard let url = URL(string: urlStr) else {
            print("Fail to InitURL")
            return
        }
        
        let currentImageFileName = await saveImage()
        
        do {
            var request = try URLRequest(url: url, method: .patch)
            
            let parameters: [String: Any?] = ["where": ["id": diary.whereID],
                                              "when": diary.when,
                                              "level": diary.level,
                                              "score": diary.score,
                                              "memo": diary.memo,
                                              "picture": [currentImageFileName],
                                              "video": nil,
                                              "tags": nil]
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("Status code: \(response.statusCode)")
                print("Response message: \(String(data: data, encoding: .utf8) ?? "")")
            }
            
            refreshCalenderView()
        } catch {
            print(error)
        }
    }
    
    private func refreshCalenderView() {
        isMemoChanged.toggle()
    }
    
    private func saveImage() async -> String? {
        let urlString = "https://api-gw.todayclimbing.com/v1/media/image/"
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var currentImageBase64: String? = ""
        
        if selectedPhoto == nil {
            let uiImage = self.photo?.asUIImage()
            currentImageBase64 = convertImageToBase64(image: uiImage)
        } else {
            var currentImageBase64String = convertImageToBase64(image: self.selectedPhoto)
            currentImageBase64 = currentImageBase64String
        }
        
        if currentImageBase64 ==  nil {
            return nil
        }
        
        do {
            var request = try URLRequest(url: url, method: .post)
            
            let parameters: [String: Any?] = ["image": currentImageBase64]
            
            request.setValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("Status code: \(response.statusCode)")
                print("Response message: \(String(data: data, encoding: .utf8) ?? "")")
            }
            
            let decodedData = try JSONDecoder().decode(ConvertedClimbingImageModel.self, from: data)
            
            return decodedData.filename
        } catch {
            print(error)
            return nil
        }
    }
    
    private func requestDetailMemo(id: Int) async -> Data? {
        let urlStr = "https://api-gw.todayclimbing.com/v1/climbing/\(id)"
        
        guard let url = URL(string: urlStr) else {
            print("Fail to InitURL")
            return nil
        }
        
        do {
            let request = try URLRequest(url: url, method: .get)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("Status code: \(response.statusCode)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
            return data
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func decodeData(_ data: Data) async {
        do {
            let decodedData = try JSONDecoder().decode(DetailClimbingModel.self, from: data)
            
            print("🎉🎉🎉",decodedData.level)
            
            let levelColorString = HolderColorNumber(rawValue: "\(decodedData.level)") ?? HolderColorNumber.nonSelected
            let levleColor = Color.convert(from: levelColorString.colorName)
            
            self.levelColor = levleColor
            self.levelColorInt = decodedData.level
            self.date = decodedData.when
            self.typedText = decodedData.memo
            self.score = Int(decodedData.score)
//            self.climbingLocation = decodedData.where
            if let location = decodedData.where {
                self.climbingLocation = ClimbingLocation(id: (location.id ?? 0 ),name: location.name, address: location.address,latitude: location.latitude, longitude: location.longitude)
            } else {
                self.climbingLocation = ClimbingLocation()
            }
            
            await requestMemoPicture(name: (decodedData.picture?.first ?? "이름이 없어요") ?? "")
        } catch {
            print(error)
        }
    }
    
    private func requestMemoPicture(name: String) async {
        let urlStr = "https://api-gw.todayclimbing.com/v1/media/image?filename=\(name)"
        
        guard let url = URL(string: urlStr) else {
            print("Fail to InitURL")
            return
        }
        
        do {
            let request = try URLRequest(url: url, method: .get)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("Status code: \(response.statusCode)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
            
            let decoded = try? JSONDecoder().decode(ClimbingImageModel.self,
                                                    from: data)
            
            if let base64String = decoded?.image,
               let data = Data(base64Encoded: base64String),
               let image = UIImage(data: data) {
                self.photoData = data
                self.photo = Image(uiImage: image)
            }
            
        } catch {
            print(error)
        }
    }
    
    private func convertImageToBase64(image: UIImage?) -> String? {
        guard let imageData = image?.pngData() else {
            return nil
        }
        
        let base64String = imageData.base64EncodedString(options: [])
        return base64String
    }
}

struct NewMemoView_Previews: PreviewProvider {
    @State static var isModal: Bool = false
    @State static var id: Int = 21
    static var previews: some View {
        NewMemoView(isModalView: $isModal, isMemoChanged: $isModal, id: $id)
    }
}
