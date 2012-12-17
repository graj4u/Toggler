//
//  TGAppDelegate.m
//  TGToggler
//
//  Created by Miles Alden on 12/15/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import "TGAppDelegate.h"
#import "TGToggler.h"

@implementation TGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    
    [[TGToggler toggler] launch];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    
    [[TGToggler toggler] killScreenSaver];
    
}

@end
