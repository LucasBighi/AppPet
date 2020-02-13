//
//  UIVIewController+Extension.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 18/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideNavigationBar(_ hide: Bool) {
        if hide {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.backItem?.title = " "
        }
    }
    
    func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let aaaaction = UIAlertAction(title: "aaaaaa", style: .default) { (action) in
            print(action)
        }
        alert.addAction(aaaaction)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func customAlert(message: String, type: AlertType) -> AlertViewController {
        let customAlert = AlertViewController(nibName: "AlertViewController", bundle: nil)
        customAlert.modalPresentationStyle = .overFullScreen
        customAlert.message = message
        customAlert.type = type
        return customAlert
    }
    
    private func setupLoaderView() -> LoaderViewController {
        let loaderView = LoaderViewController(nibName: "LoaderViewController", bundle: nil)
        loaderView.modalPresentationStyle = .overFullScreen
        return loaderView
    }
    
    func startLoading(loadingMessage: String = "") {
        let loaderView = setupLoaderView()
        self.present(loaderView, animated: false)
        if loadingMessage != "" {
            loaderView.labelMessage.text = loadingMessage
        } else {
            loaderView.labelMessage.text = "Carregando..."
        }
    }
    
    func stopLoading() {
        let loaderView = setupLoaderView()
        loaderView.dismiss(animated: true, completion: nil)
    }
}
