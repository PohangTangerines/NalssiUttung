//
//  LocationListViewModel.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 10/10/23.
//

import Foundation
import CoreLocation

enum ModalState{
    case notModalView
    case isModalViewAndContainedContent
    case isModalViewAndNotContainedContent
}

struct LocationInfo : Codable {
    var AWSNum: Int
    var location: String
    var altitude: Int
    var address: String
    var latitude: Double
    var longitude: Double
}

extension LocationInfo {
    // 위도, 경도를 미리 CLLocationDegrees로 변환해야함
    static let Data: [LocationInfo] = [
        
        LocationInfo(AWSNum: 184, location: "제주", altitude: 21, address: "제주시 건입동", latitude: 33.5138889, longitude: 126.5294444),
        LocationInfo(AWSNum: 182, location: "제주(공)", altitude: 27, address: "제주시 용담이동", latitude: 33.8463889, longitude: 126.8205556),
        LocationInfo(AWSNum: 329, location: "산천단", altitude: 377, address: "제주시 아라일동", latitude: 33.4469444, longitude: 126.565),
        LocationInfo(AWSNum: 863, location: "외도", altitude: 53, address: "제주시 외도일동", latitude: 33.4766667, longitude: 126.4313889),
        LocationInfo(AWSNum: 865, location: "오등", altitude: 234, address: "제주시 오등동", latitude: 33.4575, longitude: 126.5219444),
        LocationInfo(AWSNum: 893, location: "애월", altitude: 5, address: "제주시 애월읍 애월리", latitude: 33.4658333, longitude: 126.3272222),
        LocationInfo(AWSNum: 883, location: "새별오름", altitude: 435, address: "제주시 애월읍 봉성리", latitude: 33.3622222, longitude: 126.3597222),
        LocationInfo(AWSNum: 727, location: "유수암", altitude: 425, address: "제주시 애월읍 유수암리", latitude: 33.4097222, longitude: 126.3927778),
        LocationInfo(AWSNum: 330, location: "대흘", altitude: 144, address: "제주시 조천읍 대흘리", latitude: 33.5005556, longitude: 126.6494444),
        LocationInfo(AWSNum: 751, location: "와산", altitude: 248, address: "제주시 조천읍 와산리", latitude: 33.4791667, longitude: 126.6938889),

        // 제주남부
        LocationInfo(AWSNum: 189, location: "서귀포", altitude: 52, address: "서귀포시 서귀동", latitude: 33.2461111, longitude: 126.5652778),
        LocationInfo(AWSNum: 884, location: "기상(과)", altitude: 173, address: "서귀포시 서호동", latitude: 33.2591667, longitude: 126.5175),
        LocationInfo(AWSNum: 980, location: "강정", altitude: 135, address: "서귀포시 강정동", latitude: 33.2605556, longitude: 126.4894444),
        LocationInfo(AWSNum: 328, location: "중문", altitude: 64, address: "서귀포시 색달동", latitude: 33.2491667, longitude: 126.4058333),
        LocationInfo(AWSNum: 780, location: "제주남원", altitude: 26, address: "서귀포시 남원읍 남원리", latitude: 33.2772222, longitude: 126.7041667),
        LocationInfo(AWSNum: 885, location: "태풍센터", altitude: 244, address: "서귀포시 남원읍 한남리", latitude: 33.3313889, longitude: 126.6783333),
        LocationInfo(AWSNum: 960, location: "지귀도", altitude: 18, address: "서귀포시 남원읍 위미리", latitude: 33.3825, longitude: 126.7858333),
        LocationInfo(AWSNum: 989, location: "안덕화순", altitude: 90, address: "서귀포시 안덕면 화순리", latitude: 33.2577778, longitude: 126.3297222),
        LocationInfo(AWSNum: 752, location: "서광", altitude: 188, address: "서귀포시 안덕면 서광리", latitude: 33.3044444, longitude: 126.3058333),

        // 제주동부

        LocationInfo(AWSNum: 188, location: "성산", altitude: 20, address: "서귀포시 성산읍 신산리", latitude: 33.3866667, longitude: 126.8808333),
        LocationInfo(AWSNum: 862, location: "송당", altitude: 195, address: "제주시 구좌읍 송당리", latitude: 33.4705556, longitude: 126.7791667),
        LocationInfo(AWSNum: 861, location: "월정", altitude: 34, address: "제주시 구좌읍 월정리", latitude: 33.5622222, longitude: 126.7780556),
        LocationInfo(AWSNum: 781, location: "구좌", altitude: 17, address: "제주시 구좌읍 하도리", latitude: 33.5197222, longitude: 126.8775),
        LocationInfo(AWSNum: 725, location: "우도", altitude: 9, address: "제주시 우도면 연평리", latitude: 33.5227778, longitude: 126.9538889),
        LocationInfo(AWSNum: 892, location: "성산수산", altitude: 102, address: "서귀포시 성산읍 수산리", latitude: 33.45, longitude: 126.8511111),
        LocationInfo(AWSNum: 792, location: "표선", altitude: 80, address: "서귀포시 표선면 하천리", latitude: 33.3533333, longitude: 126.8166667),
        LocationInfo(AWSNum: 890, location: "제주가시리", altitude: 275, address: "서귀포시 표선면 가시리", latitude: 33.3852778, longitude: 126.7336111),

        // 제주서부
        LocationInfo(AWSNum: 185, location: "고산", altitude: 71, address: "제주시 한경면 고산리", latitude: 33.2936111, longitude: 126.1627778),
        LocationInfo(AWSNum: 779, location: "한림", altitude: 39, address: "제주시 한림읍 명월리", latitude: 33.3925, longitude: 126.2580556),
        LocationInfo(AWSNum: 990, location: "낙천", altitude: 78, address: "제주시 한경면 낙천리", latitude: 33.3180556, longitude: 126.2302778),
        LocationInfo(AWSNum: 793, location: "대정", altitude: 3, address: "서귀포시 대정읍 일과리", latitude: 33.2408333, longitude: 126.2261111),
        LocationInfo(AWSNum: 855, location: "가파도", altitude: 4, address: "서귀포시 대정읍 가파리", latitude: 33.2408333, longitude: 126.2261111),
        LocationInfo(AWSNum: 726, location: "마라도", altitude: 12, address: "서귀포시 대정읍 가파리", latitude: 33.1227778, longitude: 126.2677778),

        // 제주산간
        LocationInfo(AWSNum: 867, location: "삼각봉", altitude: 1503, address: "제주시 오라이동", latitude: 33.3766667, longitude: 126.5302778),
        LocationInfo(AWSNum: 866, location: "한라생태숲", altitude: 588, address: "제주시 용강동", latitude: 33.43, longitude: 126.5975),
        LocationInfo(AWSNum: 753, location: "어리목", altitude: 968, address: "제주시 해안동", latitude: 33.3927778, longitude: 126.4958333),
        LocationInfo(AWSNum: 868, location: "사제비", altitude: 1393, address: "제주시 애월읍 광령리", latitude: 33.3758333, longitude: 126.4977778),
        LocationInfo(AWSNum: 871, location: "윗세오름", altitude: 1676, address: "제주시 애월읍 광령리", latitude: 33.3622222, longitude: 126.5180556),
        LocationInfo(AWSNum: 782, location: "성판악", altitude: 760, address: "제주시 조천읍 교래리", latitude: 33.385, longitude: 126.6191667),
        LocationInfo(AWSNum: 965, location: "한라산남벽", altitude: 1576, address: "서귀포시 토평동", latitude: 33.3522222, longitude: 126.5327778),
        LocationInfo(AWSNum: 869, location: "영실", altitude: 1260, address: "서귀포시 하원동", latitude: 33.3480556, longitude: 126.4963889),
        LocationInfo(AWSNum: 870, location: "진달래밭", altitude: 1489, address: "서귀포시 남원읍 하례리", latitude: 33.3697222, longitude: 126.5555556),

        // 추자도
        LocationInfo(AWSNum: 724, location: "추자도", altitude: 8, address: "제주시 추자면 영흥리", latitude: 33.9577778, longitude: 126.3013889)

        
        
        // 도, 분, 초
//        // 제주북부
//        LocationInfo(AWSNum: 184, location: "제주", altitude: 21, address: "제주시 건입동", latitude: "33° 30‘ 50“", longitude: "126° 31‘ 46“"),
//        LocationInfo(AWSNum: 182, location: "제주(공)", altitude: 27, address: "제주시 용담이동", latitude: "33° 50‘ 79“", longitude: "126° 49‘ 14“"),
//        LocationInfo(AWSNum: 329, location: "산천단", altitude: 377, address: "제주시 아라일동", latitude: "33° 26‘ 49“", longitude: "126° 33‘ 54“"),
//        LocationInfo(AWSNum: 863, location: "외도", altitude: 53, address: "제주시 외도일동", latitude: "33° 28‘ 36“", longitude: "126° 25‘ 53“"),
//        LocationInfo(AWSNum: 865, location: "오등", altitude: 234, address: "제주시 오등동", latitude: "33° 27‘ 27“", longitude: "126° 31‘ 19“"),
//        LocationInfo(AWSNum: 893, location: "애월", altitude: 5, address: "제주시 애월읍 애월리", latitude: "33° 27‘ 57“", longitude: "126° 19‘ 38“"),
//        LocationInfo(AWSNum: 883, location: "새별오름", altitude: 435, address: "제주시 애월읍 봉성리", latitude: "33° 21‘ 44“", longitude: "126° 21‘ 35“"),
//        LocationInfo(AWSNum: 727, location: "유수암", altitude: 425, address: "제주시 애월읍 유수암리", latitude: "33° 24‘ 35“", longitude: "126° 23‘ 34“"),
//        LocationInfo(AWSNum: 330, location: "대흘", altitude: 144, address: "제주시 조천읍 대흘리", latitude: "33° 30‘ 2“", longitude: "126° 38‘ 58“"),
//        LocationInfo(AWSNum: 751, location: "와산", altitude: 248, address: "제주시 조천읍 와산리", latitude: "33° 28‘ 45“", longitude: "126° 41‘ 38“"),
//
//        // 제주남부
//        LocationInfo(AWSNum: 189, location: "서귀포", altitude: 52, address: "서귀포시 서귀동", latitude: "33° 14‘ 46“", longitude: "126° 33‘ 55“"),
//        LocationInfo(AWSNum: 884, location: "기상(과)", altitude: 173, address: "서귀포시 서호동", latitude: "33° 15‘ 33“", longitude: "126° 31‘ 3“"),
//        LocationInfo(AWSNum: 980, location: "강정", altitude: 135, address: "서귀포시 강정동", latitude: "33° 15‘ 38“", longitude: "126° 29‘ 22“"),
//        LocationInfo(AWSNum: 328, location: "중문", altitude: 64, address: "서귀포시 색달동", latitude: "33° 14‘ 57“", longitude: "126° 24‘ 21“"),
//        LocationInfo(AWSNum: 780, location: "제주남원", altitude: 26, address: "서귀포시 남원읍 남원리", latitude: "33° 16‘ 37“", longitude: "126° 42‘ 15“"),
//        LocationInfo(AWSNum: 885, location: "태풍센터", altitude: 244, address: "서귀포시 남원읍 한남리", latitude: "33° 19‘ 53“", longitude: "126° 40‘ 42“"),
//        LocationInfo(AWSNum: 960, location: "지귀도", altitude: 18, address: "서귀포시 남원읍 위미리", latitude: "33° 22‘ 59“", longitude: "126° 65‘ 45“"),
//        LocationInfo(AWSNum: 989, location: "안덕화순", altitude: 90, address: "서귀포시 안덕면 화순리", latitude: "33° 15‘ 28“", longitude: "126° 19‘ 47“"),
//        LocationInfo(AWSNum: 752, location: "서광", altitude: 188, address: "서귀포시 안덕면 서광리", latitude: "33° 18‘ 16“", longitude: "126° 18‘ 21“"),
//
//        // 제주동부
//
//        LocationInfo(AWSNum: 188, location: "성산", altitude: 20, address: "서귀포시 성산읍 신산리", latitude: "33° 23‘ 12“", longitude: "126° 52‘ 48“"),
//        LocationInfo(AWSNum: 862, location: "송당", altitude: 195, address: "제주시 구좌읍 송당리", latitude: "33° 28‘ 14“", longitude: "126° 46‘ 45“"),
//        LocationInfo(AWSNum: 861, location: "월정", altitude: 34, address: "제주시 구좌읍 월정리", latitude: "33° 33‘ 44“", longitude: "126° 46‘ 41“"),
//        LocationInfo(AWSNum: 781, location: "구좌", altitude: 17, address: "제주시 구좌읍 하도리", latitude: "33° 31‘ 11“", longitude: "126° 52‘ 39“"),
//        LocationInfo(AWSNum: 725, location: "우도", altitude: 9, address: "제주시 우도면 연평리", latitude: "33° 31‘ 22“", longitude: "126° 57‘ 14“"),
//        LocationInfo(AWSNum: 892, location: "성산수산", altitude: 102, address: "서귀포시 성산읍 수산리", latitude: "33° 27‘ 0“", longitude: "126° 51‘ 4“"),
//        LocationInfo(AWSNum: 792, location: "표선", altitude: 80, address: "서귀포시 표선면 하천리", latitude: "33° 21‘ 12“", longitude: "126° 49‘ 0“"),
//        LocationInfo(AWSNum: 890, location: "제주가시리", altitude: 275, address: "서귀포시 표선면 가시리", latitude: "33° 23‘ 7“", longitude: "126° 44‘ 1“"),
//
//        // 제주서부
//        LocationInfo(AWSNum: 185, location: "고산", altitude: 71, address: "제주시 한경면 고산리", latitude: "33° 17‘ 37“", longitude: "126° 9‘ 46“"),
//        LocationInfo(AWSNum: 779, location: "한림", altitude: 39, address: "제주시 한림읍 명월리", latitude: "33° 23‘ 33“", longitude: "126° 15‘ 29“"),
//        LocationInfo(AWSNum: 990, location: "낙천", altitude: 78, address: "제주시 한경면 낙천리", latitude: "33° 19‘ 05“", longitude: "126° 13‘ 49“"),
//        LocationInfo(AWSNum: 793, location: "대정", altitude: 3, address: "서귀포시 대정읍 일과리", latitude: "33° 14‘ 27“", longitude: "126° 13‘ 34“"),
//        LocationInfo(AWSNum: 855, location: "가파도", altitude: 4, address: "서귀포시 대정읍 가파리", latitude: "33° 14‘ 27“", longitude: "126° 13‘ 34“"),
//        LocationInfo(AWSNum: 726, location: "마라도", altitude: 12, address: "서귀포시 대정읍 가파리", latitude: "33° 7‘ 19“", longitude: "126° 16‘ 4“"),
//
//        // 제주산간
//        LocationInfo(AWSNum: 867, location: "삼각봉", altitude: 1503, address: "제주시 오라이동", latitude: "33° 22‘ 36“", longitude: "126° 31‘ 49“"),
//        LocationInfo(AWSNum: 866, location: "한라생태숲", altitude: 588, address: "제주시 용강동", latitude: "33° 25‘ 48“", longitude: "126° 35‘ 51“"),
//        LocationInfo(AWSNum: 753, location: "어리목", altitude: 968, address: "제주시 해안동", latitude: "33° 23‘ 34“", longitude: "126° 29‘ 45“"),
//        LocationInfo(AWSNum: 868, location: "사제비", altitude: 1393, address: "제주시 애월읍 광령리", latitude: "33° 22‘ 33“", longitude: "126° 29‘ 52“"),
//        LocationInfo(AWSNum: 871, location: "윗세오름", altitude: 1676, address: "제주시 애월읍 광령리", latitude: "33° 21‘ 44“", longitude: "126° 31‘ 5“"),
//        LocationInfo(AWSNum: 782, location: "성판악", altitude: 760, address: "제주시 조천읍 교래리", latitude: "33° 23‘ 6“", longitude: "126° 37‘ 9“"),
//        LocationInfo(AWSNum: 965, location: "한라산남벽", altitude: 1576, address: "서귀포시 토평동", latitude: "33° 21‘ 8“", longitude: "126° 31‘ 58“"),
//        LocationInfo(AWSNum: 869, location: "영실", altitude: 1260, address: "서귀포시 하원동", latitude: "33° 20‘ 53“", longitude: "126° 29‘ 47“"),
//        LocationInfo(AWSNum: 870, location: "진달래밭", altitude: 1489, address: "서귀포시 남원읍 하례리", latitude: "33° 22‘ 11“", longitude: "126° 33‘ 20“"),
//
//        // 추자도
//        LocationInfo(AWSNum: 724, location: "추자도", altitude: 8, address: "제주시 추자면 영흥리", latitude: "33° 57‘ 28“", longitude: "126° 18‘ 5“"),
        
        // == 동 읍 까지만 자른 버전
//        LocationInfo(AWSNum: 184, location: "제주", altitude: 21, address: "제주시 건입동", latitude: "33° 30‘ 50“", longitude: "126° 31‘ 46“"),
//        LocationInfo(AWSNum: 182, location: "제주(공)", altitude: 27, address: "제주시 용담이동", latitude: "33° 50‘ 79“", longitude: "126° 49‘ 14“"),
//        LocationInfo(AWSNum: 329, location: "산천단", altitude: 377, address: "제주시 아라1동", latitude: "33° 26‘ 49“", longitude: "126° 33‘ 54“"),
//        LocationInfo(AWSNum: 863, location: "외도", altitude: 53, address: "제주시 외도1동", latitude: "33° 28‘ 36“", longitude: "126° 25‘ 53“"),
//        LocationInfo(AWSNum: 865, location: "오등", altitude: 234, address: "제주시 오등동", latitude: "33° 27‘ 27“", longitude: "126° 31‘ 19“"),
//        LocationInfo(AWSNum: 893, location: "애월", altitude: 5, address: "제주시 애월읍", latitude: "33° 27‘ 57“", longitude: "126° 19‘ 38“"),
//        LocationInfo(AWSNum: 330, location: "대흘", altitude: 144, address: "제주시 조천읍", latitude: "33° 30‘ 2“", longitude: "126° 38‘ 58“"),
//        LocationInfo(AWSNum: 189, location: "서귀포", altitude: 52, address: "서귀포시 서귀동", latitude: "33° 14‘ 46“", longitude: "126° 33‘ 55“"),
//        LocationInfo(AWSNum: 884, location: "기상(과)", altitude: 173, address: "서귀포시 서호동", latitude: "33° 15‘ 33“", longitude: "126° 31‘ 3“"),
//        LocationInfo(AWSNum: 980, location: "강정", altitude: 135, address: "서귀포시 강정동", latitude: "33° 15‘ 38“", longitude: "126° 29‘ 22“"),
//        LocationInfo(AWSNum: 328, location: "중문", altitude: 64, address: "서귀포시 색달동", latitude: "33° 14‘ 57“", longitude: "126° 24‘ 21“"),
//        LocationInfo(AWSNum: 780, location: "제주남원", altitude: 26, address: "서귀포시 남원읍", latitude: "33° 16‘ 37“", longitude: "126° 42‘ 15“"),
//        LocationInfo(AWSNum: 989, location: "안덕화순", altitude: 90, address: "서귀포시 안덕면", latitude: "33° 15‘ 28“", longitude: "126° 19‘ 47“"),
//        LocationInfo(AWSNum: 188, location: "성산", altitude: 20, address: "서귀포시 성산읍", latitude: "33° 23‘ 12“", longitude: "126° 52‘ 48“"),
//        LocationInfo(AWSNum: 862, location: "송당", altitude: 195, address: "제주시 구좌읍", latitude: "33° 28‘ 14“", longitude: "126° 46‘ 45“"),
//        LocationInfo(AWSNum: 725, location: "우도", altitude: 9, address: "제주시 우도면", latitude: "33° 31‘ 22“", longitude: "126° 57‘ 14“"),
//        LocationInfo(AWSNum: 792, location: "표선", altitude: 80, address: "서귀포시 표선면", latitude: "33° 21‘ 12“", longitude: "126° 49‘ 0“"),
//        LocationInfo(AWSNum: 185, location: "고산", altitude: 71, address: "제주시 한경면", latitude: "33° 17‘ 37“", longitude: "126° 9‘ 46“"),
//        LocationInfo(AWSNum: 779, location: "한림", altitude: 39, address: "제주시 한림읍", latitude: "33° 23‘ 33“", longitude: "126° 15‘ 29“"),
//        LocationInfo(AWSNum: 793, location: "대정", altitude: 3, address: "서귀포시 대정읍", latitude: "33° 14‘ 27“", longitude: "126° 13‘ 34“"),
//        LocationInfo(AWSNum: 867, location: "삼각봉", altitude: 1503, address: "제주시 오라2동", latitude: "33° 22‘ 36“", longitude: "126° 31‘ 49“"),
//        LocationInfo(AWSNum: 866, location: "한라생태숲", altitude: 588, address: "제주시 용강동", latitude: "33° 25‘ 48“", longitude: "126° 35‘ 51“"),
//        LocationInfo(AWSNum: 753, location: "어리목", altitude: 968, address: "제주시 해안동", latitude: "33° 23‘ 34“", longitude: "126° 29‘ 45“"),
//        LocationInfo(AWSNum: 965, location: "한라산남벽", altitude: 1576, address: "서귀포시 토평동", latitude: "33° 21‘ 8“", longitude: "126° 31‘ 58“"),
//        LocationInfo(AWSNum: 869, location: "영실", altitude: 1260, address: "서귀포시 하원동", latitude: "33° 20‘ 53“", longitude: "126° 29‘ 47“"),
//        LocationInfo(AWSNum: 724, location: "추자도", altitude: 8, address: "제주시 추자면", latitude: "33° 57‘ 28“", longitude: "126° 18‘ 5“"),
    ]
}
