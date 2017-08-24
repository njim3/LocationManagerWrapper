//
//  ViewController.m
//  LocationManagerWrapper
//
//  Created by njim3 on 24/08/2017.
//  Copyright © 2017 cnbmsmart. All rights reserved.
//

#import "ViewController.h"
#import "LocationMgrWrapper.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *locationLbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getNewLocationAction:(id)sender {
    
    [[LocationMgrWrapper shareManager] getCurrentLocation:^(CLLocation *location,
                            CLPlacemark *placeMark, NSString *error) {
        
        if (error) {
            self.locationLbl.text = error;
        } else {
            
            NSString* locationStr = [NSString stringWithFormat:
                @"Country: %@\n"
                 "Locality: %@\n"
                 "SubLocality: %@\n"
                 "ThoroughFare: %@\n"
                 "SubThoroughFare: %@\n"
                 "Name: %@",
                 placeMark.country, placeMark.locality, placeMark.subLocality,
                 placeMark.thoroughfare, placeMark.subThoroughfare,
                 placeMark.name];
            
            self.locationLbl.text = locationStr;
        }
    }];
}


@end
