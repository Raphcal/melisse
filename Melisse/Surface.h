//
//  Quad.h
//  MeltedIce
//
//  Created by Raphaël Calabro on 24/03/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

#import <GLKit/GLKit.h>

@class Square;
@class Quadrilateral;
@class Color;

@interface Surface : NSObject

@property (readonly, nonatomic, nonnull) GLfloat* memory;

- (nonnull id)initWithMemory:(nonnull GLfloat *)memory reference:(NSInteger)reference coordinates:(NSInteger)coordinates;

/// Efface le contenu de la surface en positionnant ses coordonnées à 0.
- (void)clear;

/// Défini les points de la surface à partir de son point haut-gauche avec la largeur et la hauteur donnée.
///
/// \param left Gauche du quad.
/// \param top Haut du quad.
/// \param width Largeur du quad.
/// \param height Hauteur du quad.
- (void)setQuadWithLeft:(GLfloat)left top:(GLfloat)top width:(GLfloat)width height:(GLfloat)height;

/// Défini les points de la surface à partir du rectangle donné.
///
/// Les coordonnées verticales seront inversées.
///
/// \param square Rectangle à utiliser.
- (void)setQuadWithSquare:(nonnull Square *)square;

/// Défini les points de la surface à partir du quadrilatère donné. La forme peut être différente d'un carré.
///
/// Les coordonnées verticales seront inversées.
///
/// \param quadrilateral Quadrilatère à utiliser.
- (void)setQuadWithQuadrilateral:(nonnull Quadrilateral *)quadrilateral;

- (void)setColor:(nonnull Color *)color;
- (void)setColorWithWhite:(GLfloat)white alpha:(GLfloat)alpha;

@end
