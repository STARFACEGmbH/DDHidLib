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

#import "HeadsetPaneController.h"

@interface HeadsetPaneController ()

@property NSArray<DDHidHeadset *> *headsets;
@property (nonatomic) NSUInteger headsetIndex;

@property NSMutableArray<DDHidEvent *> *events;

@property (weak) DDHidHeadset *currentHeadset;

@property (weak) IBOutlet NSArrayController *headsetsArrayController;
@property (weak) IBOutlet NSArrayController *headsetEventsArrayController;

@end

@implementation HeadsetPaneController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.events = [@[] mutableCopy];
    }
    return self;
}

- (void)awakeFromNib
{
    self.headsets = [DDHidHeadset allHeadsets];
    [self.headsets makeObjectsPerformSelector:@selector(setDelegate:) withObject:self];
    
    if (self.headsets.count > 0) {
        self.headsetIndex = 0;
    }
    else {
        self.headsetIndex = NSNotFound;
    }
}

- (void)setHeadsetIndex:(NSUInteger)headsetIndex
{
    if (self.currentHeadset) {
        [self.currentHeadset stopListening];
        self.currentHeadset = nil;
    }
    
    _headsetIndex = headsetIndex;
    
    self.headsetsArrayController.selectionIndex = headsetIndex;
    
    self.events = [@[] mutableCopy];
 
    if (self.currentHeadset) {
        [self.currentHeadset stopListening];
    }
    
    if (self.headsetIndex != NSNotFound) {
        self.currentHeadset = self.headsets[headsetIndex];
        [self.currentHeadset startListening];
    }
}

- (void)ddhidHeadset:(DDHidHeadset *)headset press:(unsigned int)usageId upOrDown:(BOOL)upOrDown
{
    NSString *usage = nil;
    
    switch (usageId) {
        case kHIDUsage_Tfon_ProgrammableButton:
            usage = @"Programmable Button";
            break;
            
        case kHIDUsage_Tfon_HookSwitch:
            usage = @"Hook Switch";
            break;
            
        case kHIDUsage_Tfon_Flash:
            usage = @"Flash";
            break;
            
        case kHIDUsage_Tfon_Feature:
            usage = @"Feature";
            break;
            
        case kHIDUsage_Tfon_Hold:
            usage = @"Hold";
            break;
            
        case kHIDUsage_Tfon_Redial:
            usage = @"Redial";
            break;
            
        case kHIDUsage_Tfon_Transfer:
            usage = @"Transfer";
            break;
            
        case kHIDUsage_Tfon_Drop:
            usage = @"Drop";
            break;
            
        case kHIDUsage_Tfon_Park:
            usage = @"Park";
            break;
            
        case kHIDUsage_Tfon_ForwardCalls:
            usage = @"Forward Calls";
            break;
            
        case kHIDUsage_Tfon_AlternateFunction:
            usage = @"Alternate Function";
            break;
            
        case kHIDUsage_Tfon_Line:
            usage = @"Line";
            break;
            
        case kHIDUsage_Tfon_SpeakerPhone:
            usage = @"Speaker Phone";
            break;
            
        case kHIDUsage_Tfon_Conference:
            usage = @"Conference";
            break;
            
        case kHIDUsage_Tfon_RingEnable:
            usage = @"Ring Enable";
            break;
            
        case kHIDUsage_Tfon_PhoneMute:
            usage = @"Phone Mute";
            break;
            
        case kHIDUsage_Tfon_CallerID:
            usage = @"Caller ID";
            break;
            
        case kHIDUsage_Tfon_SpeedDial:
            usage = @"Speed Dial";
            break;
            
        case kHIDUsage_Tfon_StoreNumber:
            usage = @"Store Number";
            break;
            
        case kHIDUsage_Tfon_RecallNumber:
            usage = @"Recall Number";
            break;
            
        case kHIDUsage_Tfon_PhoneDirectory:
            usage = @"Phone Directory";
            break;
            
        case kHIDUsage_Tfon_VoiceMail:
            usage = @"Voice Mail";
            break;
            
        case kHIDUsage_Tfon_ScreenCalls:
            usage = @"Screen Calls";
            break;
            
        case kHIDUsage_Tfon_DoNotDisturb:
            usage = @"Do Not Disturb";
            break;
            
        case kHIDUsage_Tfon_Message:
            usage = @"Message";
            break;
            
        case kHIDUsage_Tfon_AnswerOnOrOff:
            usage = @"Answer On or Of";
            break;
            
        case kHIDUsage_Tfon_InsideDialTone:
            usage = @"Inside Dial Tone";
            break;
            
        case kHIDUsage_Tfon_OutsideDialTone:
            usage = @"Outside Dial Tone";
            break;

        case kHIDUsage_Tfon_InsideRingTone:
            usage = @"Inside Ring Tone";
            break;
            
        case kHIDUsage_Tfon_OutsideRingTone:
            usage = @"Outside Ring Tone";
            break;
            
        case kHIDUsage_Tfon_PriorityRingTone:
            usage = @"Priority Ring Tone";
            break;
            
        case kHIDUsage_Tfon_InsideRingback:
            usage = @"Inside Ringback";
            break;
            
        case kHIDUsage_Tfon_PriorityRingback:
            usage = @"Priority Ringback";
            break;
            
        case kHIDUsage_Tfon_LineBusyTone:
            usage = @"Line Busy Tone";
            break;
        
        case kHIDUsage_Tfon_ReorderTone:
            usage = @"Recorder Tone";
            break;
            
        case kHIDUsage_Tfon_CallWaitingTone:
            usage = @"Call Waiting Tone";
            break;
            
        case kHIDUsage_Tfon_ConfirmationTone1:
            usage = @"Confirmation Tone 1";
            break;
            
        case kHIDUsage_Tfon_ConfirmationTone2:
            usage = @"Confirmation Tone 2";
            break;
            
        case kHIDUsage_Tfon_TonesOff:
            usage = @"Tones Off";
            break;
            
        case kHIDUsage_Tfon_OutsideRingback:
            usage = @"Outside Ringback";
            break;
            
        case kHIDUsage_Tfon_PhoneKey0:
        case kHIDUsage_Tfon_PhoneKey1:
        case kHIDUsage_Tfon_PhoneKey2:
        case kHIDUsage_Tfon_PhoneKey3:
        case kHIDUsage_Tfon_PhoneKey4:
        case kHIDUsage_Tfon_PhoneKey5:
        case kHIDUsage_Tfon_PhoneKey6:
        case kHIDUsage_Tfon_PhoneKey7:
        case kHIDUsage_Tfon_PhoneKey8:
        case kHIDUsage_Tfon_PhoneKey9:
            usage = [NSString stringWithFormat:@"%d", usageId - kHIDUsage_Tfon_PhoneKey0];
            break;
            
        case kHIDUsage_Tfon_PhoneKeyStar:
            usage = @"*";
            break;
            
        case kHIDUsage_Tfon_PhoneKeyPound:
            usage = @"#";
            break;
            
        case kHIDUsage_Tfon_PhoneKeyA:
            usage = @"A";
            break;
            
        case kHIDUsage_Tfon_PhoneKeyB:
            usage = @"B";
            break;
            
        case kHIDUsage_Tfon_PhoneKeyC:
            usage = @"C";
            break;
            
        case kHIDUsage_Tfon_PhoneKeyD:
            usage = @"D";
            break;
            
        default:
            break;
    }
    
    if (usage) {
        usage = [usage stringByAppendingString:[NSString stringWithFormat:@" (0x%02X)", usageId]];
    }
    else {
        usage = [NSString stringWithFormat:@"0x%02X", usageId];
    }
    
    NSDictionary *row = @{@"event": upOrDown ? @"Down" : @"Up",
                          @"description": usage};
    
    [self.headsetEventsArrayController addObject:row];
}

@end
