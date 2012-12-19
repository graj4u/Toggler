//
//  NSWindow+TGWindowAdditions.m
//  Toggler
//
//  Created by Miles Alden on 12/18/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import "NSWindow+TGWindowAdditions.h"

@implementation NSWindow (TGWindowAdditions)


- (id)findCell:(NSCell **)cell {
    
    NSCell *ret = *cell;
    
    if ( !self.contentView ) {
        return ret;
    }
    
    NSArray *subs = [self.contentView subviews];
    if ( !subs ) {
        return ret;
    }
    
    for ( NSView *view in subs ) {
        if ( [view respondsToSelector:@selector(cell)] ) {
            *cell = [view performSelector:@selector(cell)];
            return [self findCell:cell];
        }
    }
    
    
    // Window
    // Has content view
    // has class
    // has subviews
    //   has class

    return ret;
}

@end
