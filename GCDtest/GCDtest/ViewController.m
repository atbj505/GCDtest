//
//  ViewController.m
//  GCDtest
//
//  Created by Robert on 15/3/13.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ViewController.h"
#import "ConcurrentProcessor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self addGcd];
    //[self myQueue];
    //[self globalQueue];
    //[self lock];
    [self currentProcessor];
}

- (void)addGcd {
    //  后台执行：
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // something
    });
    
    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
    });
    
    // 一次性执行：
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once
    });
    
    // 延迟2秒执行：
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // code to be executed on the main queue after delay
    });
    
    // 自定义dispatch_queue_t
    dispatch_queue_t urls_queue = dispatch_queue_create("blog.devtang.com", NULL);
    dispatch_async(urls_queue, ^{
        // your code
    });
    
    // 合并汇总结果
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程一
    });
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程二
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
        // 汇总结果
    });
}

- (void)myQueue {
    dispatch_queue_t myqueue = dispatch_queue_create("myQueue", NULL);
    dispatch_async(myqueue, ^{
        NSLog(@"1");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"2");
    });
    dispatch_async(myqueue, ^{
        NSLog(@"3");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"4");
    });
}

- (void)globalQueue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"2");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"3");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"4");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"5");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"6");
    });
}

- (void)lock {
    __block int a = 0;
    dispatch_queue_t myqueue1 = dispatch_queue_create("myqueue1", NULL);
    dispatch_queue_t myqueue2 = dispatch_queue_create("myqueue2", NULL);
    
    dispatch_async(myqueue1, ^{
        @synchronized(self) {
            for (int i = 0; i < 10; i++) {
                a++;
                NSLog(@"%d",a);
            }
        }
    });
    
    dispatch_async(myqueue2, ^{
        @synchronized(self) {
            for (int i = 0; i < 10; i++) {
                a--;
                NSLog(@"%d",a);
            }
        }
    });
}

- (void)currentProcessor {
    ConcurrentProcessor *processor = [[ConcurrentProcessor alloc] init];
    
    [processor performSelectorInBackground:@selector(computeTask:) withObject:@5];
    [processor performSelectorInBackground:@selector(computeTask:) withObject:@10];
    [processor performSelectorInBackground:@selector(computeTask:) withObject:@15];
    
    while (!processor.isFinished) {
        NSLog(@"%d",processor.computeResult);
    }
}
@end
