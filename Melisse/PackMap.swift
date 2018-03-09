//
//  PackMap.swift
//  Yamato
//
//  Created by Raphaël Calabro on 08/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

public protocol Packable: Hashable {
    var packSize: Size<Int> { get }
}

public class PackMap<Element> where Element : Packable {

    public private(set) var size: Size<Int> = Size(width: 32, height: 32)
    public private(set) var locations = [Element : Point<Int>]()
    
    fileprivate var rows = [Row<Element>]()
    fileprivate var takenHeight = 0
    fileprivate var remainingHeight: Int {
        return size.height - takenHeight
    }
    
    public init(elements: [Element] = []) {
        pack(contentsOf: elements)
    }
    
    public func pack(contentsOf elements: [Element]) {
        if !locations.isEmpty {
            print("This PackMap already contains elements. Cannot pack multiple times.")
            return
        }
        for element in elements.sorted(by: { $0.packSize.height > $1.packSize.height }) {
            add(element)
        }
        rows = []
    }
    
    fileprivate func add(_ element: Element) {
        if locations[element] != nil {
            return
        }
        
        let elementSize = element.packSize
        while true {
            for index in 0 ..< rows.count {
                let row = rows[index]
                if row.size.height >= elementSize.height && row.remainingWidth >= elementSize.width {
                    rows[index].add(element: element)
                    
                    let origin = Point(x: row.origin.x + rows[index].cells.last!.x, y: row.origin.y)
                    locations[element] = origin
                    
                    if row.isLastElementLargerThan(elementSize.height) {
                        rows[index].size.height = elementSize.height
                        rows.insert(Row<Element>(parent: self, origin: Point(x: origin.x, y: origin.y + elementSize.height), height: row.size.height - elementSize.height), at: index + 1)
                    }
                    return
                }
            }
            if remainingHeight >= elementSize.height {
                let origin = Point(x: 0, y: takenHeight)
                rows.append(Row(parent: self, first: element, origin: origin))
                takenHeight += elementSize.height
                
                locations[element] = origin
                return
            } else {
                grow()
            }
        }
    }
    
    fileprivate func grow() {
        self.size = size * 2
    }

}

fileprivate struct Row<Element> where Element : Packable {

    var parent: PackMap<Element>
    var size: Size<Int>
    var origin: Point<Int>
    var cells = [Cell<Element>]()
    
    init(parent: PackMap<Element>, origin: Point<Int>, height: Int) {
        self.parent = parent
        self.size = Size(width: 0, height: height)
        self.cells = []
        self.origin = origin
    }
    
    init(parent: PackMap<Element>, first: Element, origin: Point<Int>) {
        self.parent = parent
        self.size = first.packSize
        self.cells = [Cell(x: 0, element: first)]
        self.origin = origin
    }
    
    var remainingWidth: Int {
        return parent.size.width - size.width - origin.x
    }
    
    mutating func add(element: Element) {
        cells.append(Cell(x: size.width, element: element))
        size.width += element.packSize.width
    }
    
    func isLastElementLargerThan(_ height: Int) -> Bool {
        return (cells.isEmpty && size.height > height)
            || (!cells.isEmpty && cells.last!.element.packSize.height > height)
    }

}

fileprivate struct Cell<Element> where Element : Packable {
    var x: Int
    var element: Element
}
