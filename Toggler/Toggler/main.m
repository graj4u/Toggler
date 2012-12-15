//
//  main.m
//  Toggler
//
//  Created by Miles Alden on 12/15/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TGAppDelegate.h"


int main(int argc, char *argv[])
{
    NSString *str = NSStringFromClass([TGAppDelegate class]);
    char *s = [str cStringUsingEncoding:NSUTF8StringEncoding];
    
    argv[1] = { ;
    return NSApplicationMain(argc, (const char **)argv);
}
