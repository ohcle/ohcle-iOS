//
//  ClimbingLocagion.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/15.
//

import SwiftUI
import CoreLocation
import MapKit

struct IdentifiableSpace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID, lat: Double, long: Double) {
        self.id = id
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.location = location
    }
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name:String
}


struct ClimbingLocationView: View {
    @State private var searchText = ""
    @State private var commonSize = CGSize()
    @State private var isLocateChanged: Bool = false
    @EnvironmentObject var nextPageType: MyPageType
    private var nextButton: NextPageButton =  NextPageButton(title: "다음",
                                                             width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666612, longitude: 126.9783785), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    @StateObject var locationDataManager = LocationDataManager()
    @State var selectedLocation:ClimbingLocation = ClimbingLocation()
    @State private var annotations:[AnnotationItem] = []
    @State private var showAlert = false
    

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
                HStack{
                    Image("locationSearchBarIcon")
                    NavigationLink {
                        ClimbingLocationSearch(selectedLocation: $selectedLocation, selectedname: $searchText)
                    } label: {
                        TextField("장소를 입력해 주세요",
                                  text: $searchText)
                        .onChange(of: searchText) { newValue in
                            if !searchText.isEmpty {
                                self.nextButton.userEvent.inform()
                            }
                        }
                        .disabled(true)
                        .multilineTextAlignment(.leading)
                    }
                }
                .padding(.leading, 10)
            }
            .frame(width: commonSize.width * 0.9,
                   height: commonSize.height)
            .padding(.bottom, commonSize.height * 0.7)
            
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        
                        VStack(spacing: 0){
                            Image("1-1")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text(annotation.name)
                                .frame(maxWidth: 50)
                                .font(.system(size: 9))
                        }
                        
                    }
                }
                .frame(width: 400, height: 300)

                Button {
                    if locationDataManager.locationManager.authorizationStatus == .authorizedWhenInUse {
                        locationDataManager.locationManager.requestLocation()
                        locationDataManager.updateCurrentLocation = { location in
                            region = MKCoordinateRegion(center: location, latitudinalMeters: 300, longitudinalMeters: 300)
                        }
                        
                    } else {
                        showAlert = true
                    }

                } label: {
                    Image(systemName: "scope")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .padding(20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(""), message: Text("현재 위치 추적을 위해서\n설정 > 개인정보 보호 및 보안 > 위치서비스\n에서 위치 권한을 허용해주세요."), dismissButton: .default(Text("확인")))
                }

            }
            
            
            
            Spacer()
            
        }
        .overlay(
            self.nextButton
                .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
        )
        .onAppear {
            // 최초 로딩 시
            if CalendarDataManger.shared.record.climbingLocation.name == "" {
                locationDataManager.updateCurrentLocation = { location in
                    region = MKCoordinateRegion(center: location, latitudinalMeters: 300, longitudinalMeters: 300)
                }
            }
            // 뒤로 왔을 때 액션
            if CalendarDataManger.shared.record.climbingLocation.name != "" {
                self.searchText = CalendarDataManger.shared.record.climbingLocation.name
                self.nextButton.userEvent.inform()
            }
            
            // Search에서 선택 시 액션
            if selectedLocation.longitude != 0 && selectedLocation.longitude != 0 {
                annotations.removeAll()
                let locationPosition = CLLocationCoordinate2D(latitude: CLLocationDegrees(selectedLocation.latitude), longitude: CLLocationDegrees(selectedLocation.longitude))
                let newAnnotation = AnnotationItem(coordinate: locationPosition, name: selectedLocation.name)
                annotations.append(newAnnotation)
                region = MKCoordinateRegion(center: locationPosition, latitudinalMeters: 300, longitudinalMeters: 300)
            }
            
            self.nextButton.userEvent.nextButtonTouched = {
                CalendarDataManger.shared.record.saveTemporaryLocation(selectedLocation)
            }
            
            
        }
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

struct ClimbingLocation_Preview: PreviewProvider {
    static var previews: some View {
        ClimbingLocationView()
    }
}


class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    var updateCurrentLocation: ((CLLocationCoordinate2D) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            locationManager.requestLocation()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            break
            
        case .notDetermined:        // Authorization not determined yet.
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let closure = updateCurrentLocation {
                closure((locations[0].coordinate))
            }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
}

