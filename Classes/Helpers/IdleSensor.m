#import "IdleSensor.h"

@implementation IdleSensor
+(CFTimeInterval) CFDateGetIdleTimeInterval {
    mach_port_t port;
    io_iterator_t iter;
    CFTypeRef value = kCFNull;
    uint64_t idle = 0;
    CFMutableDictionaryRef properties = NULL;
    io_registry_entry_t entry;

    IOMasterPort(MACH_PORT_NULL, &port);
    IOServiceGetMatchingServices(port, IOServiceMatching("IOHIDSystem"), &iter);
    if (iter) {
        if ((entry = IOIteratorNext(iter))) {
            if (IORegistryEntryCreateCFProperties(entry, &properties, kCFAllocatorDefault, 0) == KERN_SUCCESS && properties) {
                if (CFDictionaryGetValueIfPresent(properties, CFSTR("HIDIdleTime"), &value)) {
                    if (CFGetTypeID(value) == CFDataGetTypeID()) {
                        CFDataGetBytes(value, CFRangeMake(0, sizeof(idle)), (UInt8 *) &idle);
                    } else if (CFGetTypeID(value) == CFNumberGetTypeID()) {
                        CFNumberGetValue(value, kCFNumberSInt64Type, &idle);
                    }
                }
                CFRelease(properties);
            }
            IOObjectRelease(entry);
        }
        IOObjectRelease(iter);
    }

    return idle / 1000000000.0;
}
@end