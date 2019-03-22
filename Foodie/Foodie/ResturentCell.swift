//
//  ResturentCell.swift
//  Foodie
//
//  Created by admin on 21/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit
class ResturentCell:UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var coverView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView:CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenirnext-Heavy", size: 12)
        label.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    lazy var addressTitle:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenirnext-Heavy", size: 10)
        label.backgroundColor = .white
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Address :"
        return label
    }()
    lazy var addressLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 10)
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    lazy var cityTitle:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenirnext-Heavy", size: 10)
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "City : "
        return label
    }()
    lazy var cityLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 10)
        label.textAlignment = .right
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    lazy var countryTitle:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenirnext-Heavy", size: 10)
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Country : "
        return label
    }()
    lazy var countryLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 10)
        label.backgroundColor = .white
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    func setup(){
        addSubview(coverView)
        
        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: self.topAnchor),
            coverView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            coverView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        
        coverView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
            ])
        
        coverView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 10),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
            ])
        
        coverView.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 10),
            titleView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -10),
            titleView.bottomAnchor.constraint(equalTo: coverView.safeAreaLayoutGuide.bottomAnchor, constant: -2)
            ])
        
        titleView.addSubview(addressTitle)
        NSLayoutConstraint.activate([
            addressTitle.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 0),
            addressTitle.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 0),
            addressTitle.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: 0.5),
            addressTitle.heightAnchor.constraint(equalTo: titleView.heightAnchor, multiplier: 0.2)
            ])
        
        titleView.addSubview(addressLabel)
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 0),
            addressLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 0),
            addressLabel.topAnchor.constraint(equalTo: addressTitle.bottomAnchor, constant: 0),
            addressLabel.heightAnchor.constraint(equalTo: titleView.heightAnchor, multiplier: 0.4)
            ])
        
        
        let city = stackview(views: [cityTitle,cityLabel], axis: .horizontal)
        let country = stackview(views: [countryTitle,countryLabel], axis: .horizontal)
        titleView.addSubview(city)
        
        NSLayoutConstraint.activate([
            city.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 0),
            city.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 0),
            city.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 0),
            city.heightAnchor.constraint(equalTo: titleView.heightAnchor, multiplier: 0.2)
            ])
        titleView.addSubview(country)
        
        NSLayoutConstraint.activate([
            country.topAnchor.constraint(equalTo: city.bottomAnchor, constant: 0),
            country.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 0),
            country.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 0),
            country.heightAnchor.constraint(equalTo: titleView.heightAnchor, multiplier: 0.2)
            ])
    }
    
    func stackview(views:[UIView],axis:NSLayoutConstraint.Axis) -> UIStackView{
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.spacing = 0
        return stackView
    }
    
    func loadDataInCell(data:ResturantData){
        if data.imageName != ""{
            imageView.loadImageUsingUrlString(urlString: data.imageName)
        }else{
            imageView.image = UIImage(named: "dinner")
        }
        nameLabel.text = data.resturantName
        addressLabel.text = data.address
        countryLabel.text = data.country
        cityLabel.text = data.city
    }
}

