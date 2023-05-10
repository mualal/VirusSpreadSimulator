//
//  PopUpWindowView.swift
//  VirusSpreadSimulator
//
//  Created by Данил Швец on 08.05.2023.
//

import UIKit

class PopUpWindowView: UIView {
    
    struct UIConstants {
        static let cornerRadius: CGFloat = 30
        static let popViewSize: CGFloat = 300
        static let popUpTitleHeight: CGFloat = 55
        static let popUpTextHeight: CGFloat = 67
        static let popUpVerticalPadding: CGFloat = 8
        static let popUpHorizontalPadding: CGFloat = 8
        static let popUpButtonHeight: CGFloat = 60
    }
    
    var popupView = UIView(frame: CGRect.zero)
    var popupTitle = UILabel(frame: CGRect.zero)
    var popupImage = UIImageView(frame: CGRect.zero)
    var popupButton = UIButton(frame: CGRect.zero)
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .black.withAlphaComponent(0.3)
        
        popupView.backgroundColor = UIColor(red: 0.69, green: 0.85, blue: 1.00, alpha: 1.00)
        popupView.layer.masksToBounds = true
        popupView.layer.cornerRadius = UIConstants.cornerRadius
        
        popupTitle.textColor = .black
        popupTitle.backgroundColor = UIColor(red: 0.42, green: 0.61, blue: 0.81, alpha: 1.00)
        popupTitle.layer.masksToBounds = true
        popupTitle.adjustsFontSizeToFitWidth = true
        popupTitle.clipsToBounds = true
        popupTitle.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupTitle.numberOfLines = 1
        popupTitle.textAlignment = .center
        
        popupImage.backgroundColor = UIColor(red: 0.69, green: 0.85, blue: 1.00, alpha: 1.00)
        popupImage.contentMode = .scaleAspectFit
        
        popupButton.setTitleColor(.black, for: .normal)
        popupButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupButton.backgroundColor = UIColor(red: 0.42, green: 0.61, blue: 0.81, alpha: 1.00)
        
        popupView.addSubview(popupTitle)
        popupView.addSubview(popupImage)
        popupView.addSubview(popupButton)
        
        addSubview(popupView)
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        popupView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        popupView.widthAnchor.constraint(equalToConstant: UIConstants.popViewSize).isActive = true
        popupView.heightAnchor.constraint(equalToConstant: UIConstants.popViewSize).isActive = true
        
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        popupTitle.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
        popupTitle.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        popupTitle.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        popupTitle.heightAnchor.constraint(equalToConstant: UIConstants.popUpTitleHeight).isActive = true
        
        popupImage.translatesAutoresizingMaskIntoConstraints = false
        popupImage.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: UIConstants.popUpVerticalPadding).isActive = true
        popupImage.bottomAnchor.constraint(equalTo: popupButton.topAnchor, constant: -UIConstants.popUpVerticalPadding).isActive = true
        popupImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        popupImage.widthAnchor.constraint(equalTo: popupImage.heightAnchor).isActive = true
        popupImage.layer.cornerRadius = UIConstants.cornerRadius
        popupImage.layer.masksToBounds = true
        popupImage.contentMode = .scaleAspectFill
        
        popupButton.translatesAutoresizingMaskIntoConstraints = false
        popupButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        popupButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        popupButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
        popupButton.heightAnchor.constraint(equalToConstant: UIConstants.popUpButtonHeight).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
