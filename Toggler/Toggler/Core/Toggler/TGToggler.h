//
//  TGToggler.h
//  TGToggler
//
//  Created by Miles Alden on 12/17/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGUpdater.h"

@class TGClickView, TGMenuManager;

@interface TGToggler : NSObject {

    TGMenuManager *menuManager;

    
}

@property BOOL on;
@property int pid;
@property (strong) NSStatusItem *item;
@property (strong) TGUpdater *updater;

+ (TGToggler *)toggler;
- (void)launch;
- (void)setup;

- (void)updateImage:(NSString *)newImage;
- (id)getDefault:(NSString *)itemName;
- (void)launchScreenSaver;
- (void)killScreenSaver;

- (TGClickView *)buildClickView:(int)startsOn
                          imgOn:(NSString *)imgOn
                         imgOff:(NSString *)imgOff
                         target:(id)tgt
                         action:(SEL)sel
                    rightAction:(SEL)sel;


@end
