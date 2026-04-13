/*
 Copyright (c) 2012, OpenEmu Team
 
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

#import "OEPSXSystemResponder.h"
#import "OEPSXSystemResponderClient.h"

#import <Foundation/Foundation.h>

@protocol OELibretroInputReceiver <NSObject>
- (void)receiveLibretroButton:(uint8_t)button forPort:(NSUInteger)port pressed:(BOOL)pressed;
- (void)receiveLibretroAnalogIndex:(uint8_t)index axis:(uint8_t)axis value:(int16_t)value forPort:(NSUInteger)port;
@end





@implementation OEPSXSystemResponder
static const uint8_t kPSXLibretroMap[] = { 4, 5, 6, 7, 9, 8, 0, 1, 10, 12, 14, 11, 13, 15, 3, 2, 0xFF };

@dynamic client;

+ (Protocol *)gameSystemResponderClientProtocol;
{
    return @protocol(OEPSXSystemResponderClient);
}

- (void)changeAnalogEmulatorKey:(OESystemKey *)aKey value:(CGFloat)value
{
    NSUInteger k = aKey.key;
    id client = (id)self.client;
    if ([client conformsToProtocol:@protocol(OELibretroInputReceiver)]) {
        int16_t val = (int16_t)round(value * 32767.0);
        switch (aKey.key) {
            case OEPSXLeftAnalogUp:    [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:0 axis:1 value:-val forPort:aKey.player]; break;
            case OEPSXLeftAnalogDown:  [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:0 axis:1 value:val  forPort:aKey.player]; break;
            case OEPSXLeftAnalogLeft:  [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:0 axis:0 value:-val forPort:aKey.player]; break;
            case OEPSXLeftAnalogRight: [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:0 axis:0 value:val  forPort:aKey.player]; break;
            case OEPSXRightAnalogUp:   [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:1 axis:1 value:-val forPort:aKey.player]; break;
            case OEPSXRightAnalogDown: [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:1 axis:1 value:val  forPort:aKey.player]; break;
            case OEPSXRightAnalogLeft: [(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:1 axis:0 value:-val forPort:aKey.player]; break;
            case OEPSXRightAnalogRight:[(id<OELibretroInputReceiver>)client receiveLibretroAnalogIndex:1 axis:0 value:val  forPort:aKey.player]; break;
        }
        return;
    }
    [client didMovePSXJoystickDirection:(OEPSXButton)aKey.key withValue:value forPlayer:aKey.player];
}

- (void)pressEmulatorKey:(OESystemKey *)aKey
{
    id client = (id)self.client;
    NSUInteger k = aKey.key;
    if ([client respondsToSelector:@selector(receiveLibretroButton:forPort:pressed:)]) {
        uint8_t btn = (k < sizeof(kPSXLibretroMap)) ? kPSXLibretroMap[k] : 0xFF;
        [(id<OELibretroInputReceiver>)client receiveLibretroButton:btn forPort:aKey.player pressed:YES];
        return;
    }
    [(id<OEPSXSystemResponderClient>)client didPushPSXButton:(OEPSXButton)k forPlayer:aKey.player];
}

- (void)releaseEmulatorKey:(OESystemKey *)aKey
{
    id client = (id)self.client;
    NSUInteger k = aKey.key;
    if ([client respondsToSelector:@selector(receiveLibretroButton:forPort:pressed:)]) {
        uint8_t btn = (k < sizeof(kPSXLibretroMap)) ? kPSXLibretroMap[k] : 0xFF;
        [(id<OELibretroInputReceiver>)client receiveLibretroButton:btn forPort:aKey.player pressed:NO];
        return;
    }
    [(id<OEPSXSystemResponderClient>)client didReleasePSXButton:(OEPSXButton)k forPlayer:aKey.player];
}

- (void)mouseMovedAtPoint:(OEIntPoint)aPoint
{
    if ([self.client respondsToSelector:@selector(mouseMovedAtPoint:)]) {
        [self.client mouseMovedAtPoint:aPoint];
    }
}

- (void)mouseDownAtPoint:(OEIntPoint)aPoint
{
    [self.client leftMouseDownAtPoint:aPoint];
}

- (void)mouseUpAtPoint
{
    [self.client leftMouseUp];
}

- (void)rightMouseDownAtPoint:(OEIntPoint)aPoint
{
    [self.client rightMouseDownAtPoint:aPoint];
}

- (void)rightMouseUpAtPoint
{
    [self.client rightMouseUp];
}

@end
