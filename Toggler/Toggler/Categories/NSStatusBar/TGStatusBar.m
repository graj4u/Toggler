//
//  NSStatusBar+Additions.m
//  Toggler
//
//  Created by Miles Alden on 12/15/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import "TGStatusBar.h"
#import "TGStatusItem.h"

@implementation TGStatusBar : NSStatusBar

- (TGStatusItem *)statusItemWithLength:(CGFloat)length {
    TGStatusItem *item = (TGStatusItem *)[super statusItemWithLength:length];
    item = [[TGStatusItem alloc] init];
    [item setDefaultsWithState:1 imageNamed:@"toggle_On" altImageName:@"toggle_Off" title:@"Toggle" target:item action:@selector(onClick)];
    return item;    
}

@end
