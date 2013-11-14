//
//  YKLevelScheduler.h
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKLevelEvent.h"

@interface YKLevelScheduler : NSObject

- (YKLevelEvent *)eventForCurrentTime:(NSTimeInterval)currentTime;

@end
