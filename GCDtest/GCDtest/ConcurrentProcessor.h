//
//  ConcurrentProcessor.h
//  GCDtest
//
//  Created by Robert on 15/3/15.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConcurrentProcessor : NSObject


@property (nonatomic, assign) BOOL isFinished;

@property (nonatomic, assign, readonly) NSInteger computeResult;

- (void)computeTask:(id)data;

@end
