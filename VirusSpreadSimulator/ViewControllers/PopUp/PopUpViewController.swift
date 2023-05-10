//
//  PopUpViewController.swift
//  VirusSpreadSimulator
//
//  Created by Данил Швец on 08.05.2023.
//

import UIKit

final class PopUpViewController: UIViewController {
    
    private let popUpWindowView = PopUpWindowView()
    var isNotResultPopUp = true
    
    init(title: String, imageName: String, buttontext: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.popupTitle.text = title
        popUpWindowView.popupImage.image = UIImage(named: imageName)
        popUpWindowView.popupButton.setTitle(buttontext, for: .normal)
        popUpWindowView.popupButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view = popUpWindowView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismissView(){
        if isNotResultPopUp {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
}
