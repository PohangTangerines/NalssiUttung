//
//  LocationInfo.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/30/24.
//

import Foundation
import CoreLocation

struct LocationInfo: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
}

extension LocationInfo {
    static let Data: [LocationInfo] = [
        // MARK: - 법정동에 맞게 리스트 재가공했습니다. 지역별 관광지 이름을 name으로 교채했습니다.
        // MARK: - 전체 법정동이 존재하지는 않습니다. 따라서 현재 위치로는 진입할 수 있으나 선택해서 진입할 수 없는 동이 있을 수 있습니다.
        // MARK: - 위 리스트 중 뚜렷한 관광지가 없는 동은 제외했습니다. 관광지가 있어 새로 추가된 동도 있습니다.
        
        // MARK: - 제주시 동
        LocationInfo(name: "제주공항", address: "제주공항", latitude: 33.507873, longitude: 126.493116),
        LocationInfo(name: "국립제주박물관", address: "제주시 건입동", latitude: 33.512524, longitude: 126.549911),
        LocationInfo(name: "신비의도로", address: "제주시 노형동", latitude: 33.451005, longitude: 126.487605),
        LocationInfo(name: "마방목지", address: "제주시 용강동", latitude: 33.427484, longitude: 126.604008),

        // MARK: - 제주시 읍
        LocationInfo(name: "비자림", address: "제주시 구좌읍", latitude: 33.488306, longitude: 126.808039),
        LocationInfo(name: "새별오름", address: "제주시 애월읍", latitude: 33.366737, longitude: 126.358031),
        LocationInfo(name: "함덕해수욕장", address: "제주시 조천읍", latitude: 33.543214, longitude: 126.669512),
        LocationInfo(name: "협재해수욕장", address: "제주시 한림읍", latitude: 33.393849, longitude: 126.238928),
        
        // MARK: - 제주시 면
        LocationInfo(name: "우도", address: "제주시 우도면", latitude: 33.502323, longitude: 126.956813),
        LocationInfo(name: "추자도", address: "제주시 추자면", latitude: 33.951988, longitude: 126.306709),
        LocationInfo(name: "제주현대미술관", address: "제주시 한경면", latitude: 33.33828, longitude: 126.265802),
        
        // MARK: - 서귀포시 동
        LocationInfo(name: "정방폭포", address: "서귀포시 동홍동", latitude: 33.24457, longitude: 126.573327),
        LocationInfo(name: "한라산", address: "서귀포시 서호동", latitude: 33.2591667, longitude: 126.5175),
        LocationInfo(name: "여미지식물원", address: "서귀포시 색달동", latitude: 33.252417, longitude: 126.414441),
        LocationInfo(name: "이중섭미술관", address: "서귀포시 서귀동", latitude: 33.245795, longitude: 126.564866),
        
        // MARK: - 서귀포시 읍
        LocationInfo(name: "동백수목원", address: "서귀포시 남원읍", latitude: 33.261678, longitude: 126.639459),
        LocationInfo(name: "섭지코지", address: "서귀포시 성산읍", latitude: 33.425165, longitude: 126.930742),
        LocationInfo(name: "가파도", address: "서귀포시 대정읍", latitude: 33.170157, longitude: 126.270455),

        // MARK: - 서귀포시 면
        LocationInfo(name: "오설록티뮤지엄", address: "서귀포시 안덕면", latitude: 33.305817, longitude: 126.289463),
        LocationInfo(name: "보롬왓", address: "서귀포시 표선면", latitude: 33.3533333, longitude: 126.8166667)
    ]
}

// MARK: - 기존에는 존재하지만, 새로 갱신한 지역 목록에는 포함 x
//        LocationInfo(name: "제주", address: "제주시 건입동", latitude: 33.5138889, longitude: 126.5294444),
//
//        LocationInfo(name: "산천단", address: "제주시 아라일동", latitude: 33.4469444, longitude: 126.565),
//        LocationInfo(name: "외도", address: "제주시 외도일동", latitude: 33.4766667, longitude: 126.4313889),
//        LocationInfo(name: "오등", address: "제주시 오등동", latitude: 33.4575, longitude: 126.5219444),
//        LocationInfo(name: "서귀포", address: "서귀포시 서귀동", latitude: 33.2461111, longitude: 126.5652778),
//        LocationInfo(name: "강정", address: "서귀포시 강정동", latitude: 33.2605556, longitude: 126.4894444),
//        LocationInfo(name: "삼각봉", address: "제주시 오라이동", latitude: 33.3766667, longitude: 126.5302778),
//        LocationInfo(name: "어리목", address: "제주시 해안동", latitude: 33.3927778, longitude: 126.4958333),
//        LocationInfo(name: "한라산남벽", address: "서귀포시 토평동", latitude: 33.3522222, longitude: 126.5327778),

// MARK: - 변형되어서 목록에 포함됨.
//        LocationInfo(name: "제주(공)", address: "제주공항", latitude: 33.8463889, longitude: 126.8205556),

//        LocationInfo(name: "애월", address: "제주시 애월읍 애월리", latitude: 33.4658333, longitude: 126.3272222),
//        LocationInfo(name: "새별오름", address: "제주시 애월읍 봉성리", latitude: 33.3622222, longitude: 126.3597222),
//        LocationInfo(name: "유수암", address: "제주시 애월읍 유수암리", latitude: 33.4097222, longitude: 126.3927778),
//        LocationInfo(name: "대흘", address: "제주시 조천읍 대흘리", latitude: 33.5005556, longitude: 126.6494444),
//        LocationInfo(name: "와산", address: "제주시 조천읍 와산리", latitude: 33.4791667, longitude: 126.6938889),
//        LocationInfo(name: "기상(과)", address: "서귀포시 서호동", latitude: 33.2591667, longitude: 126.5175),
//        LocationInfo(name: "중문", address: "서귀포시 색달동", latitude: 33.2491667, longitude: 126.4058333),
//        LocationInfo(name: "제주남원", address: "서귀포시 남원읍 남원리", latitude: 33.2772222, longitude: 126.7041667),
//        LocationInfo(name: "태풍센터", address: "서귀포시 남원읍 한남리", latitude: 33.3313889, longitude: 126.6783333),
//        LocationInfo(name: "지귀도", address: "서귀포시 남원읍 위미리", latitude: 33.3825, longitude: 126.7858333),
//        LocationInfo(name: "안덕화순", address: "서귀포시 안덕면 화순리", latitude: 33.2577778, longitude: 126.3297222),
//        LocationInfo(name: "서광", address: "서귀포시 안덕면 서광리", latitude: 33.3044444, longitude: 126.3058333),
//        LocationInfo(name: "성산", address: "서귀포시 성산읍 신산리", latitude: 33.3866667, longitude: 126.8808333),
//        LocationInfo(name: "송당", address: "제주시 구좌읍 송당리", latitude: 33.4705556, longitude: 126.7791667),
//        LocationInfo(name: "월정", address: "제주시 구좌읍 월정리", latitude: 33.5622222, longitude: 126.7780556),
//        LocationInfo(name: "구좌", address: "제주시 구좌읍 하도리", latitude: 33.5197222, longitude: 126.8775),
//        LocationInfo(name: "우도", address: "제주시 우도면 연평리", latitude: 33.5227778, longitude: 126.9538889),
//        LocationInfo(name: "성산수산", address: "서귀포시 성산읍 수산리", latitude: 33.45, longitude: 126.8511111),
//        LocationInfo(name: "표선", address: "서귀포시 표선면 하천리", latitude: 33.3533333, longitude: 126.8166667),
//        LocationInfo(name: "제주가시리", address: "서귀포시 표선면 가시리", latitude: 33.3852778, longitude: 126.7336111),
//        LocationInfo(name: "고산", address: "제주시 한경면 고산리", latitude: 33.2936111, longitude: 126.1627778),
//        LocationInfo(name: "한림", address: "제주시 한림읍 명월리", latitude: 33.3925, longitude: 126.2580556),
//        LocationInfo(name: "낙천", address: "제주시 한경면 낙천리", latitude: 33.3180556, longitude: 126.2302778),
//        LocationInfo(name: "대정", address: "서귀포시 대정읍 일과리", latitude: 33.2408333, longitude: 126.2261111),
//        LocationInfo(name: "가파도", address: "서귀포시 대정읍 가파리", latitude: 33.2408333, longitude: 126.2261111),
//        LocationInfo(name: "삼각봉", address: "제주시 오라이동", latitude: 33.3766667, longitude: 126.5302778),
//        LocationInfo(name: "한라생태숲", address: "제주시 용강동", latitude: 33.43, longitude: 126.5975),
//        LocationInfo(name: "사제비", address: "제주시 애월읍 광령리", latitude: 33.3758333, longitude: 126.4977778),
//        LocationInfo(name: "성판악", address: "제주시 조천읍 교래리", latitude: 33.385, longitude: 126.6191667),
//        LocationInfo(name: "영실", address: "서귀포시 하원동", latitude: 33.3480556, longitude: 126.4963889),
//        LocationInfo(name: "진달래밭", address: "서귀포시 남원읍 하례리", latitude: 33.3697222, longitude: 126.5555556),
//        LocationInfo(name: "추자도", address: "제주시 추자면 영흥리", latitude: 33.9577778, longitude: 126.3013889),
