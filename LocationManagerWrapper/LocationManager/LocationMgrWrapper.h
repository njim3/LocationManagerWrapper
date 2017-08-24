//
//  LocationMgrWrapper.h
//  LocationManagerWrapper
//
//  Created by njim3 on 24/08/2017.
//  Copyright © 2017 cnbmsmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationBlock)(CLLocation* location, CLPlacemark* placeMark, NSString* error);

@interface LocationMgrWrapper : NSObject

SingleInterface(Manager);

- (void)getCurrentLocation: (LocationBlock)block;

@end
