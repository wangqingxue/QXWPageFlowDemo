//
//  QXWGCDTimerManager.m
//  QXWPagedFlowDemo
//
//  Created by 王庆学 on 2018/1/23.
//  Copyright © 2018年 王庆学. All rights reserved.
//

#import "QXWGCDTimerManager.h"

@interface QXWGCDTimerManager ()

@property (nonatomic, strong) NSMutableDictionary *timerContainer;

@end

@implementation QXWGCDTimerManager

+ (instancetype)shareInstance{
    static QXWGCDTimerManager *timerManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerManager = [[QXWGCDTimerManager alloc]init];
    });
    return timerManager;
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName timeInterval:(double)interval queue:(dispatch_queue_t)queue repeats:(BOOL)repeats action:(dispatch_block_t)action{
    if (timerName == nil) return;
    if (queue == nil){
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
        if (!timer){
            timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_resume(timer);
            [self.timerContainer setObject:timer forKey:timerName];
        }
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(timer, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            action();
            if (!repeats){
                [weakSelf cancelTimerWithName:timerName];
            }
        });
    }
}

- (void)cancelTimerWithName:(NSString *)timerName{
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer){
        return;
    }
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}

- (NSMutableDictionary *)timerContainer{
    if (!_timerContainer){
        _timerContainer = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _timerContainer;
}

@end
