//
//  Distribution.swift
//  Melisse
//
//  Created by Raphaël Calabro on 27/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

/// Permet de récupérer aléatoirement un objet parmi une liste définie. Chaque
/// objet peut posséder un poids qui modifiera sa probabilité d'être tiré.
public struct Distribution<T: Hashable> {
    
    public var top: Int
    public var ceils: [Int]
    public var items: [T]
    
    public init() {
        top = 0
        ceils = []
        items = []
    }
    
    public init(itemsWithProbabilities: [T : Int]) {
        var top = 0
        var ceils = [Int]()
        var items = [T]()
        itemsWithProbabilities.forEach { (item, probability) in
            top += probability
            ceils.append(top)
            items.append(item)
        }
        self.top = top
        self.ceils = ceils
        self.items = items
    }
    
    public init(items: [T], ceils: [Int]) {
        self.items = items
        self.ceils = ceils
        self.top = ceils.last ?? 0
    }
    
    /// Récupère aléatoirement un des objets.
    ///
    /// L'objet renvoyé n'est pas supprimé de la liste, il pourra donc être tiré
    /// plusieurs fois.
    public var randomItem: T {
        return items[randomIndex]
    }
    
    /// Ajoute l'objet donné à la distribution avec le poids donné.
    ///
    /// - Parameter item: Objet à ajouter.
    /// - Parameter chances: Poids de l'objet. Plus la valeur est grande et plus
    /// l'objet sera tiré souvent.
    public mutating func add(item: T, withChances chances: Int) {
        top += chances
        ceils.append(top)
        items.append(item)
    }
    
    /// Retire et renvoie l'un des objets contenu dans la liste.
    ///
    /// L'objet renvoyé est supprimé de cette liste et ne pourra plus être tiré.
    ///
    /// - Returns: Un objet tiré aléatoirement.
    public mutating func pop() -> T {
        let index = randomIndex
        let item = items.remove(at: index)
        
        let previousFloor = index > 0 ? ceils[index - 1] : 0
        let step = ceils.remove(at: index) - previousFloor
        
        top -= step
        
        for i in index ..< items.count {
            ceils[i] -= step
        }
        
        return item
    }
    
    private var randomIndex: Int {
        let chances = random(top)
        
        var index = 0
        while chances >= ceils[index] {
            index += 1
        }
        
        return index
    }
    
}
