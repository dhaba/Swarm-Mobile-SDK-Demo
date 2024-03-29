//
//  BLESWhatIsHereRestHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESWhatIsHereRestHelper.h"
#import "BLESUrlDefinitions.h"
@implementation BLESWhatIsHereRestHelper
@synthesize restApi;
@synthesize d;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    RestLog(@"BLESWhatIsHereRestHelper - Connection %p did receive response %ld", connection, (long)[(NSHTTPURLResponse *) response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *reponseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    RestLog(@"BLESWhatIsHereRestHelper - Connection %p did receive %lu bytes:\n%@", connection, (unsigned long)[data length], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
    
    if (d==nil) {
        d =  [[NSMutableData alloc] init];
    }
    
    [d appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSData *data = [NSData dataWithData:d];
    d=nil;
    NSString *tmpBuffer = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *arr = [tmpBuffer componentsSeparatedByString:@"}{"];
    
    NSData *ret;
    
    if ([arr count]>1) {
        NSString *retString = [NSString stringWithFormat:@"%@}",[arr objectAtIndex:0]];
        ret = [retString dataUsingEncoding:NSUTF8StringEncoding];
        d=nil;
        
    }
    else
    {
        ret = [[arr objectAtIndex:0]dataUsingEncoding:NSUTF8StringEncoding];
        d=nil;
    }
    
    RestLog(@"BLESWhatIsHereRestHelper - Connection %p finished loading", connection );
    
    if ([restApi.whatIsHereRequestCompletedDelegate respondsToSelector:@selector(onWhatIsHereRequestCompleted:withError:)]) {
        [restApi.whatIsHereRequestCompletedDelegate onWhatIsHereRequestCompleted:ret withError:nil ];
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    RestLog(@"BLESWhatIsHereRestHelper - Connection %p did fail with error %@", connection, error);

    if ([restApi.whatIsHereRequestCompletedDelegate respondsToSelector:@selector(onWhatIsHereRequestCompleted:withError:)]) {
        [restApi.whatIsHereRequestCompletedDelegate onWhatIsHereRequestCompleted:nil withError:error];
        
    }
}
@end
