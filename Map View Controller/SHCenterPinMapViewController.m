//
//  SHMapViewController.m
//  Map View Controller
//
//  Created by Scott Hoyt on 3/6/14.
//  Copyright (c) 2014 Wild Onion Labs. All rights reserved.
//

#import "SHCenterPinMapViewController.h"
#import "SHPinAnnotation.h"

@interface SHCenterPinMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) SHPinAnnotation *centerAnnotaion;
@property (strong, nonatomic) MKPinAnnotationView *centerAnnotationView;
@property (strong, nonatomic) UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;

@end

@implementation SHCenterPinMapViewController

#pragma mark - Setters/Getters

- (UIView *)testView
{
    if (!_testView) {
        _testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _testView.backgroundColor = [UIColor orangeColor];
        _testView.alpha = 0.6;
    }
    
    return _testView;
}

- (SHPinAnnotation *)centerAnnotaion
{
    if (!_centerAnnotaion) {
        _centerAnnotaion = [[SHPinAnnotation alloc] init];
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

- (CLLocationCoordinate2D)centerCoordinate
{
    return self.mapView.centerCoordinate;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView addSubview:self.centerAnnotationView];
    [self.mapView addSubview:self.testView];
}

#define PIN_WIDTH_OFFSET 7.75
#define PIN_HEIGHT_OFFSET 5

- (void)moveMapAnnotationToCoordinate:(CLLocationCoordinate2D) coordinate
{
    CGPoint centerMapPoint = [self.mapView convertCoordinate:coordinate toPointToView:self.mapView];
    CGFloat xoffset = CGRectGetMidX(self.centerAnnotationView.bounds) - PIN_WIDTH_OFFSET;
    CGFloat yoffset = -CGRectGetMidY(self.centerAnnotationView.bounds) + PIN_HEIGHT_OFFSET;
    self.centerAnnotationView.center = CGPointMake(centerMapPoint.x + xoffset,
                                                   centerMapPoint.y + yoffset);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self moveMapAnnotationToCoordinate:self.mapView.centerCoordinate];
    self.testView.center = self.mapView.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MapView Delegate methods

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.centerAnnotaion.coordinate = mapView.centerCoordinate;
    [self moveMapAnnotationToCoordinate:mapView.centerCoordinate];
    self.latLabel.text = [NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.latitude];
    self.longLabel.text = [NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.longitude];
}

@end
