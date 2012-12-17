//
//  TGUpdater.m
//  TGToggler
//
//  Created by Miles Alden on 12/17/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import "TGUpdater.h"
#import "TGConstants.h"


@implementation TGUpdater


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
    self.ver = currVer;
    NSError *err;
    NSString *updatedVer = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%s/ver.html", outputPath] encoding:NSUTF8StringEncoding error:&err];
    updatedVer = [updatedVer stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSLog(@"\n\n"
          @"Last updated version: %@\n"
          @"This app's version: %@", updatedVer, currVer);
    
    if ( ![updatedVer isEqualToString:currVer] ) {
        NSLog(@"\n\nAn update is available!\n"
              @"Update now?\n"
              @"=============\n"
              @"Automatically update in the future?\n");
    } else {
        NSLog(@"\n\nTGToggler is up to date: %@", currVer);
    }
    
}

@end
