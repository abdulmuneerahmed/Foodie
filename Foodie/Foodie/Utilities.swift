//
//  Utilities.swift
//  Foodie
//
//  Created by admin on 22/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import Foundation
import CoreLocation
struct ApiRequest {
    
 static let apiService = ApiRequest()
    
     let api_Key = "e30df8ae024b52fcb95b604dc0e77fc0"
    
    func currentLocationResturantUrl(coordinate:CLLocationCoordinate2D) -> String{
        return "https://developers.zomato.com/api/v2.1/geocode?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
    }
    
    func selectedLocationResturentURL(coordinate:DroppablePin) -> String{
        return "https://developers.zomato.com/api/v2.1/geocode?lat=\(coordinate.coordinate.latitude)&lon=\(coordinate.coordinate.longitude)"
    }
}

//Resturent Data
struct ResturantData {
    let imageName:String
    let resturantName:String
    let city:String
    let country:String
    let address:String
    
    init(image:String,address:String,resturantName:String,city:String,country:String) {
        self.imageName = image
        self.address = address
        self.resturantName = resturantName
        self.city = city
        self.country = country
    }
}


class Service{
    
    static let service = Service()
    
    var resturantData = [ResturantData]()
    
    func getresturantData() -> [ResturantData]{
        return resturantData
    }
    
}
