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

struct ClimbingLocationView: View {
    @State private var searchText = ""
    @State private var commonSize = CGSize()
    @State private var isLocateChanged: Bool = false
    @EnvironmentObject var nextPageType: MyPageType
    private var nextButton: NextPageButton =  NextPageButton(title: "다음",
                                                             width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @StateObject var locationDataManager = LocationDataManager()
    
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
            
            
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:  // Location services are available.
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .frame(width: 400, height: 300)
            case .restricted, .denied:  // Location services currently unavailable.
                Map(coordinateRegion: $region)
                    .frame(width: 400, height: 300)
                
            case .notDetermined:        // Authorization not determined yet.
                Map(coordinateRegion: $region)
                    .frame(width: 400, height: 300)
            default:
                ProgressView()
            }
           
            
            Spacer()
            
        }
        .onDisappear {
            let locationString = self.searchText
        }
        .overlay(
            self.nextButton
                .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
        )
        .onAppear {
            
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
        // Insert code to handle location updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
}
