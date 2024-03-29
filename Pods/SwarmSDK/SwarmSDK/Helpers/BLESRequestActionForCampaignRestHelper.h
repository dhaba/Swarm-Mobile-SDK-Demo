//
//  BLESRequestCouponForCampaignRestHelper.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.19..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLESRestApi.h"

@interface BLESRequestActionForCampaignRestHelper : NSObject  <NSURLConnectionDataDelegate>
@property (strong, nonatomic) BLESRestApi *restApi;
@property (strong, nonatomic) NSMutableData *d;
@property (strong, nonatomic) NSString *campaignId;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
