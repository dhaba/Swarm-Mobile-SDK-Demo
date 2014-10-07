//
//  SwarmSDKManager.m
//  SwarmSDKDemo
//
//  Created by Davis Haba on 10/6/14.
//  Copyright (c) 2014 Davis Haba. All rights reserved.
//

#import "SwarmSDKManager.h"

#define DebugLog(msg, ...) [self debugLog:(@"%s : %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:msg, ##__VA_ARGS__])]

//Production UUID: 45FB2AE1-A73B-4ECC-852D-DB5BDFCB4F1C
//Demo UUID: E2C56DB5-DFFB-48D2-B060-D0F5A71096E0

NSString * const SwarmApiKey = @"c7078e78-48ce-11e4-aec4-12313f0a20f4";
NSString * const PartnerId = @"groupon";
NSString * const RemoteId = @"dhaba@groupon.com";
NSString * const SwarmBeaconUUID = @"45FB2AE1-A73B-4ECC-852D-DB5BDFCB4F1C";

@interface SwarmSDKManager ()

@property (nonatomic, strong) SwarmSDK *swarmSDK;
@property (nonatomic, strong) NSString *swarmId;

@end

@implementation SwarmSDKManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static SwarmSDKManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[SwarmSDKManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _swarmSDK = [SwarmSDK new];
        [_swarmSDK setSwarmApiKey:SwarmApiKey];
        [_swarmSDK initPartnerId:PartnerId];
        [_swarmSDK initRemoteId:RemoteId];
        [_swarmSDK setSwarmUuid:[[NSUUID alloc] initWithUUIDString:SwarmBeaconUUID]];

        _swarmSDK.swarmLoginCompletedDelegate = self;
        _swarmSDK.swarmId = nil;

        [_swarmSDK setShowNotificationEnabled:YES];
        [_swarmSDK setUseLongJobForBackgroundRequests:YES];
    }
    return self;
}

- (void)startWhereAmI {
    self.swarmSDK.whereAmINotificationDelegate = self;
    [self.swarmSDK startWhereAmIService];

    DebugLog(@"Starting WhereAmIService");
}

- (void)startWhatIsHere {
    self.swarmSDK.whatIsHereNotificationDelegate = self;
    [self.swarmSDK startWhatIsHereService];

    DebugLog(@"Starting WhatIsHereService");
}

- (void)stopServices {
    self.swarmSDK.whereAmINotificationDelegate = nil;
    self.swarmSDK.whatIsHereNotificationDelegate = nil;

    DebugLog(@"Stopping services, setting delegates to nil");
}

- (void)doSwarmLogin; {
    [self.swarmSDK doSwarmLogin:[self createUserProfileWithSwarmId:self.swarmId]];
    DebugLog(@"Attempting swarm login");
}

#pragma mark - WhereAmINotificationDelegate

-(void)onWhereAmINotificationReceived:(SWARMWhatIsHereInformation*)locationInfo withError:(NSError*)error {
    if (!error) {
        DebugLog(@"WhereAmI notif received, %@", [self buildStringForLocationInfo:locationInfo]);
    } else {
        DebugLog(@"WhereAmINotifcation finished with error %@", error.localizedDescription);
    }
}

#pragma mark - WhatIsHereNotificationDelegate

-(void)onWhatIsHereNotificationReceived:(SWARMWhatIsHereInformation*)whatIsHereInfo withError:(NSError*)error {
    if (!error) {
        DebugLog(@"WhatIsHere notif received, %@", [self buildStringForLocationInfo:whatIsHereInfo]);
    } else {
        DebugLog(@"What is here finished with error %@", error.localizedDescription);
    }
}

#pragma mark - SwarmLoginRequestCompletedDelegate

-(void)onSwarmLoginCompleted:(SWARMUserProfile*)userProfile withError:(NSError*)error {
    if (!error) {
        self.swarmId = [userProfile.customerSwarmId copy];
        self.swarmSDK.swarmId = [userProfile.customerSwarmId copy];
        DebugLog(@"Swarm login complete! SwarmId: %@", userProfile.customerSwarmId);
    } else {
        DebugLog(@"!!!!! Swarm login finished with error %@", error.localizedDescription);
    }
}

#pragma mark - Private

- (SWARMUserProfile *)createUserProfileWithSwarmId:(NSString *)swarmId {
    SWARMUserProfile *profile = [SWARMUserProfile new];
    profile.partnerId = PartnerId;
    profile.remoteId = RemoteId;
    profile.userName = @"Test User";
    profile.desc = @"Test User enjoys hiking and fishing";
    profile.vendorId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    profile.sourceSegmentVector = [SWARMSourceSegmentVector new];
    [profile.sourceSegmentVector addTagToCategory:@"Davis Haba" forCategory:@"name"];
    if (swarmId) {
        profile.customerSwarmId = swarmId;
    }

    return profile;
}

- (NSString *)buildStringForLocationInfo:(SWARMWhatIsHereInformation *)locationInfo {
    NSString *debugString = [NSString stringWithFormat:@"%d Locations", locationInfo.locations.count];
    for (SWARMLocationInformaion *loc in locationInfo.locations) {
        debugString = [debugString stringByAppendingFormat:@"\n\t Store name: %@, major: %@, minor: %@, # campaigns: %d",
                       loc.storeName, loc.major, loc.minor, loc.campaigns.count];
        for (BLESCampaign *campaign in loc.campaigns) {
            debugString = [debugString stringByAppendingFormat:@"\n\t\tCampaign title: %@, description: %@, # coupons: %d",
                           campaign.title, campaign.desc, campaign.coupons.count];
        }
    }
    return debugString;
}

- (void)debugLog:(NSString *)string {
    NSLog(@"%@", string);
    if (self.debugTextView) {
        self.debugTextView.text = [self.debugTextView.text stringByAppendingFormat:@"\n%@", string];
    }
}

@end
