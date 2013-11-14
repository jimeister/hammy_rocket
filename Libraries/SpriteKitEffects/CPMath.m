//
//  CPMath.m
//  SpriteKitEffects
//
//  Created by Allen Cheung on 10/30/13.
//  Copyright (c) 2013 Allen Cheung. All rights reserved.
//

#import "CPMath.h"

CGFloat CPCGVectorMagnitude(CGVector vector)
{
    return CP_SQRT(vector.dx * vector.dx + vector.dy * vector.dy);
}

CGFloat CPCGVectorAngleInRadians(CGVector vector)
{
    CGFloat rawAngle = CP_ATAN(CP_ABS(vector.dy) / CP_ABS(vector.dx));
    CGFloat angle = 0.0;
    if (vector.dx >= 0.0) {
        if (vector.dy >= 0.0) {
            angle = rawAngle;
        } else {
            angle = 2 * M_PI - rawAngle;
        }
    } else {
        if (vector.dy >= 0.0) {
            angle = M_PI - rawAngle;
        } else {
            angle = M_PI + rawAngle;
        }
    }
    return angle;
}

CGFloat CPCGPointDistance(CGPoint p1, CGPoint p2)
{
    return CP_SQRT(CPCGVectorMagnitude(CGVectorMake(p1.x - p2.x, p1.y - p2.y)));
}
