/*
 Copyright (c) 2013, OpenEmu Team
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
     * Neither the name of the OpenEmu Team nor the
       names of its contributors may be used to endorse or promote products
       derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY OpenEmu Team ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL OpenEmu Team BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OEGCSystemResponder.h"
#import "OEGCSystemResponderClient.h"

#import <Foundation/Foundation.h>

@protocol OELibretroInputReceiver <NSObject>
- (void)receiveLibretroButton:(uint8_t)button forPort:(NSUInteger)port pressed:(BOOL)pressed;
- (void)receiveLibretroAnalogIndex:(uint8_t)index axis:(uint8_t)axis value:(int16_t)value forPort:(NSUInteger)port;
@end

@implementation OEGCSystemResponder
static const uint8_t kGCLibretroMap[] = { 4, 5, 6, 7, 10, 8, 9, 11, 0, 1, 13, 12, 3, 2 };

@dynamic client;

+ (Protocol *)gameSystemResponderClientProtocol;
{
    return @protocol(OEGCSystemResponderClient);
}

- (void)changeAnalogEmulatorKey:(OESystemKey *)aKey value:(CGFloat)value
{
    id client = (id)self.client;
    if ([client respondsToSelector:@selector(receiveLibretroAnalogIndex:axis:value:forPort:)]) {
        int16_t val = (int16_t)round(value * 32767.0);
        switch (aKey.key) {
            case OEGCAnalogUp:    [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:0 axis:1 value:-val forPort:aKey.player]; break;
            case OEGCAnalogDown:  [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:0 axis:1 value:val  forPort:aKey.player]; break;
            case OEGCAnalogLeft:  [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:0 axis:0 value:-val forPort:aKey.player]; break;
            case OEGCAnalogRight: [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:0 axis:0 value:val  forPort:aKey.player]; break;
            case OEGCAnalogCUp:   [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:1 axis:1 value:-val forPort:aKey.player]; break;
            case OEGCAnalogCDown: [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:1 axis:1 value:val  forPort:aKey.player]; break;
            case OEGCAnalogCLeft: [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:1 axis:0 value:-val forPort:aKey.player]; break;
            case OEGCAnalogCRight:[(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:1 axis:0 value:val  forPort:aKey.player]; break;
            case OEGCButtonL:         [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:2 axis:0 value:val  forPort:aKey.player]; break;
            case OEGCButtonR:         [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:2 axis:1 value:val  forPort:aKey.player]; break;
        }
        return;
    }
    [(id<OEGCSystemResponderClient>)client didMoveGCJoystickDirection:(OEGCButton)aKey.key withValue:value forPlayer:aKey.player];
}

- (void)pressEmulatorKey:(OESystemKey *)aKey
{
    id client = (id)self.client;
    NSUInteger k = aKey.key;
    if ([client respondsToSelector:@selector(receiveLibretroButton:forPort:pressed:)]) {
        uint8_t btn = (k < sizeof(kGCLibretroMap)) ? kGCLibretroMap[k] : 0xFF;
        [(id<OELibretroInputReceiver>)client receiveLibretroButton:btn forPort:aKey.player pressed:YES];
        return;
    }
    [(id<OEGCSystemResponderClient>)client didPushGCButton:(OEGCButton)k forPlayer:aKey.player];
}

- (void)releaseEmulatorKey:(OESystemKey *)aKey
{
    id client = (id)self.client;
    NSUInteger k = aKey.key;
    if ([client respondsToSelector:@selector(receiveLibretroButton:forPort:pressed:)]) {
        uint8_t btn = (k < sizeof(kGCLibretroMap)) ? kGCLibretroMap[k] : 0xFF;
        [(id<OELibretroInputReceiver>)client receiveLibretroButton:btn forPort:aKey.player pressed:NO];
        return;
    }
    [(id<OEGCSystemResponderClient>)client didReleaseGCButton:(OEGCButton)k forPlayer:aKey.player];
}

@end
