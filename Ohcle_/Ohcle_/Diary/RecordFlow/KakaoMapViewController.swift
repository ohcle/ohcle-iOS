//
//  KaKaoMapBridgeHeader.h
//  Ohcle_
//
//  Created by yeongbin ro on 2023/04/23.
//

import Foundation
import UIKit

@objc protocol KakaoMapViewDelegate {
    @objc optional func movedCenterPoint(_ mapView: MTMapView, mapCenterPoint: MTMapPoint)
    @objc optional func tapMapView(_ mapView: MTMapView, mapPoint: MTMapPoint)
    @objc optional func foundAddress(_ rGeoCoder: MTMapReverseGeoCoder, addressString: String)
    
}

class KakaoMapViewController: UIViewController, MTMapViewDelegate, MTMapReverseGeoCoderDelegate {

    

    var mapView: MTMapView?
    var geocoder: MTMapReverseGeoCoder?
    var delegate: KakaoMapViewDelegate?

    var latitude : Double = 37.576568
    var longitude : Double = 127.029148

    override func loadView() {
        let myView = UIView()
        myView.frame = UIScreen.main.bounds
        self.view = myView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도 불러오기
        mapView = MTMapView(frame: self.view.frame)

        guard let mapView = mapView else { return }
        // 델리게이트 연결
        mapView.delegate = self
        // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
        mapView.baseMapType = .standard
        
        // 현재 위치 트래킹
        mapView.currentLocationTrackingMode = .onWithoutHeading
        mapView.showCurrentLocationMarker = true
        
        let mapPointGeo = MTMapPointGeo(latitude:  37.456518177069526, longitude: 126.70531256589555)

        // 지도의 센터를 설정 (x와 y 좌표, 줌 레벨 등을 설정)
        mapView.setMapCenter(MTMapPoint(geoCoord: mapPointGeo), zoomLevel: 0, animated: true)
        
        // 현재 주소지 가져오기
        geocoder = MTMapReverseGeoCoder.init(mapPoint: MTMapPoint(geoCoord: mapPointGeo), with: self, withOpenAPIKey: "22f5f9d3ede9cc50d4a9230018dcf376")
        geocoder?.startFindingAddress()
        
        
        self.makeMarker()
        
        self.view.addSubview(mapView)
    }
    
    // poiItem 클릭 이벤트
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        // 인덱스는 poiItem의 태그로 접근
        let index = poiItem.tag
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // mapView의 모든 poiItem 제거
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
    }
    
    // 마커 추가
    func makeMarker(){
        let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.456518177069526, longitude: 126.70531256589555))
        
        let poiItem1 = MTMapPOIItem()
        poiItem1.markerType = .redPin
        poiItem1.mapPoint = mapPoint
        poiItem1.itemName = "클라이밍장"
        
        if let mapView = mapView {
            mapView.add(poiItem1)
        }
    }

}

//MARK: Delegate
extension KakaoMapViewController {

    //MARK: MTMapViewDelegate
    
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        delegate?.tapMapView?(mapView, mapPoint: mapCenterPoint)
    }
    
    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        delegate?.tapMapView?(mapView, mapPoint: mapPoint)
    }
    
    
    //MARK: MTMapReverseGeoCoderDelegate
    
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
        delegate?.foundAddress?(rGeoCoder, addressString: addressString)
    }
    
}
