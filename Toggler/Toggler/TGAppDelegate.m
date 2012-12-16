//
//  TGAppDelegate.m
//  Toggler
//
//  Created by Miles Alden on 12/15/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import "TGAppDelegate.h"


#define _assert(x) (nil != x)
#define _assertP(x) (&x != NULL)
#define _default(x) [self getDefault:(x)]


@implementation TGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    on = 0;
    pid = 0;
    [self buildStatusBarIcon];
    
}

- (void)buildStatusBarIcon {
    
    self.item = [[NSStatusBar systemStatusBar] statusItemWithLength:30];
    [self setDefaultsWithState:0 imageNamed:@"toggle_Off" altImageName:@"toggle_Off" title:@"Toggle" target:self action:@selector(onClick)];
    
}

- (void)setDefaultsWithState:(int)startingState
                  imageNamed:(NSString *)img
                altImageName:(NSString *)altImg
                       title:(NSString *)localStringKey
                      target:(id)tgt
                      action:(SEL)sel {
    
    [self.item setEnabled:1];
    
//    if ( !_assert(localStringKey) ) { localStringKey = _default(@"title"); }
//    [self.item setTitle:NSLocalizedString(localStringKey, nil)];
    
    if ( !_assert(img) ) { img = _default(@"image"); }
    [self.item setImage:[NSImage imageNamed:img]];
    
//    if ( !_assert(altImg) ) { img = _default(@"altImage"); }
//    [self.item setAlternateImage:[NSImage imageNamed:altImg]];
    
    if ( !_assertP(startingState) ) { startingState = !(_default(@"highlight")); }
    [self.item setHighlightMode:startingState];
    
    if ( !_assert(tgt) ) { tgt = _default(@"target"); }
    [self.item setTarget:tgt];
    
    if ( !_assert(sel) ) { sel = NSSelectorFromString(_default(@"sel")); }
    [self.item setAction:sel];
    
}

- (id)getDefault:(NSString *)itemName {
    
    if ( [[itemName lowercaseString] isEqualToString:@"title"] ) { return NSLocalizedString(@"Toggle", nil); }
    if ( [[itemName lowercaseString] isEqualToString:@"image"] ) { return [NSImage imageNamed:@"toggle_Off"]; }
    if ( [[itemName lowercaseString] isEqualToString:@"altimage"] ) { return [NSImage imageNamed:@"toggle_On"]; }
    if ( [[itemName lowercaseString] isEqualToString:@"highlight"] ) { return @""; }
    if ( [[itemName lowercaseString] isEqualToString:@"target"] ) { return self; }
    if ( [[itemName lowercaseString] isEqualToString:@"sel"] ) { return @"onClick"; }
    
    return nil;
}

- (void)onClick {
    
    @try {
        on = ( !on );
        if ( on ) {
            [self.item setImage:[self getDefault:@"altimage"]];
            NSLog(@"Turning on screen saver...");
            // Declare with wider scope
            
            // Run as async queue
            dispatch_queue_t queue = dispatch_queue_create("com.miles.toggle", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue, ^(void) {
                
                char bigCmd[256] = { "\x0" };
                FILE *bigPtr;

                // Build command
                snprintf(bigCmd, sizeof(bigCmd), "/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background");
                
                // execute
                bigPtr = popen(bigCmd, "r");

            });
            
//            char responseA[256] = { "\x0" };
//            fgets(responseA, sizeof(responseA), bigPtr);
//            NSLog(@"%s", responseA);

            
            // Build command
            char cmd[24] = { "\x0" };
            snprintf(cmd, sizeof(cmd), "ps -A | grep -i screensaverengine");
            
            // execute
            FILE *filePtr = popen(cmd, "r");
            char response[320] = { "\x0" };
            
            // Return response
            fgets(response, sizeof(response), filePtr);
            NSLog(@"%s", response);
            
            NSString *pidStr = [NSString stringWithCString:response encoding:NSASCIIStringEncoding];
            pid = [pidStr intValue];
            
            
        } else {
            NSLog(@"Turning off screen saver...");
            [self.item setImage:[self getDefault:@"image"]];
            if ( pid > 0 ) {
                NSLog(@"Killing pid %d", pid);
                system("pkill -9 ScreenSaverEngine");
            }
        }
    }
    @catch (NSException *e) {
        NSLog(@"**ERROR** %@", e);
        exit(1);
    }
 
    
}

@end
