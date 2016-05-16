//
//  Menu.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 20/01/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public typealias MenuItemListener = (item: MenuItem) -> Void

public protocol MenuItem {
    
    var frame: Rectangle<GLfloat> { get }
    var value: Any? { get set }
    
}

public struct TextMenuItem : MenuItem {
    
    public var frame : Rectangle<GLfloat> {
        get {
            return Rectangle(top: text.frame.top - padding, bottom: text.frame.bottom + padding, left: text.frame.left, right: text.frame.right)
        }
    }
    public var value: Any?
    public var text: Text
    let padding: GLfloat = 4
    
    public init(text: String, font: Font, factory: SpriteFactory) {
        self.text = Text(factory: factory, font: font, text: text)
    }
    
}

public protocol Layout {
    
    func pointFor(item: MenuItem) -> Point<GLfloat>
    
}

public class VerticalLayout : Layout {
    
    private let origin: Point<GLfloat>
    private let margin: GLfloat = 4
    
    private var y: GLfloat
    
    init(origin: Point<GLfloat>, margin: GLfloat = 4) {
        self.origin = origin
        self.margin = margin
        self.y = origin.y
    }
    
    public func pointFor(item: MenuItem) -> Point<GLfloat> {
        let point = Point(x: origin.x, y: y + margin)
        self.y += item.frame.height + margin + margin
        return point
    }
    
}

public class Menu {
    
    let factory: SpriteFactory
    let cursor: Sprite?
    let layout: Layout?
    
    public let font: Font
    
    public var items = [MenuItem]()
    public private(set) var selection: Int = -1
    public var selectedItem: MenuItem {
        get {
            return items[selection]
        }
    }
    
    var onSelection: MenuItemListener?
    
    public init() {
        self.factory = SpriteFactory()
        self.cursor = nil
        self.layout = nil
        self.font = NoFont()
    }
    
    public init(factory: SpriteFactory, layout: Layout? = nil, font: Font) {
        self.factory = factory
        self.cursor = factory.sprite(font.cursorDefintion)
        self.layout = layout
        self.font = font
    }
    
    public func add(text: String, withValue value: Any? = nil, alignment: TextAlignment = .Left) {
        var item = TextMenuItem(text: text, font: font, factory: factory)
        item.value = value
        
        if let location = layout?.pointFor(item) {
            item.text.setOrigin(location, with: alignment)
        }
        
        self.items.append(item)
        
        if selection == -1 {
            selectItemAt(0)
        }
    }
    
    public func update() {
        if Input.instance.touches.count == 1 {
            let touch = Input.instance.touches.values.first!
            if let index = itemIndexFor(touch) {
                selectItemAt(index)
                onSelection?(item: selectedItem)
            }
        } else if Input.instance.pressed(.Down) {
            selectItemAt(selection + 1)
        } else if Input.instance.pressed(.Up) {
            selectItemAt(selection - 1)
        } else if Input.instance.pressed(.Start) || Input.instance.pressed(.Jump) {
            onSelection?(item: selectedItem)
        }
    }
    
    private func selectItemAt(index: Int) {
        self.selection = min(max(index, 0), items.count - 1)
        
        let square = selectedItem.square
        cursor.center = Spot(x: square.left - cursor.width - cursor.width, y: square.y)
    }
    
    private func itemIndexFor(touch: Spot) -> Int? {
        let ratio = View.instance.ratio
        let point = Spot(x: touch.x * ratio, y: touch.y * ratio)
        
        for index in 0..<items.count {
            if SimpleHitbox(square: items[index].square).collidesWith(point) {
                return index
            }
        }
        
        return nil
    }
    
}