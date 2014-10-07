//
//  SwarmSDKManager.h
//  SwarmSDKDemo
//
//  Created by Davis Haba on 10/6/14.
//  Copyright (c) 2014 Davis Haba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwarmSDK.h"

@interface SwarmSDKManager : NSObject <WhereAmINotificationDelegate, SwarmLoginCompletedDelegate, WhatIsHereNotificationDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic, weak) UITextView *debugTextView;

- (void)startWhereAmI;
- (void)startWhatIsHere;
- (void)stopServices;
- (void)doSwarmLogin; 


@end
