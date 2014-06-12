//
//  ViewController.m
//  Estimote-iBeacon
//
//  Created by eran on 2014-06-09.
//  Copyright (c) 2014 Dewire. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) ESTBeaconManager* beaconManager;
@property (strong, nonatomic) ESTBeaconRegion* beaconRegion;
@property (strong, nonatomic) NSString* UUIDD;
@property (nonatomic) BOOL ranging;
@property (nonatomic) BOOL timing;
@property (nonatomic) BOOL invalidateTime;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.UUIDD = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    self.ranging = NO;
    self.timing = NO;
    self.invalidateTime = NO;
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:self.UUIDD];
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"IBeacon-estimote-app"];
    
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    
    //TESTING
    UILocalNotification* noti = [[UILocalNotification alloc] init];
    NSTimeInterval time = 20;
    noti.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:time];
    noti.alertAction = @"IBeacon reminder";
    noti.alertBody = @"TEST";
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
    NSLog(@"Scheduled test notification");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region {
    [self saveWorkTimeBegin:YES];
    [self sendNotificationWithMessage:@"Entry time saved"];

    
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region {
    [self saveWorkTimeBegin:NO];
    [self sendNotificationWithMessage:@"Leaving time saved"];

    
}

- (void)beaconManager:(ESTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(ESTBeaconRegion *)region {
    if (state == CLRegionStateInside) {
        [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
        self.ranging = YES;
        self.beaconInfoLabel.text = @"Beacon found";
    }
    else if (state == CLRegionStateOutside) {
        self.ranging = NO;
        self.beaconInfoLabel.text = @"No beacons found";
        self.rssiLabel.text = @"";
    }
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
    if ([beacons count] > 0 && self.ranging) {
        ESTBeacon* beacon = [beacons firstObject];
        NSLog(@"uuid %@", beacon.proximityUUID.UUIDString);
        NSLog(@"major %@", beacon.major);
        NSLog(@"minor %@", beacon.minor);
        NSLog(@"rssi %ld", (long)beacon.rssi);
        
        NSString* proximityString;
        if(beacon.proximity == CLProximityUnknown)
            proximityString = @"Unknown";
        if(beacon.proximity == CLProximityFar)
            proximityString = @"Far";
        else if(beacon.proximity == CLProximityNear)
            proximityString = @"Near";
        else if(beacon.proximity == CLProximityImmediate)
            proximityString = @"Immediate";
        self.beaconInfoLabel.text = [NSString stringWithFormat:@"Beacon found - %@", proximityString];
        
        self.rssiLabel.text = [NSString stringWithFormat:@"RSSI: %ld", (long)beacon.rssi];
    }
}


- (void)saveWorkTimeBegin:(BOOL)begin{
    
    NSDate* now = [[NSDate alloc] init];
    NSTimeInterval seconds = [now timeIntervalSince1970];
    
    NSUserDefaults* nsud = [NSUserDefaults standardUserDefaults];
    NSArray* startTimes = [nsud arrayForKey:@"startTimes"];
    NSArray* stopTimes = [nsud arrayForKey:@"stopTimes"];
    
    NSMutableArray* startTimesCopy;
    NSMutableArray* stopTimesCopy;
    if (startTimes == nil || stopTimes == nil) {
        startTimesCopy = [[NSMutableArray alloc]init];
        stopTimesCopy = [[NSMutableArray alloc] init];
        [startTimesCopy addObject:[NSString stringWithFormat:@"%f", seconds]];
    }
    else {
        startTimesCopy = [[NSMutableArray alloc] initWithArray:startTimes copyItems:YES];
        stopTimesCopy = [[NSMutableArray alloc] initWithArray:stopTimes copyItems:YES];
        
        if (begin) {
            [startTimesCopy addObject:[NSString stringWithFormat:@"%f", seconds]];
        } else {
            [stopTimesCopy addObject:[NSString stringWithFormat:@"%f", seconds]];
        }
    }
    
    [nsud setObject:startTimesCopy forKey:@"startTimes"];
    [nsud setObject:stopTimesCopy forKey:@"stopTimes"];
    [nsud synchronize];
}


- (void)sendNotificationWithMessage:(NSString *)message {
    UILocalNotification* noti = [[UILocalNotification alloc] init];
    NSTimeInterval time = 0.5;
    noti.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:time];
    noti.alertAction = @"IBeacon reminder";
    noti.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
    NSLog(@"Scheduled notification");

}


@end
