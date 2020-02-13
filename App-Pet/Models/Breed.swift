//
//  Breeds.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 14/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation

struct ResponseData: Decodable {
    let breed: [Breed]
}

struct Breed {
    let names: [String]?
}

extension Breed: Decodable {
    
    init(dictionary: [String: Any]) {
        self.names = dictionary["Breeds"] as? [String]
    }
}

func loadJson(fileName: String) -> [String]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        if let data = NSData(contentsOf: url) {
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String: Any]
                let breeds = Breed(dictionary: (dictionary)!)
                return breeds.names
            } catch {
                print("Unable to parse")
            }
        }
        print("Unable to load")
    }
    return nil
}
