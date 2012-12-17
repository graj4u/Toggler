//
//  TGMenuCallbacks.h
//  TGToggler
//
//  Created by Miles Alden on 12/17/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGToggler.h"


@interface TGMenuManager : NSObject {
    
    TGToggler *tog;
    NSWindowController *wCon;

}

@property IBOutlet NSMenu *theMenu;

- (void)onClick:(id)sender;
- (void)showMenu: (id)sender;
- (IBAction)showAbout:(id)sender;
- (IBAction)changeScreenSaver:(id)sender;

@end
