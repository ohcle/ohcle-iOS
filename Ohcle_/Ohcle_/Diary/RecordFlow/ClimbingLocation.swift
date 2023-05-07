//
//  ClimbingLocagion.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/15.
//

import SwiftUI
import CoreLocation

struct IdentifiableSpace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID, lat: Double, long: Double) {
        self.id = id
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.location = location
    }
}

struct ClimbingLocation: View {
    @State private var searchText = ""
    @State private var commonSize = CGSize()
    @State private var isLocateChanged: Bool = false
    @EnvironmentObject var nextPageType: MyPageType
    private var nextButton: NextPageButton =  NextPageButton(title: "다음",
                                                             width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    var body: some View {
        VStack {
            (Text("어디서")
                .bold()
             +
             Text(" 클라이밍 하셨어요?"))
            .font(.title)
            .readSize { textSize in
                commonSize = textSize
            }
            .padding(.bottom, commonSize.height * 0.7)
       
            
            
            ZStack {
                if #available(iOS 15.0, *) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                        .background(.white)
                        .frame(width: commonSize.width,
                               height: commonSize.height * 1.5)
                } else {
                    // Fallback on earlier versions
                }
                HStack {
                    Image("locationSearchBarIcon")
                    NavigationLink {
                        
                        Text("Search Process")
                        
                    } label: {
                        TextField("장소를 입력해 주세요",
                                  text: $searchText)
                        .onChange(of: searchText) { newValue in
                            if !searchText.isEmpty {
                                self.nextButton.userEvent.inform()
                            }
                        }
                    }
 
                }
                .padding(.leading, commonSize.width * 0.2)
            }
            .frame(width: commonSize.width * 0.9,
                   height: commonSize.height)
            .padding(.bottom, commonSize.height * 0.7)

            
            KakaoMapView()
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2.5)
            
            Spacer()
            
        }
        .onDisappear {
            let locationString = self.searchText
        }
        .overlay(
            self.nextButton
                .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
        )
    }
    
}
// MARK: SearchView
struct SearchView: View {
    @State private var searchText = ""
    var body: some View {
        Text(searchText)
            .searchable(text: $searchText, prompt: "장소를 입력해주세요.")
    }
}



// MARK: KakaoMapView
struct KakaoMapView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> KakaoMapViewController {
        let vc = KakaoMapViewController()
        vc.view.frame = UIScreen.main.bounds
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: KakaoMapViewController, context: Context) {
        // No need to update the view controller
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, KakaoMapViewDelegate {
        func movedCenterPoint(_ mapView: MTMapView, mapCenterPoint: MTMapPoint) {
            
        }
        
        func tapMapView(_ mapView: MTMapView, mapPoint: MTMapPoint) {
            
        }
        
        func foundAddress(_ rGeoCoder: MTMapReverseGeoCoder, addressString: String) {
            print(addressString)
        }
        
        let parent: KakaoMapView

        init(_ parent: KakaoMapView) {
            self.parent = parent
        }


    }

}


struct ClimbingLocation_Preview: PreviewProvider {
    static var previews: some View {
        ClimbingLocation()
    }
}


//naver api 찾기
