//
//  SHMapViewController.h
//  Map View Controller
//
//  Created by Scott Hoyt on 3/6/14.
//  Copyright (c) 2014 Wild Onion Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SHCenterPinMapViewController : UIViewController

@property (nonatomic, readonly) CLLocationCoordinate2D centerCoordinate;

@end
