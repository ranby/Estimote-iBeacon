//
//  ViewController.h
//  Estimote-iBeacon
//
//  Created by eran on 2014-06-09.
//  Copyright (c) 2014 Dewire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EstimoteSDK/Headers/ESTBeaconManager.h"

@interface ViewController : UIViewController <ESTBeaconManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *beaconInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@end
