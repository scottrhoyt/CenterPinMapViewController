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

///@brief The minimum number of meters per point. Set to 0 to disable;
@property (nonatomic) CLLocationDistance requiredPointAccuracy;

///@brief The initial size, in meters, of the map's smallest dimension
@property (nonatomic) NSUInteger initialMapSize;

///@brief Tells the mapview to zoom to the user location on next location update
@property (nonatomic) BOOL zoomToUser;

///@brief The size, in meters, of the smallest dimension of the map after zooming to user
@property (nonatomic) NSUInteger zoomMapSize;

/*!
 The method uses the value set in requiredPointAccuracy to determine if the scale is valid.
 
@brief Determines whether or not the map is at a valid zoom scale
@return whether or not the map is at a valid scale
*/
- (BOOL)mapIsAtValidZoomScale;


/*!
 This method determines the meters in the diagnal of a unit point rectangle at the center of the map.
 
 @brief The meters per point in the MapView
 @return meters per point
 */
- (CLLocationDistance)metersPerViewPoint;

@end
