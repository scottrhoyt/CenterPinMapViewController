//
//  SHMapViewController.m
//  Map View Controller
//
//  Created by Scott Hoyt on 3/6/14.
//  Copyright (c) 2014 Wild Onion Labs. All rights reserved.
//

#import "CenterPinMapViewController.h"

@interface CenterPinMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPointAnnotation *centerAnnotaion;
@property (strong, nonatomic) MKPinAnnotationView *centerAnnotationView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (nonatomic) BOOL lastValidZoomState;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, readwrite) CLLocationCoordinate2D selectedCoordinate;

@end

@implementation CenterPinMapViewController

#pragma mark - Setters/Getters

- (MKPointAnnotation *)centerAnnotaion
{
    if (!_centerAnnotaion) {
        _centerAnnotaion = [[MKPointAnnotation alloc] init];
    }
    
    return _centerAnnotaion;
}

- (MKPinAnnotationView *)centerAnnotationView
{
    if (!_centerAnnotationView) {
        _centerAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:self.centerAnnotaion
                                                                reuseIdentifier:@"centerAnnotationView"];
        _centerAnnotationView.pinColor = MKPinAnnotationColorPurple;
    }
    
    return _centerAnnotationView;
}

//- (CLLocationCoordinate2D)selectedCoordinate
//{
//    return self.mapView.centerCoordinate;
//}

- (void)setMapView:(MKMapView *)mapView
{
    // Remove ourselves as delegate to old and add to new
    if (_mapView) {
        _mapView.delegate = nil;
    }
    
    _mapView = mapView;
    
    if (_mapView) {
        mapView.delegate = self;
    }
}

#define DEFAULT_INITIAL_SIZE 5000000

- (NSUInteger)initialMapSize
{
    if (!_initialMapSize) {
        _initialMapSize = DEFAULT_INITIAL_SIZE;
    }
    
    return _initialMapSize;
}

#define DEFAULT_ZOOM_SIZE 1000

- (NSUInteger)zoomMapSize
{
    if (!_zoomMapSize) {
        _zoomMapSize = DEFAULT_ZOOM_SIZE;
    }
    
    return _zoomMapSize;
}

- (void)setDoesDisplayPointAccuracyIndicators:(BOOL)doesDisplayPointAccuracyIndicators
{
    _doesDisplayPointAccuracyIndicators = doesDisplayPointAccuracyIndicators;
    [self updatePointAccuracyIndicators];
}

-(void)setRequiredPointAccuracy:(CLLocationDistance)requiredPointAccuracy
{
    _requiredPointAccuracy = requiredPointAccuracy;
    [self updatePointAccuracyIndicators];
}

- (void)setZoomToUser:(BOOL)zoomToUser
{
    if (zoomToUser) {
        if (self.mapView.showsUserLocation && self.mapView.userLocation.location && !self.mapView.userLocation.updating) {
            [self changeRegionToCoordinate:self.mapView.userLocation.location.coordinate withSize:self.zoomMapSize];
            _zoomToUser = NO;
        } else {
            _zoomToUser = YES;
        }
    } else
    {
        _zoomToUser = NO;
    }
}

- (UIToolbar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.opaque = NO;
        _toolbar.translucent = YES;
        [_toolbar setBackgroundImage:[UIImage new]
                    forToolbarPosition:UIBarPositionAny
                            barMetrics:UIBarMetricsDefault];
        [_toolbar setShadowImage:[UIImage new]
                forToolbarPosition:UIToolbarPositionAny];
        MKUserTrackingBarButtonItem *userTrackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
        
        [_toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], userTrackingButton]];
    }
    
    return _toolbar;
}

- (void)setShowUserTrackingButton:(BOOL)showUserTrackingButton
{
    if (_showUserTrackingButton != showUserTrackingButton) {
        _showUserTrackingButton = showUserTrackingButton;
        if (self.view.window) {
            if (_showUserTrackingButton) {
                [self initToolbarAndAdd];
            } else {
                [self.toolbar removeFromSuperview];
            }
        }
    }
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

- (CLLocationCoordinate2D)userCoordinate
{
    return self.mapView.userLocation.coordinate;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView addSubview:self.centerAnnotationView];
}

// Default center of the map is the geographic center of the US
#define DEFAULT_CENTER_LATTITUDE 39.8282
#define DEFAULT_CENTER_LONGITUDE -98.5795

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(DEFAULT_CENTER_LATTITUDE, DEFAULT_CENTER_LONGITUDE),self.initialMapSize, self.initialMapSize)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self moveMapAnnotationToCoordinate:self.mapView.centerCoordinate];
    
    if (self.showUserTrackingButton) {
        [self initToolbarAndAdd];
    }
}

#pragma mark - main methods

- (void)initToolbarAndAdd
{
    self.toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);

    [self.mapView addSubview:self.toolbar];
}

// These are the constants need to offset distance between the lower left corner of
// the annotaion view and the head of the pin
#define PIN_WIDTH_OFFSET 7.75
#define PIN_HEIGHT_OFFSET 5

- (void)moveMapAnnotationToCoordinate:(CLLocationCoordinate2D) coordinate
{
    CGPoint mapViewPoint = [self.mapView convertCoordinate:coordinate toPointToView:self.mapView];
    
    // Offset the view from to account for distance from the lower left corner to the pin head
    CGFloat xoffset = CGRectGetMidX(self.centerAnnotationView.bounds) - PIN_WIDTH_OFFSET;
    CGFloat yoffset = -CGRectGetMidY(self.centerAnnotationView.bounds) + PIN_HEIGHT_OFFSET;
    
    self.centerAnnotationView.center = CGPointMake(mapViewPoint.x + xoffset,
                                                   mapViewPoint.y + yoffset);
}

- (void)changeRegionToCoordinate:(CLLocationCoordinate2D)coordinate withSize:(NSUInteger)size
{
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(coordinate, size, size);
    [self.mapView setRegion:newRegion animated:YES];
}

- (CLLocationDistance)metersPerViewPoint
{
    CGRect comparisonRect = CGRectMake(self.mapView.center.x,
                                       self.mapView.center.y,
                                       1,
                                       1);
    MKCoordinateRegion comparisonRegion = [self.mapView convertRect:comparisonRect toRegionFromView:self.mapView];
    CLLocationCoordinate2D comparisonCoordinate1 = CLLocationCoordinate2DMake(comparisonRegion.center.latitude - comparisonRegion.span.latitudeDelta,
                                                                              comparisonRegion.center.longitude - comparisonRegion.span.longitudeDelta);
    CLLocationCoordinate2D comparisonCoordinate2 = CLLocationCoordinate2DMake(comparisonRegion.center.latitude + comparisonRegion.span.latitudeDelta,
                                                                             comparisonRegion.center.longitude + comparisonRegion.span.longitudeDelta);
    CLLocationDistance sizeInMeters = MKMetersBetweenMapPoints(MKMapPointForCoordinate(comparisonCoordinate1),
                                                                MKMapPointForCoordinate(comparisonCoordinate2));
    
    return sizeInMeters;
}

- (BOOL)mapIsAtValidZoomScale
{
    if (self.requiredPointAccuracy) {
        return [self metersPerViewPoint] <= self.requiredPointAccuracy;
    } else {
        return YES;
    }
}

#define INDICATOR_BORDER_WIDTH 5

- (void)updatePointAccuracyIndicators
{
    if (self.doesDisplayPointAccuracyIndicators && self.requiredPointAccuracy > 0) {
        if ([self mapIsAtValidZoomScale]) {
            self.mapView.layer.borderColor = [UIColor greenColor].CGColor;
            self.mapView.layer.borderWidth = INDICATOR_BORDER_WIDTH;
        } else {
            self.mapView.layer.borderColor = [UIColor redColor].CGColor;
            self.mapView.layer.borderWidth = INDICATOR_BORDER_WIDTH;
        }
    }
    else
    {
        self.mapView.layer.borderWidth = 0;
    }

}

- (CLLocation *)locationForCoordinate:(CLLocationCoordinate2D)coordinate
{
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate
                                                         altitude:0
                                               horizontalAccuracy:1
                                                 verticalAccuracy:1
                                                        timestamp:[NSDate date]];
    
    return location;
}

- (void)reverseGeoCodeAfterTimer:(NSTimer *)timer
{
    CLLocation *location = (CLLocation *)timer.userInfo;
    
    // If we are still at the same location after the delay, reverse geocod
    if ((location.coordinate.latitude == self.selectedCoordinate.latitude) &&
        (location.coordinate.longitude == self.selectedCoordinate.longitude)) {
        CLGeocodeCompletionHandler handler = ^(NSArray *placemark, NSError *error){
            if (error) {
                NSLog(@"Error in geocode request. Error message: %@", error);
            }
            else
            {
                // If there is atleast one placemark, set the selected placemark and call delegate
                if (placemark && ([placemark count] > 0)) {
                    self.selectedPlacemark = placemark[0];
                    NSLog(@"%@", placemark);
                    NSLog(@"Reverse location name: %@", self.selectedPlacemark.name);
                    if ([self.delegate respondsToSelector:@selector(centerPinMapViewController:didResolvePlacemark:)]) {
                        // Notify delegate on main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate centerPinMapViewController:self didResolvePlacemark:placemark[0]];
                        });
                    }
                }
            }
        };
        [self.geocoder reverseGeocodeLocation:location completionHandler:handler];
    }
}

#pragma mark - MapView Delegate methods

#define REVERSE_GEOCODE_DELAY 2.0

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
        BOOL currentZoomStateValid = [self mapIsAtValidZoomScale];
    
    if (self.lastValidZoomState != currentZoomStateValid) {
        self.lastValidZoomState = currentZoomStateValid;
        if (self.doesDisplayPointAccuracyIndicators && self.requiredPointAccuracy > 0) {
            [self updatePointAccuracyIndicators];
        }
        
        if ([self.delegate respondsToSelector:@selector(centerPinMapViewController:didChangeValidZoomScaleTo:)]) {
            [self.delegate centerPinMapViewController:self didChangeValidZoomScaleTo:currentZoomStateValid];
        }
    }
    
    // If the center coordinate has changed, update values
    if ((self.centerAnnotaion.coordinate.latitude) != (self.mapView.centerCoordinate.latitude) ||
        (self.centerAnnotaion.coordinate.longitude != (self.mapView.centerCoordinate.longitude))) {
        
        self.centerAnnotaion.coordinate = mapView.centerCoordinate;
        self.selectedPlacemark = nil;
        
        [self moveMapAnnotationToCoordinate:mapView.centerCoordinate];
        
        // If the current zoom state is valid update selected values
        if (currentZoomStateValid) {
            self.selectedCoordinate = self.mapView.centerCoordinate;
            
            // Schedule geocode if enabled
            if (self.shouldReverseGeocode) {
                [NSTimer scheduledTimerWithTimeInterval:REVERSE_GEOCODE_DELAY
                                                 target:self selector:@selector(reverseGeoCodeAfterTimer:)
                                               userInfo:[self locationForCoordinate:self.selectedCoordinate]
                                                repeats:NO];
            }
            
            if ([self.delegate respondsToSelector:@selector(centerPinMapViewController:didChangeSelectedCoordinate:)]) {
                [self.delegate centerPinMapViewController:self didChangeSelectedCoordinate:self.mapView.centerCoordinate];
            }
        }
        
    }

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.zoomToUser) {
        [self changeRegionToCoordinate:userLocation.coordinate withSize:self.zoomMapSize];
        self.zoomToUser = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(centerPinMapViewController:didUpdateUserLocation:)]) {
        [self.delegate centerPinMapViewController:self didUpdateUserLocation:userLocation.location];
    }
}

@end
