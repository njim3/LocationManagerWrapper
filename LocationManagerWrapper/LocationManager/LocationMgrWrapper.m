//
//  LocationMgrWrapper.m
//  LocationManagerWrapper
//
//  Created by njim3 on 24/08/2017.
//  Copyright © 2017 cnbmsmart. All rights reserved.
//

#import "LocationMgrWrapper.h"

@interface LocationMgrWrapper () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locManager;
@property (nonatomic, strong) CLGeocoder* geocoder;

@property (copy, nonatomic) LocationBlock locBlock;

@end


@implementation LocationMgrWrapper

SingleImplementation(Manager)

- (CLLocationManager*)locManager {
    
    if (!_locManager) {
        
        _locManager = [[CLLocationManager alloc] init];
        
        _locManager.delegate = self;
        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // iOS Version >= 8.0
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        
        NSString* whenInUseStr = infoDict[@"NSLocationWhenInUseUsageDescription"];
        NSString* alwaysUseStr = infoDict[@"NSLocationAlwaysUsageDescription"];
        
        if (whenInUseStr) {
            [_locManager requestWhenInUseAuthorization];
            
        } else {
            if (alwaysUseStr) {
                [_locManager requestAlwaysAuthorization];
                
            } else {
                NSLog(@"Please add key into info.plist");
            }
        }
    }
    
    return _locManager;
}

- (CLGeocoder*)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

- (void)getCurrentLocation: (LocationBlock)block {
    
    self.locBlock = block;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locManager startUpdatingLocation];
    } else {
        self.locBlock(nil, nil, @"Location Service disabled.");
    }
}

#pragma mark - CLLocationManager delegate method

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation* newLocation = [locations firstObject];
    
    if (newLocation.horizontalAccuracy >= 0) {
        [self.geocoder reverseGeocodeLocation: newLocation
            completionHandler:^(NSArray<CLPlacemark *>* placemarks,
                                NSError* error) {
                
                if (!error) {
                    CLPlacemark* placeMark = [placemarks firstObject];
                    
                    self.locBlock(newLocation, placeMark, nil);
                } else {
                    self.locBlock(newLocation, nil, @"Fail to geocode location");
                }
            }];
    }
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
            NSLog(@"User need to change authorization.");
            
            break;
            
        case kCLAuthorizationStatusDenied:
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"Location service is open but denied.");
                
                self.locBlock(nil, nil, @"Location service is open but denied.");
            } else {
                NSLog(@"Location service is closed.");
                
                self.locBlock(nil, nil, @"Location service is closed.");
            }
            
            break;
        
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"User is open location service.");
            
            break;
            
        default:
            break;
    }
}


@end
