//
//  TGClickView.h
//  TGToggler
//
//  Created by Miles Alden on 12/16/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TGClickView : NSView

@property (strong) NSImage *image;
@property (assign) id target;
@property SEL action, rightAction;

@end
