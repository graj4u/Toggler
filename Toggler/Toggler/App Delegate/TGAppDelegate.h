//
//  TGAppDelegate.h
//  TGToggler
//
//  Created by Miles Alden on 12/15/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TGToggler.h"

@interface TGAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    
}

@property (strong) IBOutlet TGToggler *toggler;
@property (assign) IBOutlet NSWindow *window;

@end
