//
//  TGToggler.m
//  TGToggler
//
//  Created by Miles Alden on 12/17/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import "TGToggler.h"
#import "TGConstants.h"
#import "TGClickView.h"
#import "TGMenuManager.h"
#import "TGUpdater.h"

static TGToggler *toggler = nil;

@implementation TGToggler

- (void)launch {
    NSLog(@"Launching Toggler_v%@", updater.ver);
}

+ (TGToggler *)toggler {
    
    if ( nil == toggler ) {
        toggler = [[TGToggler alloc] init];
        return toggler;
    }
    
    return toggler;
}

- (id)init {
    
    NSLog(@"MARK");
    // Insert code here to initialize your application
    if ( self = [super init] ) {
        self.on = 0;
        self.pid = 0;
        [self setup];
    }
 
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (toggler == nil) {
            toggler = [super allocWithZone:zone];
            return toggler;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
    
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (void)setup {
    
    if ( nil == menuManager ) {
        menuManager = [[TGMenuManager alloc] init];
    }
    if ( nil == updater ) {
        updater = [[TGUpdater alloc] init];
    }
    

    [self buildStatusBarIcon];
    [self buildMenu];
    [updater checkForUpdate];

}


- (void)buildStatusBarIcon {
    
    self.item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self setDefaultsWithState:0
                         imgOn:@"toggle_On"
                        imgOff:@"toggle_Off"
                        target:menuManager
                        action:@selector(onClick:)
                   rightAction:@selector(showMenu:)];
    
}


- (void)setDefaultsWithState:(int)startsOn
                       imgOn:(NSString *)imgOn
                      imgOff:(NSString *)imgOff
                      target:(id)tgt
                      action:(SEL)sel
                 rightAction:(SEL)rightSel {
    
    [self.item setEnabled:1];
    [self.item setView:[self buildClickView:startsOn imgOn:imgOn imgOff:imgOff target:tgt action:sel rightAction:rightSel]];
    
}

- (TGClickView *)buildClickView:(int)startsOn
                          imgOn:(NSString *)imgOn
                         imgOff:(NSString *)imgOff
                         target:(id)tgt
                         action:(SEL)sel
                    rightAction:(SEL)rightSel {
    
    // Build basic view
    TGClickView *itemView = [[TGClickView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, 20, 20))];
    
    // NULL check and defaults
    itemView.target =       (_assert(tgt))  ? tgt : _default(@"target");
    itemView.action =       (_assertP(sel)) ? sel : NSSelectorFromString(_default(@"sel"));
    itemView.rightAction =  (_assertP(rightSel)) ? rightSel : NSSelectorFromString(_default(@"rightsel"));
    
    // Set image
    NSImage *img_ = ( startsOn ) ? _default(@"altimage") : _default(@"image");
    img_.size = itemView.frame.size;
    itemView.image = img_;

    // Give it away now...
    return itemView;
}

- (id)getDefault:(NSString *)itemName {
    
    // Just defaults
    
    if ( [[itemName lowercaseString] isEqualToString:@"title"] )    { return NSLocalizedString(@"Toggle", nil); }
    if ( [[itemName lowercaseString] isEqualToString:@"image"] )    { return [NSImage imageNamed:@"toggle_Off"]; }
    if ( [[itemName lowercaseString] isEqualToString:@"altimage"] ) { return [NSImage imageNamed:@"toggle_On"]; }
    if ( [[itemName lowercaseString] isEqualToString:@"highlight"] ){ return @""; }
    if ( [[itemName lowercaseString] isEqualToString:@"target"] )   { return menuManager; }
    if ( [[itemName lowercaseString] isEqualToString:@"sel"] )      { return @"onClick:"; }
    if ( [[itemName lowercaseString] isEqualToString:@"rightsel"] ) { return @"showMenu:"; }
    
    return nil;
}



- (void)buildMenu {
    
    if ( !self.item.menu )
        [self.item setMenu:menuManager.theMenu];
}


- (void)updateImage:(NSString *)newImage {
    
    [(TGClickView *)[self.item view] setImage:_default(newImage)];
    [(TGClickView *)[self.item view] setNeedsDisplay:1];
    
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
    if ( self.pid > 0 ) {
        NSLog(@"Killing pid %d", self.pid);
        system("pkill -9 ScreenSaverEngine");
    }
    
}





@end
