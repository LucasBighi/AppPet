//
//  UIButton+Extension.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 28/08/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
//    open override func draw(_ rect: CGRect) {
//        self.clipsToBounds = true
//        //Set image color to text color
//        if let image = self.image(for: .normal) {
//            let tintedImage = image.withRenderingMode(.alwaysTemplate)
//            self.setImage(tintedImage, for: .normal)
//        }
//        if let bgImage = self.backgroundImage(for: .normal) {
//            let tintedImage = bgImage.withRenderingMode(.alwaysTemplate)
//            self.setBackgroundImage(tintedImage, for: .normal)
//        }
//    }
}

@objc class ClosureSleeve: NSObject {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke() {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
