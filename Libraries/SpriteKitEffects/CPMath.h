//
//  CPMath.h
//  SpriteKitEffects
//
//  Created by Allen Cheung on 10/30/13.
//  Copyright (c) 2013 Allen Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>

#if (CGFLOAT_IS_DOUBLE == 1)
#define CP_SQRT(n) (sqrt(n))
#define CP_SIN(n) (sin(n))
#define CP_ASIN(n) (asin(n))
#define CP_COS(n) (cos(n))
#define CP_ACOS(n) (acos(n))
#define CP_TAN(n) (tan(n))
#define CP_ATAN(n) (atan(n))
#define CP_ABS(n) (fabs(n))
#else
#define CP_SQRT(n) (sqrtf(n))
#define CP_SIN(n) (sinf(n))
#define CP_ASIN(n) (asinf(n))
#define CP_COS(n) (cosf(n))
#define CP_ACOS(n) (acosf(n))
#define CP_TAN(n) (tanf(n))
#define CP_ATAN(n) (atanf(n))
#define CP_ABS(n) (fabsf(n))
#endif

#define CPRadianToDegrees(n) ((n) * 180.0 / M_PI)
#define CPDegreesToRadian(n) ((n) * M_PI / 180.0)

CGFloat CPCGVectorMagnitude(CGVector vector);
CGFloat CPCGVectorAngleInRadians(CGVector vector);
CGFloat CPCGPointDistance(CGPoint p1, CGPoint p2);