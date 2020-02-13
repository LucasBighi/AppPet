//
//  Array+Extension.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 21/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation

extension Array where Element == Schedule {
    
    func mark(_ scheduleIdentifier: String, as status: ScheduleStatus) {
        if let offSet = self.firstIndex(where: {$0.description == scheduleIdentifier}) {
            self[offSet].status = status
        }
    }
    
    func forDay(_ day: Int, inDate: Date) -> [Schedule] {
        var schedulesArray = [Schedule]()
        if let schedules = PUser.shared.schedules {
            for schedule in schedules {
                if schedule.date.get(.day) == day, schedule.date.get(.month) == inDate.get(.month), schedule.date.get(.year) == inDate.get(.year) {
                    schedulesArray.append(schedule)
                }
            }
        }
        return schedulesArray
    }
    
    func forPet(_ pet: Pet) -> [Schedule] {
        var schedulesArray = [Schedule]()
        if let schedules = PUser.shared.schedules {
            for schedule in schedules {
                if schedule.pets.contains(pet) {
                    schedulesArray.append(schedule)
                }
            }
        }
        return schedulesArray
    }
    
    func lateSchedules() -> Int {
        let array = self.map {$0.status == ScheduleStatus.late}
        return array.count
    }
}

extension Array where Element == Pet {
    
    func separated() -> String {
        let array = self.map {$0.name}
        return array.joined(separator: ", ")
    }
    
    func contains(_ pet: Pet) -> Bool {
        let array = self.map {$0.name}
        if array.contains(pet.name) {
            return true
        }
        return false
    }
    
    func index(comparing pet: Pet) -> Int? {
        let array = self.map {$0.name}
        if let offSet = array.firstIndex(where: {$0 == pet.name}) {
            return offSet
        }
        return nil
    }
}
