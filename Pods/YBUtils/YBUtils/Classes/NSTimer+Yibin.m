//
//  NSTimer+Yibin.m
//  TimerTest
//
//  Created by panyibin on 2018/1/26.
//  Copyright © 2018年 yidian. All rights reserved.
//

#import "NSTimer+Yibin.h"

@implementation NSTimer (Yibin)

+ (NSTimer *)yb_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    
    void (^ydBlock)(NSTimer*) = [block copy];
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(_executeTimerBlock:) userInfo:ydBlock repeats:repeats];
    
    return timer;
}

+ (NSTimer *)yb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    void (^ydBlock)(NSTimer*) = [block copy];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(_executeTimerBlock:) userInfo:ydBlock repeats:repeats];
    
    return timer;
}

+ (void)_executeTimerBlock:(NSTimer*)timer {
    if (timer.userInfo) {
        void (^ydBlock)(NSTimer*) = (void(^)(NSTimer*))(timer.userInfo);
        
        ydBlock(timer);
    }
}

@end
