//
//  ViewController.m
//  SwarmSDKDemo
//
//  Created by Davis Haba on 10/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "SwarmSDKManager.h"

#define DebugLog(msg, ...) [self debugLog:(@"%s : %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:msg, ##__VA_ARGS__])]

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *debugTextView;
@property (nonatomic, strong) SwarmSDKManager *sdkManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sdkManager = [SwarmSDKManager sharedInstance];
    self.sdkManager.debugTextView = self.debugTextView;

    // Check for location services
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"#### Please enable location services ####");
        [[CLLocationManager new] startUpdatingLocation];
    } else {
        NSLog(@"Location services enabled");
    }
}

#pragma mark - IBActions

- (IBAction)startButtonPressed:(id)sender {
    [self.sdkManager startWhereAmI];
}

- (IBAction)startWhatIsHerePressed:(id)sender {
    [self.sdkManager startWhatIsHere];
}

- (IBAction)stopServicesPressed:(id)sender {
    [self.sdkManager stopServices];
}

- (IBAction)doSwarmLoginPressed:(id)sender {
    [self.sdkManager doSwarmLogin];
}

@end
