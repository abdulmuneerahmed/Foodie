//
//  ViewController.swift
//  Foodie
//
//  Created by admin on 21/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MainVc: UIViewController,UIGestureRecognizerDelegate {
    
    private let reuseCell = "CellId"
    
    let apiService = ApiRequest.apiService
    let service = Service.service
    
    let locationManager = CLLocationManager()
    
    let region:Double = 10000
    
    
    let headers:HTTPHeaders = [
        "user-key": ApiRequest.apiService.api_Key,
        "Accept": "application/json"
    ]
    
    
    var collectionContainerHeight:NSLayoutConstraint!
    var buttonBottomHeight:NSLayoutConstraint!
    var collectionBottomAnchor:NSLayoutConstraint!
    var spinnerConstraints:[NSLayoutConstraint] = []
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    
    //MARK:- View init Functions
    
    override func loadView() {
        super.loadView()
        navigationSetup()
        setupView()
        addTapGesture()
        addSwipe()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
        locationStatusCheck()
        collectionSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
//

    //MARK:- Defining the View
    
    lazy var mapView:MKMapView = {
        let mapView = MKMapView()
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var collectionViewContainer:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isHidden = true
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        
        spinner.style = .whiteLarge
        spinner.color = .orange
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    lazy var nodataLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Avenirnext-Heavy", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "😕 No Data Found Try Another Location..."
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        label.textColor = .black
        return label
    }()
    
    lazy var currentLocationButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Location"), for: .normal)
        button.addTarget(self, action: #selector(locationButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
//------------------Functions----------------------//
    
    //MARK:- navigation Setup
    func navigationSetup(){
        navigationController?.navigationBar.barTintColor = .orange
        
    }
    
    //MARK:- For Loading Views
    func setupView(){
        view.backgroundColor = .white
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        view.addSubview(currentLocationButton)
        NSLayoutConstraint.activate([
            currentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            currentLocationButton.widthAnchor.constraint(equalToConstant: 60),
            currentLocationButton.heightAnchor.constraint(equalToConstant: 60)
            ])
        
        buttonBottomHeight = currentLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10)
        buttonBottomHeight.isActive = true
        
        view.addSubview(collectionViewContainer)
        
        NSLayoutConstraint.activate([
            collectionViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
        collectionContainerHeight = collectionViewContainer.heightAnchor.constraint(equalToConstant: 0)
        collectionContainerHeight.isActive = true
        
        
        
        collectionViewContainer.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: collectionViewContainer.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: collectionViewContainer.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor, constant: 10)
            ])
        collectionBottomAnchor = collectionView.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor, constant: 0)
        
        collectionViewContainer.addSubview(spinner)
        
        spinnerConstraints = [
            spinner.centerXAnchor.constraint(equalTo: collectionViewContainer.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: collectionViewContainer.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 50),
            spinner.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        collectionViewContainer.addSubview(nodataLabel)
        
        NSLayoutConstraint.activate([
            nodataLabel.centerXAnchor.constraint(equalTo: collectionViewContainer.centerXAnchor, constant: 0),
            nodataLabel.centerYAnchor.constraint(equalTo: collectionViewContainer.centerYAnchor, constant: 0),
            nodataLabel.widthAnchor.constraint(equalTo: collectionViewContainer.widthAnchor, constant: 0),
            nodataLabel.heightAnchor.constraint(equalTo: collectionViewContainer.heightAnchor, multiplier: 0.2)
            ])
        
    }
    

    //MARK:- LocationManager Setup
    func locationSetup(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    //MARK:- Adding TapGesture To MapView
    func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dropPin(gesture:)))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        mapView.addGestureRecognizer(tap)
    }
    
    //Mark:- checking authorizationStatus
    func locationStatusCheck(){
        switch authorizationStatus {
        case .authorizedAlways,.authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted,.denied:
            locationManager.requestAlwaysAuthorization()
            break
        }
    }
    
    
    //MARK:- Function To Center the Selected Location
    func centerLocation(){
        guard let coordinate = locationManager.location?.coordinate else{return}
        let setregion = MKCoordinateRegion(center: coordinate, latitudinalMeters: region, longitudinalMeters: region)
        mapView.setRegion(setregion, animated: true)
        
    }
    
    //MARK:- Increasing the collectionViewContainer Height
    
    func increaseCollectionHeight(){
        nodataLabel.isHidden = true
        buttonBottomHeight.isActive = false
        
        UIView.animate(withDuration: 0.5) {
            self.collectionContainerHeight.constant = self.view.frame.height/2 - 50
            self.buttonBottomHeight = self.currentLocationButton.bottomAnchor.constraint(equalTo: self.collectionViewContainer.topAnchor, constant: -10)
            self.buttonBottomHeight.isActive = true
            self.view.layoutIfNeeded()
        }
        collectionBottomAnchor.isActive = true
        NSLayoutConstraint.activate(spinnerConstraints)
        
        spinner.startAnimating()
        
    }
    
    //Remove Pin
    func removePin(){
        for annotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
    }
    
    func collectionSetup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ResturentCell.self, forCellWithReuseIdentifier: reuseCell)
    }
    
    //adding Swipe
    
    func addSwipe(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipe.direction = .down
        collectionViewContainer.addGestureRecognizer(swipe)
    }
    
   
    func removeData(){
        service.resturantData.removeAll()
        collectionView.reloadData()
    }
    
    //CanCel All Downloade sesions
    
    func cancelAllSession(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloaddata) in
            sessionDataTask.forEach({ $0.cancel() })
            downloaddata.forEach({ $0.cancel() })
        }
    }
    
//-------------Selectors---------------//
    
    
    //MARK:- location Button Taps
    
    @objc func locationButton(){
        
        centerLocation()
        removePin()
        removeData()
        increaseCollectionHeight()
        collectionView.isHidden = true
        spinner.startAnimating()
        guard let coordinate = locationManager.location?.coordinate else{return}
        retriveData(url: apiService.currentLocationResturantUrl(coordinate: coordinate)) { status in
            if status {
                self.spinner.stopAnimating()
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }else{
                self.spinner.stopAnimating()
                self.nodataLabel.isHidden = false
            }
        }
        
    }
    
    
    //MARK:- dropping Pin Function
    
    @objc func dropPin(gesture:UITapGestureRecognizer){
        removePin()
        collectionView.isHidden = true
        cancelAllSession()
        removeData()
        increaseCollectionHeight()
        let touchPoint = gesture.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        
        let coordinateRegion = MKCoordinateRegion.init(center: touchCoordinate, latitudinalMeters: region, longitudinalMeters: region)
        mapView.setRegion(coordinateRegion, animated: true)
        
        retriveData(url: apiService.selectedLocationResturentURL(coordinate: annotation)) { status in
            if status {
                self.spinner.stopAnimating()
                self.nodataLabel.isHidden = true
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }else{
                self.spinner.stopAnimating()
                self.nodataLabel.isHidden = false
            }
        }
    }
    
    @objc func dismissView(){
        cancelAllSession()
        removeData()
        collectionView.reloadData()
        buttonBottomHeight.isActive = false
        spinner.stopAnimating()
        NSLayoutConstraint.deactivate(spinnerConstraints)
        collectionBottomAnchor.isActive = false
        UIView.animate(withDuration: 0.5) {
            self.collectionContainerHeight.constant = 0
            self.buttonBottomHeight = self.currentLocationButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -10)
            self.buttonBottomHeight.isActive = true
            self.view.layoutIfNeeded()
        }
        
        
    }
    
   
}

extension MainVc:CLLocationManagerDelegate{

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerLocation()
    }
    
}


extension MainVc:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return service.getresturantData().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? ResturentCell else{return UICollectionViewCell()}
        cell.loadDataInCell(data: service.getresturantData()[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewContainer.frame.width/2 - 20, height: collectionView.frame.height - 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

}

extension MainVc{
    
   
    func retriveData(url:String,completion: @escaping (_ status:Bool)->()){
        Alamofire.request(url,headers:headers).responseJSON { (response) in
//            print(response)
            guard let json = response.result.value as? Dictionary<String,AnyObject> else{
                completion(false)
                return}
            
            guard let location = json["location"] as? Dictionary<String,AnyObject> else{
                completion(false)
                return }
            
            let countryName = location["country_name"] as! String
            guard let near_resturants = json["nearby_restaurants"] as? [Dictionary<String,AnyObject>] else{
                completion(false)
                return }
            
            for resturant in near_resturants{
                let res = resturant["restaurant"] as! Dictionary<String,AnyObject>
                let location = res["location"] as! Dictionary<String,AnyObject>
                let address = location["address"] as! String
                let resturant_name = res["name"] as! String
                let resturant_image = res["thumb"] as! String
                let city = location["city"] as! String
                
                self.service.resturantData.append(ResturantData(image: resturant_image, address: address, resturantName: resturant_name, city: city, country: countryName))
            
            }

            
            completion(true)
        }
    }
}
