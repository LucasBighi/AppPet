//
//  AlertViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 22/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

enum AlertType: String {
    case success
    case error
    case alert
    case none
    
    init(type: String) {
        switch type {
        case "success":
            self = .success
        case "error":
            self = .error
        case "Alert":
            self = .alert
        default:
            self = .none
        }
    }
}

class AlertViewController: UIViewController {
    
    @IBOutlet var okButton: UIButton!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    var message: String = ""
    var type: AlertType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        separatorView.layer.borderColor = UIColor.darkGray.cgColor
        separatorView.layer.borderWidth = 0.3
        descriptionLabel.text = message
        if let type = type {
            switch type {
            case .success:
                setupSucess()
            case .error:
                setupError()
            case .alert:
                setupAlert()
            case .none:
                print("Alert not implemented")
            }
        }
    }
    
    func setupSucess() {
        iconButton.setBackgroundImage(UIImage(named: "success"), for: .normal)
        iconButton.tintColor = UIColor.customGreen
        descriptionLabel.textColor = UIColor.customGreen
        container.backgroundColor = UIColor.customLightGreen
    }
    
    func setupError() {
        iconButton.setBackgroundImage(UIImage(named: "error"), for: .normal)
        iconButton.tintColor = UIColor.customRed
        descriptionLabel.textColor = UIColor.customRed
        container.backgroundColor = UIColor.customLightRed
    }
    
    func setupAlert() {
        iconButton.setBackgroundImage(UIImage(named: "alert"), for: .normal)
        iconButton.tintColor = UIColor.customYellow
        descriptionLabel.textColor = UIColor.customYellow
        //container.backgroundColor = UIColor.customLightYellow
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
