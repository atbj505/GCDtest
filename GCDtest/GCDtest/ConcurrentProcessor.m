//
//  ConcurrentProcessor.m
//  GCDtest
//
//  Created by Robert on 15/3/15.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ConcurrentProcessor.h"

@interface ConcurrentProcessor ()

@property (nonatomic, assign) NSInteger computeResult;

@end

@implementation ConcurrentProcessor {
    NSString *_computeID;
    NSUInteger _computeTasks;
    NSLock *_computeLock;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _isFinished = NO;
        _computeResult = 0;
        _computeLock = [NSLock new];
        _computeID = @"1";
        _computeTasks = 0;
    }
    return self;
}

-(void)computeTask:(id)data{
    NSAssert([data isKindOfClass:[NSNumber class]], @"not an number instance");
    NSUInteger computation = [data unsignedIntegerValue];
    @autoreleasepool {
        @try {
            if ([[NSThread currentThread] isCancelled]) {
                return;
            }
            @synchronized(_computeID){
                _computeTasks++;
            }
            
            [_computeLock lock];
            if ([[NSThread currentThread] isCancelled]) {
                [_computeLock unlock];
                return;
            }
            
            for (int i = 0; i < computation; i++) {
                self.computeResult = self.computeResult + 1;
            }
            [_computeLock unlock];
            
            [NSThread sleepForTimeInterval:1.0f];
            
            @synchronized(_computeID) {
                _computeTasks--;
                if (_computeTasks == 0) {
                    self.isFinished = YES;
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}
@end
