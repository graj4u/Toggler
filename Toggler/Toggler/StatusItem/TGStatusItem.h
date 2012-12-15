//
//  TGStatusItem.h
//  Toggler
//
//  Created by Miles Alden on 12/15/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TGStatusItem : NSStatusItem

@property int on;

- (void)setDefaultsWithState:(int)startingState imageNamed:(NSString *)img altImageName:(NSString *)altImg title:(NSString *)localStringKey target:(id)tgtb action:(SEL)sel;


@end
