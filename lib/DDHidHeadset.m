/*
 * Copyright (c) 2016 STARFACE GmbH
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "DDHidHeadset.h"
#import "NSXReturnThrowError.h"

@interface DDHidHeadset ()

@property NSMutableArray *pressElements;

@end

@implementation DDHidHeadset

+ (NSArray *)allHeadsets
{
    return [self allDevicesMatchingUsagePage:kHIDPage_Telephony
                                     usageId:kHIDUsage_Tfon_Headset
                                   withClass:self
                           skipZeroLocations:NO];
}

- (instancetype)initWithDevice:(io_object_t)device error:(NSError **)error_
{
    self = [super initWithDevice:device error:error_];
    if (self == nil) {
        return nil;
    }
    
    self.pressElements = [NSMutableArray array];
    [self initPressElements: [self elements]];
    
    return self;
}

- (void)setValue:(int32_t)value forElement:(DDHidElement *)element
{
    if (!element) {
        return;
    }
    
    IOHIDEventStruct event;
    
    event.type = kIOHIDElementTypeOutput;
    event.elementCookie = element.cookie;
    
    event.value = value;
    
    event.timestamp.hi = 0;
    event.timestamp.lo = 0;
    event.longValueSize = 0;
    event.longValue = NULL;
    
    NSXThrowError((*self.deviceInterface)->setElementValue(self.deviceInterface, element.cookie, &event, 0, 0, 0, 0));
}

- (void)initPressElements:(NSArray *)elements
{
    for (DDHidElement *element in elements) {
        if (element.usage.usagePage == kHIDPage_Telephony) {
            [self.pressElements addObject:element];
        }
        
        [self initPressElements:element.elements];
    }
}

- (void)addElementsToQueue:(DDHidQueue *)queue
{
    [queue addElements:self.pressElements];
}

- (void)addElementsToDefaultQueue
{
    [self addElementsToQueue:mDefaultQueue];
}

- (void)ddhidQueueHasEvents:(DDHidQueue *)hidQueue
{
    DDHidEvent * event;
    while ((event = [hidQueue nextEvent])) {
        DDHidElement * element = [self elementForCookie: [event elementCookie]];
        unsigned usageId = [[element usage] usageId];
        SInt32 value = [event value];
        
        id<DDHidHeadsetDelegate> delegate = self.delegate;
        
        if (delegate && [delegate respondsToSelector:@selector(ddhidHeadset:press:upOrDown:)]) {
            [delegate ddhidHeadset:self press:usageId upOrDown:value==1];
        }
    }
}

@end
