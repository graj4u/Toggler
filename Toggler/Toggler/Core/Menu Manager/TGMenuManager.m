//
//  TGMenuCallbacks.m
//  TGToggler
//
//  Created by Miles Alden on 12/17/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import "TGMenuManager.h"
#import "TGConstants.h"
#import "NSWindow+TGWindowAdditions.h"

@implementation TGMenuManager

- (id)init {
    
    if ( self = [super init] ) {
        [self loadMenu];
    }
    
    return self;
}

NSString *aboutMessage() {
    
    return [NSString stringWithFormat:@"\n\n"\
            @"TGToggler v%@\n"\
            @"By Miles Alden\n"\
            @"============\n"\
            @"A simple tool for animating\n"\
            @"your wallpaper with a screensaver\n"\
            @"of your choice.\n"\
            @"It's really nothing fancy. ;-)\n"\
            @"\n"\
            @"www.milesalden.com",\
            [[[TGToggler toggler] updater] ver]];
}

- (void)onClick:(id)sender {
    
    // Try-catch in case the pkill gets the wrong
    // pid... I think it had -1 originally, which
    // actually kills all current user processes.
    // eeek!
    @try {
        [TGToggler toggler].on = ( ![TGToggler toggler].on );
        if ( [TGToggler toggler].on ) {
            [[TGToggler toggler] updateImage:@"altimage"];
            [[TGToggler toggler] launchScreenSaver];
            
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
            [TGToggler toggler].pid = [pidStr intValue];
            
            
        } else {
            [[TGToggler toggler] updateImage:@"image"];
            [[TGToggler toggler] killScreenSaver];
        }
    }
    @catch (NSException *e) {
        NSLog(@"**ERROR** %@", e);
        exit(1);
    }
    
    
}


- (void)loadMenu {

    self.theMenu = [self buildMenuParts];
}

- (NSMenu *)buildMenuParts {
    
    NSMenu *menu = [[NSMenu alloc] init];
    NSMenuItem *about = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"About Toggler", NSZeroString) action:@selector(showAbout:) keyEquivalent:NSZeroString];
    NSMenuItem *change = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Change Screen Saver", NSZeroString) action:@selector(changeScreenSaver:) keyEquivalent:NSZeroString];
    NSMenuItem *quit = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Quit", NSZeroString) action:@selector(terminate:) keyEquivalent:NSZeroString];
    NSMenuItem *sep = [NSMenuItem separatorItem];
    NSArray *items = @[about,sep,change,quit];

    for ( NSMenuItem *item in items ) {
        [menu addItem:item];
        [item setEnabled:YES];
    }
    
    [about setTarget:self];
    [change setTarget:self];
    
    
    return menu;
}

- (void)showMenu: (id)sender {
    [[TGToggler toggler].item popUpStatusItemMenu:self.theMenu];
}

- (void)loadAboutWindow {
    
    if ( nil != [wCon window] ) {
        [wCon showWindow:self];
        [[wCon window] makeKeyAndOrderFront:self];
        return;
    }
    
    __autoreleasing NSMutableArray *array = [NSMutableArray array];
    __autoreleasing NSMutableArray **arr = &array;
    
    [[NSBundle mainBundle] loadNibNamed:@"AboutMenu" owner:self topLevelObjects:arr];
    if ( nil == array ) {
        NSLog(@"**ERROR** Couldn't initialize about window.");
        return;
    }
    
    NSPanel *panel;
    for ( id obj in array ) {
        if ( [obj isKindOfClass:[NSPanel class]] ) {
            panel = obj;
        }
    }
    
    wCon = [[NSWindowController alloc] initWithWindow:panel];
    NSTextFieldCell *label = [[[[panel contentView] subviews] objectAtIndex:0] cell];
    [label setTitle:aboutMessage()];
    
    
    [wCon showWindow:self];
    [[wCon window] makeKeyAndOrderFront:self];
    
}





- (IBAction)showAbout:(id)sender {
    
    if ( nil == wCon ) {
        
        [self loadAboutWindow];
        
    } else {
        
        [self loadAboutWindow];
    }
    
    NSLog(@"%@", aboutMessage());
}

- (IBAction)changeScreenSaver:(id)sender {
    
    // Just basic panel
    [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:kDisplaysPanePath]];
    
}



@end
