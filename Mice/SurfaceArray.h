//
//  SurfaceArray.h
//  MeltedIce
//
//  Created by Raphaël Calabro on 06/01/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

#import <GLKit/GLKit.h>

@class Palette;
@class Square;
@class Quadrilateral;
@class Color;

@interface SurfaceArray : NSObject

@property (readonly, nonatomic, nonnull) GLfloat* memory;
@property (readonly, nonatomic) GLsizei count;
@property (readonly, nonatomic) NSInteger capacity;
@property (readonly, nonatomic) NSInteger coordinates;

- (nonnull id)initWithCapacity:(NSInteger)capacity coordinates:(NSInteger)coordinates;

- (void)setValue:(GLfloat)value atIndex:(NSInteger)index;
- (GLfloat)valueAtIndex:(NSInteger)index;

- (void)clear;
- (void)clearFromIndex:(NSInteger)index count:(NSInteger)count;
- (void)clearQuadAtIndex:(NSInteger)index;

- (void)reset;
- (void)appendValue:(GLfloat)value;
- (void)appendTile:(NSInteger)tile fromPalette:(nonnull Palette *)palette;
- (void)appendTile:(GLfloat)width height:(GLfloat)height left:(GLfloat)left top:(GLfloat)top;
- (void)appendQuad:(NSInteger)x y:(NSInteger)y;
- (void)appendQuad:(GLfloat)width height:(GLfloat)height left:(GLfloat)left top:(GLfloat)top distance:(GLfloat)distance;

- (void)setQuad:(NSInteger)reference withSquare:(nonnull Square *)square;
- (void)setQuad:(NSInteger)reference withQuadrilateral:(nonnull Quadrilateral *)quadrilateral;

- (void)setColor:(nonnull Color *)color forQuad:(NSInteger)reference;
- (void)setColorWithWhite:(GLfloat)white alpha:(GLfloat)alpha forQuad:(NSInteger)reference;

@end
