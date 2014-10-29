

#import "Util.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@implementation Util

static dispatch_queue_t asDisplayNodeQueue = nil;
+ (dispatch_queue_t)getNodeQueue {
    if (asDisplayNodeQueue == nil) {
        asDisplayNodeQueue = dispatch_queue_create("AsyncNodeQueue", DISPATCH_QUEUE_CONCURRENT);//并行队列
        //        asDisplayNodeQueue = dispatch_queue_create("AsyncNodeQueue", DISPATCH_QUEUE_SERIAL);//穿行队列
    }
    return asDisplayNodeQueue;
}

@end
