//
//  ViewController.swift
//  exercise
//
//  Created by Do Yi Lee on 2022/08/26.
//

import UIKit
import CoreLocation

class KakaoMapViewController: UIViewController {
    private var mapView: MTMapView!
    private let mapViewDeleate: MTMapViewDelegate = MapViewDelegate()
    
    private var searchResultMapData: KakaoMapRestAPIModel?
    private var searchBarDelegate =  MapViewSearchBarDelegate()
    private let serachController = UISearchController()
    private(set) var searchedResult = ""
    
    private let locationManger = CLLocationManager()
    private(set) var currentLocation = CLLocationCoordinate2D(latitude: 33.41,
                                                              longitude: 126.52)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        setSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setLocationManage()
    }
}

extension KakaoMapViewController {
    private func setMapView() {
        self.mapView = MTMapView(frame: self.view.frame)
        self.mapView.delegate = self.mapViewDeleate
        self.mapView.baseMapType = .standard
        self.view.addSubview(mapView)
    }
    
    private func setSearchBar() {
        self.navigationItem.title = "클라이밍"
        self.navigationItem.searchController = self.serachController
        self.serachController.searchBar.delegate = self.searchBarDelegate
        self.serachController.searchResultsUpdater = self
        self.serachController.searchBar.barTintColor = .blue
        self.navigationItem.searchController = self.serachController
    }
    
    private func setLocationManage() {
        self.locationManger.delegate = self
        self.locationManger.requestWhenInUseAuthorization()
    }
    
    private func showMarkers() {
        self.mapView.removeAllPOIItems()
        var marker: [MTMapPOIItem] = []
        self.searchResultMapData?.documents.map { data in
            let poiItem = MTMapPOIItem()
            poiItem.itemName = data.placeName
            let doubleLatitude = Double(data.y) ?? 33.41
            let doubleLongitude = Double(data.x) ?? 126.52
            let mapPointGeo = MTMapPointGeo(latitude: doubleLatitude, longitude: doubleLongitude)
            poiItem.mapPoint = MTMapPoint(geoCoord: mapPointGeo)
            poiItem.markerType = .yellowPin
            poiItem.showAnimationType = .dropFromHeaven
            marker.append(poiItem)
        }
        
        self.mapView.addPOIItems(marker)
        self.mapView.fitAreaToShowAllPOIItems()
    }
}

//MARK:- Keyword Search
extension KakaoMapViewController: UISearchResultsUpdating {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        self.searchedResult = text
    }
    
    private func search() {
        let authorizationKey = "ea9fd242a4916abaf72fb19ac00ad011"
        let x = currentLocation.latitude
        let y = currentLocation.longitude
        let radius = 20000
        
        guard let url = URL( "https://dapi.kakao.com/v2/local/search/keyword.json?query={\(self.searchedResult)}&y=\(x)&x=\(y)&radius=\(radius)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization" :
                                        "KakaoAK \(authorizationKey)"]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let resultData = data else {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedData = try decoder.decode(KakaoMapRestAPIModel.self, from: resultData)
                self.searchResultMapData = decodedData
                
                DispatchQueue.main.async {
                    self.showMarkers()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

//MARK:- Location authorization use cases
extension KakaoMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        guard let latitude = locations.last?.coordinate.latitude,
              let longitude = locations.last?.coordinate.longitude else {
            return
        }
        
        self.currentLocation = CLLocationCoordinate2D(latitude: latitude,
                                                      longitude: longitude)
        
        self.mapView.currentLocationTrackingMode = .onWithoutHeading
        self.mapView.showCurrentLocationMarker = true
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .locationUnknown:
                break
            default:
                print(error.localizedDescription)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            break
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            manager.requestLocation()
            break
        @unknown default: break
        }
    }
}

extension KakaoMapViewController {
    
}
