//
//  TGClickView.m
//  Toggler
//
//  Created by Miles Alden on 12/16/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import "TGClickView.h"

@implementation TGClickView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)mouseUp:(NSEvent *)event {
    if([event modifierFlags] & NSControlKeyMask) {
        [NSApp sendAction:self.rightAction to:self.target from:self];
    } else {
        [NSApp sendAction:self.action to:self.target from:self];
    }
}
- (void)rightMouseUp:(NSEvent *)event {
    [NSApp sendAction:self.rightAction to:self.target from:self];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [self.image drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

@end
