#import <IOKit/IOKitLib.h>
#import <Foundation/Foundation.h>


@interface IdleSensor : NSObject
    +(CFTimeInterval) CFDateGetIdleTimeInterval;
@end
