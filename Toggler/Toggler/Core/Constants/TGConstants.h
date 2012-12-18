//
//  TGConstants.h
//  TGToggler
//
//  Created by Miles Alden on 12/17/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//


#ifndef TGConstants_h
#define TGConstants_h 
#endif

#define NSZeroString @""

#define _assert(x) (nil != x)
#define _assertP(x) (x != NULL)
#define _default(x) [self getDefault:(x)]
#define kDisplaysPanePath @"/System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane"


#define DB_URL @"http://localhost/toggler/currentVersion/"
#define REL_URL @"https://google.com/"
#define UPDATE_URL ( DEBUG ) ? DB_URL : REL_URL

#define kAboutMessage [NSString stringWithFormat:@"\n\n"\
                                                @"TGToggler v%@\n"\
                                                @"By Miles Alden\n"\
                                                @"============\n"\
                                                @"A simple tool for animating\n"\
                                                @"your wallpaper with a screensaver\n"\
                                                @"of your choice.\n"\
                                                @"It's really nothing fancy. ;-)\n"\
                                                @"\n"\
                                                @"www.milesalden.com",\
                                                [[[TGToggler toggler] updater] ver]]
