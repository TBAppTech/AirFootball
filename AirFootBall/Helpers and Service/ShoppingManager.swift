//
//  ShoppingManager.swift
//  AirFootBall
//
//  Created by Roma Bogatchuk on 21.02.2023.
//

import Foundation

class ShoppingManager {
    private init(){}
    static let shared = ShoppingManager()
    private let defaults = UserDefaults.standard
    func purchasedField(field: Int){
        if var array = defaults.array(forKey: "purchasedFields") as? [Int] {
            array.append(field)
            defaults.set(array, forKey: "purchasedFields")
            defaults.synchronize()
            
        }else {
            let field = [field]
            defaults.set(field, forKey: "purchasedFields")
            defaults.synchronize()
        }
    }
    
    func purchasedTeam(team: Int){
        if var array = defaults.array(forKey: "purchasedTeams") as? [Int] {
            array.append(team)
            defaults.set(array, forKey: "purchasedTeams")
            defaults.synchronize()
            
        }else {
            let field = [team]
            defaults.set(field, forKey: "purchasedTeams")
            defaults.synchronize()
        }
    }
}
