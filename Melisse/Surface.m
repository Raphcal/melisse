//
//  Quad.m
//  MeltedIce
//
//  Created by Raphaël Calabro on 24/03/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

#import "Surface.h"

#if TARGET_OS_IOS
#import "MeltedIce-Swift.h"
#else
#import "MeltedIce_OSX-Swift.h"
#endif

@interface Surface () {
    NSUInteger _cursor;
}
@end

@implementation Surface

- (id)initWithMemory:(GLfloat *)memory reference:(NSInteger)reference coordinates:(NSInteger)coordinates {
    self = [super init];
    if (self) {
        _memory = memory;
        _cursor = reference * coordinates * [Surfaces vertexesByQuad];
    }
    return self;
}

- (void)clear {
    memset(_memory + _cursor, 0, [Surfaces vertexesByQuad] * [Surfaces coordinatesByVertice] * sizeof(GLfloat));
}

- (void)setQuadWithLeft:(GLfloat)left top:(GLfloat)top width:(GLfloat)width height:(GLfloat)height {
    [self setQuadWithLeft:left right:left + width top:top bottom:top + height];
}

- (void)setQuadWithSquare:(Square *)square {
    [self setQuadWithLeft:square.left right:square.right top:-square.top bottom:-square.bottom];
}

- (void)setQuadWithLeft:(const GLfloat)left right:(const GLfloat)right top:(const GLfloat)top bottom:(const GLfloat)bottom {
    // Bas gauche
    _memory[_cursor] = left;
    _memory[_cursor + 1] = bottom;
    
    // (idem)
    _memory[_cursor + 2] = left;
    _memory[_cursor + 3] = bottom;
    
    // Bas droite
    _memory[_cursor + 4] = right;
    _memory[_cursor + 5] = bottom;
    
    // Haut gauche
    _memory[_cursor + 6] = left;
    _memory[_cursor + 7] = top;
    
    // Haut droite
    _memory[_cursor + 8] = right;
    _memory[_cursor + 9] = top;
    
    // (idem)
    _memory[_cursor + 10] = right;
    _memory[_cursor + 11] = top;
}

- (void)setQuadWithQuadrilateral:(Quadrilateral *)quadrilateral {
    // bas gauche
    _memory[_cursor] = quadrilateral.bottomLeft.x;
    _memory[_cursor + 1] = -quadrilateral.bottomLeft.y;
    
    // (idem)
    _memory[_cursor + 2] = quadrilateral.bottomLeft.x;
    _memory[_cursor + 3] = -quadrilateral.bottomLeft.y;
    
    // bas droite
    _memory[_cursor + 4] = quadrilateral.bottomRight.x;
    _memory[_cursor + 5] = -quadrilateral.bottomRight.y;
    
    // haut gauche
    _memory[_cursor + 6] = quadrilateral.topLeft.x;
    _memory[_cursor + 7] = -quadrilateral.topLeft.y;
    
    // haut droite
    _memory[_cursor + 8] = quadrilateral.topRight.x;
    _memory[_cursor + 9] = -quadrilateral.topRight.y;
    
    // (idem)
    _memory[_cursor + 10] = quadrilateral.topRight.x;
    _memory[_cursor + 11] = -quadrilateral.topRight.y;
}

- (void)setColor:(Color *)color {
    const NSInteger vertexesByQuad = [Surfaces vertexesByQuad];
    NSInteger index = _cursor;
    for (NSInteger vertex = 0; vertex < vertexesByQuad; vertex++) {
        _memory[index++] = color.red;
        _memory[index++] = color.green;
        _memory[index++] = color.blue;
        _memory[index++] = color.alpha;
    }
}

- (void)setColorWithWhite:(GLfloat)white alpha:(GLfloat)alpha {
    const NSInteger vertexesByQuad = [Surfaces vertexesByQuad];
    NSInteger index = _cursor;
    for (NSInteger vertex = 0; vertex < vertexesByQuad; vertex++) {
        _memory[index++] = white;
        _memory[index++] = white;
        _memory[index++] = white;
        _memory[index++] = alpha;
    }
}

@end
