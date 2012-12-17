//
//  TGToggler.h
//  TGToggler
//
//  Created by Miles Alden on 12/17/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TGClickView, TGMenuManager, TGUpdater;

@interface TGToggler : NSObject {

    TGMenuManager *menuManager;
    TGUpdater *updater;
    
}

@property BOOL on;
@property int pid;
@property (strong) NSStatusItem *item;

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
