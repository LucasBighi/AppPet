//
//  File.swift
//
//
//  Created by Esdras Firmino Martins on 30/04/18.
//

import UIKit

public protocol NibLoadable {
    static var nibName: String { get }
}

public extension NibLoadable where Self: UIView {
    
    public static var nibName: String {
        return String(describing: Self.self) // defaults to the name of the class implementing this protocol.
    }
    
    public static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }
    
    func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Error loading \(self) from nib") }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutIfNeeded()
        if #available(iOS 11.0, *) {
            
            view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            
            //iOS < 11
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            
        }
    }
}
