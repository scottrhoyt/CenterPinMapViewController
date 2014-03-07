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

///@brief Center coordinate of the mapView
@property (nonatomic, readonly) CLLocationCoordinate2D selectedCoordinate;

/////@brief The minimum number of meters per point
//@property (nonatomic) NSUInteger pointAccuracy;

///@brief The initial size, in meters, of the map's smallest dimension
@property (nonatomic) NSUInteger initialMapSize;

///@brief Tells the mapview to zoom to the user location on next location update
@property (nonatomic) BOOL zoomToUser;

///@brief The size, in meters, of the smallest dimension of the map after zooming to user
@property (nonatomic) NSUInteger zoomMapSize;

@end
