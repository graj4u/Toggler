//
//  TGAppDelegate.m
//  Toggler
//
//  Created by Miles Alden on 12/15/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import "TGAppDelegate.h"
#import "TGClickView.h"


#define _assert(x) (nil != x)
#define _assertP(x) (&x != NULL)
#define _default(x) [self getDefault:(x)]
#define kDisplaysPanePath @"/System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane"


#define DB_URL @"http://localhost/toggler/currentVersion/"
#define REL_URL @"https://google.com/"
#define UPDATE_URL ( DEBUG ) ? DB_URL : REL_URL



@implementation TGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    on = 0;
    pid = 0;
    [self buildStatusBarIcon];
    [self buildMenu];
    [self checkForUpdate];
    
}

- (void)buildStatusBarIcon {
    
    self.item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self setDefaultsWithState:0 imageNamed:@"toggle_Off" altImageName:@"toggle_Off" title:@"Toggle" target:self action:@selector(onClick:)];
    
}


// TODO: Fix me
- (void)setDefaultsWithState:(int)startingState
                  imageNamed:(NSString *)img
                altImageName:(NSString *)altImg
                       title:(NSString *)localStringKey
                      target:(id)tgt
                      action:(SEL)sel {
    
    [self.item setEnabled:1];
    TGClickView *itemView = [[TGClickView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, 20, 20))];
    itemView.target = self;
    itemView.action = @selector(onClick:);
    itemView.rightAction = @selector(showMenu:);
    
    NSImage *img_ = _default(@"image");
    img_.size = itemView.frame.size;
//    self.item.image = img_;
    
    itemView.image = [NSImage imageNamed:img];
    [self.item setView:itemView];
    
    
    
//    if ( !_assertP(startingState) ) { startingState = !(_default(@"highlight")); }
//    [self.item setHighlightMode:startingState];
//    
//    if ( !_assert(tgt) ) { tgt = _default(@"target"); }
//    [self.item setTarget:tgt];
//    
//    if ( !_assert(sel) ) { sel = NSSelectorFromString(_default(@"sel")); }
//    [self.item setAction:sel];
    
   
}

- (id)getDefault:(NSString *)itemName {
    
    if ( [[itemName lowercaseString] isEqualToString:@"title"] ) { return NSLocalizedString(@"Toggle", nil); }
    if ( [[itemName lowercaseString] isEqualToString:@"image"] ) { return [NSImage imageNamed:@"toggle_Off"]; }
    if ( [[itemName lowercaseString] isEqualToString:@"altimage"] ) { return [NSImage imageNamed:@"toggle_On"]; }
    if ( [[itemName lowercaseString] isEqualToString:@"highlight"] ) { return @""; }
    if ( [[itemName lowercaseString] isEqualToString:@"target"] ) { return self; }
    if ( [[itemName lowercaseString] isEqualToString:@"sel"] ) { return @"onClick:"; }
    
    return nil;
}

- (void)onClick:(id)sender {
        
    // Try-catch in case the pkill gets the wrong
    // pid... I think it had -1 originally, which
    // actually kills all current user processes.
    // eeek!
    @try {
        on = ( !on );
        if ( on ) {
            [self.item setImage:[self getDefault:@"altimage"]];
            [self launchScreenSaver];
            
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
            [self.item setImage:[self getDefault:@"image"]];
            [self killScreenSaver];
        }
    }
    @catch (NSException *e) {
        NSLog(@"**ERROR** %@", e);
        exit(1);
    }
 
    
}

- (void)showMenu: (id)sender {
    [self.item popUpStatusItemMenu:self.item.menu];
}


- (void)buildMenu {

    if ( !self.item.menu )
        [self.item setMenu:theMenu];
}

- (void)checkForUpdate {
    
    // Build command
    char cmd[640] = { "\x0" };
    const char *outputPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask,
                                                                  YES) objectAtIndex:0]
                             cStringUsingEncoding:NSASCIIStringEncoding];
    
    snprintf(cmd, sizeof(cmd), "curl -o %s/ver.html %s", outputPath, [UPDATE_URL cStringUsingEncoding:NSASCIIStringEncoding]);
    
    // execute
    FILE *filePtr = popen(cmd, "r");
    char response[320] = { "\x0" };
    
    // Return response
    fgets(response, sizeof(response), filePtr);
    NSString *currVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSError *err;
    NSString *updatedVer = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%s/ver.html", outputPath] encoding:NSUTF8StringEncoding error:&err];
    
    NSLog(@"\n\n"
          @"Last updated version: %@\n"
          @"This app's version: %@", updatedVer, currVer);
    
    if ( ![updatedVer isEqualToString:currVer] ) {
        NSLog(@"\n\nAn update is available!\n"
              @"Update now?\n"
              @"=============\n"
              @"Automatically update in the future?\n");
    }

}


- (void)launchScreenSaver {
    
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

}

- (void)killScreenSaver {
    
    NSLog(@"Turning off screen saver...");
    if ( pid > 0 ) {
        NSLog(@"Killing pid %d", pid);
        system("pkill -9 ScreenSaverEngine");
    }

}


- (void)loadAboutWindow {
    
    wCon = [[NSWindowController alloc] initWithWindowNibName:@"AboutMenu" owner:self];
    [[wCon window] setOneShot:1];
    [wCon showWindow:self];

}

- (IBAction)showAbout:(id)sender {
    
    if ( nil == wCon ) {
        
        [self loadAboutWindow];
    } else {
        
        [wCon close];
        wCon = nil;
        [self loadAboutWindow];
    }
    
//    NSLog(@"\n\n"
//          @"Toggler\n"
//          @"By Miles Alden\n"
//          @"============\n"
//          @"A simple tool for animating\n"
//          @"your wallpaper with a screensaver\n"
//          @"of your choice.\n"
//          @"It's really nothing fancy. ;-)\n"
//          @"\n"
//          @"www.milesalden.com" );
    
    
}


- (IBAction)changeScreenSaver:(id)sender {

    // Just basic panel
    [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:kDisplaysPanePath]];
     
}


- (void)applicationWillTerminate:(NSNotification *)notification {
    
    [self killScreenSaver];
    
}

@end
