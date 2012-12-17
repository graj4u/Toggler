//
//  TGUpdater.h
//  TGToggler
//
//  Created by Miles Alden on 12/17/12.
//  Copyright (c) 2012 Miles Alden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGUpdater : NSObject

@property (strong) NSString *ver;

- (void)checkForUpdate;

@end
