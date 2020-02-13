//
//  Schedule.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 17/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation

enum ScheduleType: String, CaseIterable {
    case pet = "Pet"
    case tosa = "Tosa"
    case passeio = "Passeio"
    case remedio = "Remédio"
    case refeicao = "Refeição"
    case none
    
    init(value: String) {
        switch value {
        case "Pet":
            self = .pet
        case "Tosa":
            self = .tosa
        case "Passeio":
            self = .passeio
        case "Remédio":
            self = .remedio
        case "Refeição":
            self = .refeicao
        default:
            self = .none
        }
    }
}

enum ScheduleStatus: Int {
    case scheduled
    case done
    case late
    case none
    
    init(value: Int) {
        switch value {
        case 0:
            self = .scheduled
        case 1:
            self = .done
        case 2:
            self = .late
        default:
            self = .none
        }
    }
}

class Schedule {
    var pets: [Pet] = []
    var date: Date = Date()
    var type: ScheduleType!
    var allDays: Bool
    var description: String = ""
    var status: ScheduleStatus!
    var identifier: String!
    
    init(pets: [Pet], date: Date, type: ScheduleType, allDays: Bool, description: String) {
        self.pets = pets
        self.date = date
        self.type = type
        self.allDays = allDays
        self.description = description
        self.status = ScheduleStatus.scheduled
        self.identifier = description
    }
}
