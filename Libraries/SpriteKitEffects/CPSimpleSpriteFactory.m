//
//  CPSimpleSpriteFactory.m
//  SpriteKitEffects
//
//  Created by Allen Cheung on 10/24/13.
//  Copyright (c) 2013 Allen Cheung. All rights reserved.
//

#import "CPSimpleSpriteFactory.h"
#import "CPMath.h"

static const CGFloat kDefaultLineWidth = 1.0;
static const CGFloat kDefaultGlowWidth = 0.0;
static const BOOL kDefaultAntiAliased = NO;
static const SKBlendMode kDefaultBlendMode = SKBlendModeAlpha;

@implementation CPSimpleSpriteFactory

+ (UIImage *)imageWithSize:(CGSize)size path:(UIBezierPath *)path fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    if (strokeColor) {
        [strokeColor setStroke];
        [path stroke];
    }
    if (fillColor) {
        [fillColor setFill];
        [path fill];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)pentagonImageWithDiameter:(CGFloat)diameter fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor
{
    return [[self class] pentagonImageWithDiameter:diameter fillColor:fillColor strokeColor:strokeColor lineWidth:kDefaultLineWidth];
}

+ (UIImage *)pentagonImageWithDiameter:(CGFloat)diameter fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = lineWidth;
    [path moveToPoint:CGPointMake(diameter/2.0, 0.0)];
    [path addLineToPoint:CGPointMake(diameter/2.0 * (1 - CP_COS(CPDegreesToRadian(18.0))), diameter/2.0 * (1 - CP_SIN(CPDegreesToRadian(18.0))))];
    [path addLineToPoint:CGPointMake(diameter/2.0 * (1 - CP_COS(CPDegreesToRadian(54.0))), diameter/2.0 * (1 + CP_SIN(CPDegreesToRadian(54.0))))];
    [path addLineToPoint:CGPointMake(diameter/2.0 * (1 + CP_COS(CPDegreesToRadian(54.0))), diameter/2.0 * (1 + CP_SIN(CPDegreesToRadian(54.0))))];
    [path addLineToPoint:CGPointMake(diameter/2.0 * (1 + CP_COS(CPDegreesToRadian(18.0))), diameter/2.0 * (1 - CP_SIN(CPDegreesToRadian(18.0))))];
    [path closePath];
    return [[self class] imageWithSize:CGSizeMake(diameter, diameter) path:path fillColor:fillColor strokeColor:strokeColor];
}

+ (UIImage *)circleImageWithDiameter:(CGFloat)diameter fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor
{
    return [[self class] circleImageWithDiameter:diameter fillColor:fillColor strokeColor:strokeColor lineWidth:kDefaultLineWidth];
}

+ (UIImage *)circleImageWithDiameter:(CGFloat)diameter fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth
{
    return [[self class] ovalImageWithSize:CGSizeMake(diameter, diameter) fillColor:fillColor strokeColor:strokeColor lineWidth:lineWidth];
}

+ (UIImage *)ovalImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor
{
    return [[self class] ovalImageWithSize:size fillColor:fillColor strokeColor:strokeColor lineWidth:kDefaultLineWidth];
}

+ (UIImage *)ovalImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth
{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    path.lineWidth = lineWidth;
    return [[self class] imageWithSize:size path:path fillColor:fillColor strokeColor:strokeColor];
}

+ (UIImage *)rectangleImageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor
{
    return [[self class] rectangleImageWithSize:size cornerRadius:cornerRadius fillColor:fillColor strokeColor:strokeColor lineWidth:kDefaultLineWidth];
}

+ (UIImage *)rectangleImageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth
{
    UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0, 0.0, size.width, size.height) cornerRadius:cornerRadius];
    rect.lineWidth = lineWidth;
    return [[self class] imageWithSize:size path:rect fillColor:fillColor strokeColor:strokeColor];
}

+ (UIImage *)starImageWithOuterRadius:(CGFloat)outerRadius innerRadius:(CGFloat)innerRadius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor
{
    return [[self class] starImageWithOuterRadius:outerRadius innerRadius:innerRadius fillColor:fillColor strokeColor:strokeColor lineWidth:kDefaultLineWidth];
}

+ (UIImage *)starImageWithOuterRadius:(CGFloat)outerRadius innerRadius:(CGFloat)innerRadius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = lineWidth;
    [path moveToPoint:CGPointMake(outerRadius, 0.0)];
    BOOL isOuterRadius = NO;
    for ( NSUInteger i = 1; i <= 9; i++ )
    {
        CGFloat angle = i * (2*M_PI / 10.0) - M_PI_2;
        CGFloat radius = (isOuterRadius ? outerRadius : innerRadius);
        [path addLineToPoint:CGPointMake(outerRadius + CP_COS(angle) * radius, outerRadius + CP_SIN(angle) * radius)];
        isOuterRadius = !isOuterRadius;
    }
    [path closePath];
    return [[self class] imageWithSize:CGSizeMake(2*outerRadius, 2*outerRadius) path:path fillColor:fillColor strokeColor:strokeColor];
}

@end
