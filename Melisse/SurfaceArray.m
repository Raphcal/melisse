//
//  SurfaceArray.m
//  MeltedIce
//
//  Created by Raphaël Calabro on 06/01/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

#import "SurfaceArray.h"

#if TARGET_OS_IOS
#import "MeltedIce-Swift.h"
#else
#import "MeltedIce_OSX-Swift.h"
#endif

#define SET_QUAD(INDEX, LEFT, RIGHT, TOP, BOTTOM) _memory[INDEX] = LEFT; _memory[INDEX + 1] = BOTTOM; _memory[INDEX + 2] = LEFT; _memory[INDEX + 3] = BOTTOM; _memory[INDEX + 4] = RIGHT; _memory[INDEX + 5] = BOTTOM; _memory[INDEX + 6] = LEFT; _memory[INDEX + 7] = TOP; _memory[INDEX + 8] = RIGHT; _memory[INDEX + 9] = TOP; _memory[INDEX + 10] = RIGHT; _memory[INDEX + 11] = TOP;

@interface SurfaceArray() {
    NSInteger _cursor;
}
@end

@implementation SurfaceArray

- (id)initWithCapacity:(NSInteger)capacity coordinates:(NSInteger)coordinates {
    self = [super init];
    if (self) {
        NSInteger total = capacity * coordinates;
        
        _capacity = total;
        _coordinates = coordinates;
        _memory = malloc(sizeof(GLfloat) * total);
    }
    
    return self;
}

- (void)dealloc {
    free(_memory);
}

- (void)setValue:(GLfloat)value atIndex:(NSInteger)index {
#if CHECK_CAPACITY
    if (index >= 0 && index < capacity) {
        _memory[index] = value;
    } else {
        NSLog("set: l'index %d est hors limites (0 à %d).", index, _capacity);
    }
#else
    _memory[index] = value;
#endif
}

- (GLfloat)valueAtIndex:(NSInteger)index {
#if CHECK_CAPACITY
    if (index >= 0 && index < capacity) {
        return _memory[index];
    } else {
        NSLog("get: l'index %d est hors limites (0 à %d).", index, _capacity);
        return -1.0f;
    }
#else
    return _memory[index];
#endif
}

- (GLsizei)count {
    return (GLsizei) (_cursor / _coordinates);
}

- (void)clear {
    memset(_memory, 0, _capacity * sizeof(GLfloat));
}

- (void)clearFromIndex:(NSInteger)index count:(NSInteger)count {
    memset(_memory + index * _coordinates, 0, count * _coordinates * sizeof(GLfloat));
}

- (void)clearQuadAtIndex:(NSInteger)index {
    NSInteger vertexesByQuad = [Surfaces vertexesByQuad];
    [self clearFromIndex: index * vertexesByQuad count: vertexesByQuad];
}

- (void)reset {
    _cursor = 0;
}

- (void)appendValue:(GLfloat)value {
#if CHECK_CAPACITY
    if (_cursor < _capacity) {
        _memory[_cursor++] = value;
    } else {
        NSLog("append: capacité insuffisante (%d).", _capacity);
    }
#else
    _memory[_cursor++] = value;
#endif
}

- (void)appendTile:(NSInteger)tile fromPalette:(Palette *)palette {
    [self appendTile: palette.tileWidth
              height: palette.tileHeight
                left: (tile % palette.columns) * (palette.tileWidth + palette.paddingX) + palette.paddingX
                 top: (tile / palette.columns) * (palette.tileHeight + palette.paddingY) + palette.paddingY];
}

- (void)appendTile:(GLfloat)width height:(GLfloat)height left:(GLfloat)left top:(GLfloat)top {
#if CHECK_CAPACITY
    if (_cursor + 12 >= _capacity) {
        NSLog("appendTile: capacité insuffisante (requis %d, disponible %d)", _cursor + 12, _capacity);
        return;
    }
#endif
    // Bas gauche
    _memory[_cursor] = left;
    _memory[_cursor + 1] = top + height;
    
    // (idem)
    _memory[_cursor + 2] = left;
    _memory[_cursor + 3] = top + height;
    
    // Bas droite
    _memory[_cursor + 4] = left + width;
    _memory[_cursor + 5] = top + height;
    
    // Haut gauche
    _memory[_cursor + 6] = left;
    _memory[_cursor + 7] = top;
    
    // Haut droite
    _memory[_cursor + 8] = left + width;
    _memory[_cursor + 9] = top;
    
    // (idem)
    _memory[_cursor + 10] = left + width;
    _memory[_cursor + 11] = top;
    
    _cursor += 12;
}

- (void)appendQuad:(NSInteger)x y:(NSInteger)y {
    GLfloat tileSize = [Surfaces tileSize];
    [self appendQuad:tileSize height:tileSize left:x * tileSize top:y * tileSize distance:0];
}

- (void)appendQuad:(GLfloat)width height:(GLfloat)height left:(GLfloat)left top:(GLfloat)top distance:(GLfloat)distance {
#if CHECK_CAPACITY
    if (_cursor + 12 >= _capacity) {
        NSLog("appendQuad: capacité insuffisante (requis %d, capacité %d)", _cursor + 18, _capacity);
        return;
    }
#endif
    const GLfloat invertedTop = -top;
    
    SET_QUAD(_cursor, left, left + width, invertedTop, invertedTop - height)
    
    _cursor += 12;
}

- (void)setQuad:(NSInteger)reference withSquare:(Square *)square {
    NSInteger entry = reference * [Surfaces coordinatesByVertice] * [Surfaces vertexesByQuad];
    SET_QUAD(entry, square.left, square.right, -square.top, -square.bottom)
}

- (void)setQuad:(NSInteger)reference withQuadrilateral:(Quadrilateral *)quadrilateral {
    NSInteger entry = reference * [Surfaces coordinatesByVertice] * [Surfaces vertexesByQuad];
    
    // bas gauche
    _memory[entry] = quadrilateral.bottomLeft.x;
    _memory[entry + 1] = -quadrilateral.bottomLeft.y;
    
    // (idem)
    _memory[entry + 2] = quadrilateral.bottomLeft.x;
    _memory[entry + 3] = -quadrilateral.bottomLeft.y;
    
    // bas droite
    _memory[entry + 4] = quadrilateral.bottomRight.x;
    _memory[entry + 5] = -quadrilateral.bottomRight.y;
    
    // haut gauche
    _memory[entry + 6] = quadrilateral.topLeft.x;
    _memory[entry + 7] = -quadrilateral.topLeft.y;
    
    // haut droite
    _memory[entry + 8] = quadrilateral.topRight.x;
    _memory[entry + 9] = -quadrilateral.topRight.y;
    
    // (idem)
    _memory[entry + 10] = quadrilateral.topRight.x;
    _memory[entry + 11] = -quadrilateral.topRight.y;
}

- (void)setColor:(Color *)color forQuad:(NSInteger)reference {
    const NSInteger vertexesByQuad = [Surfaces vertexesByQuad];
    NSInteger entry = reference * vertexesByQuad * [Surfaces coordinatesByColor];
    
    for (NSInteger vertex = 0; vertex < vertexesByQuad; vertex++) {
        _memory[entry++] = color.red;
        _memory[entry++] = color.green;
        _memory[entry++] = color.blue;
        _memory[entry++] = color.alpha;
    }
}

- (void)setColorWithWhite:(GLfloat)white alpha:(GLfloat)alpha forQuad:(NSInteger)reference {
    const NSInteger vertexesByQuad = [Surfaces vertexesByQuad];
    NSInteger entry = reference * vertexesByQuad * [Surfaces coordinatesByColor];
    
    for (NSInteger vertex = 0; vertex < vertexesByQuad; vertex++) {
        _memory[entry++] = white;
        _memory[entry++] = white;
        _memory[entry++] = white;
        _memory[entry++] = alpha;
    }
}

@end
