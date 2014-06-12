//
//  TimesTableViewController.h
//  Estimote-iBeacon
//
//  Created by eran on 2014-06-09.
//  Copyright (c) 2014 Dewire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* startTimes;
@property (strong, nonatomic) NSArray* stopTimes;


@end
