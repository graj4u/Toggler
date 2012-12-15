//
//  TGAppDelegate.h
//  Toggler
//
//  Created by Miles Alden on 12/15/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TGAppDelegate : NSObject <NSApplicationDelegate> {
    BOOL on;
    int pid;
}

@property (assign) IBOutlet NSWindow *window;
@property (strong) NSStatusItem *item;

@end
