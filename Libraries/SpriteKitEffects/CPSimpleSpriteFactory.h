//
//  CPSimpleSpriteFactory.h
//  SpriteKitEffects
//
//  Created by Allen Cheung on 10/24/13.
//  Copyright (c) 2013 Allen Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPSimpleSpriteFactory : NSObject

+ (UIImage *)imageWithSize:(CGSize)size path:(UIBezierPath *)path fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;

+ (UIImage *)pentagonImageWithDiameter:(CGFloat)diameter fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;
+ (UIImage *)pentagonImageWithDiameter:(CGFloat)diameter fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth;

+ (UIImage *)circleImageWithDiameter:(CGFloat)diameter fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;
+ (UIImage *)circleImageWithDiameter:(CGFloat)diameter fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth;

+ (UIImage *)ovalImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;
+ (UIImage *)ovalImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth;

+ (UIImage *)rectangleImageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;
+ (UIImage *)rectangleImageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth;

+ (UIImage *)starImageWithOuterRadius:(CGFloat)outerRadius innerRadius:(CGFloat)innerRadius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;
+ (UIImage *)starImageWithOuterRadius:(CGFloat)outerRadius innerRadius:(CGFloat)innerRadius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth;

@end
