//
//  NSTimer+Yibin.h
//  TimerTest
//
//  Created by panyibin on 2018/1/26.
//  Copyright © 2018年 yidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Yibin)

+ (NSTimer *)yb_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
+ (NSTimer *)yb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end
