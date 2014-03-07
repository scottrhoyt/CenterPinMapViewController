//
//  SHMapViewController.m
//  Map View Controller
//
//  Created by Scott Hoyt on 3/6/14.
//  Copyright (c) 2014 Wild Onion Labs. All rights reserved.
//

#import "SHMapViewController.h"
#import <MapKit/MapKit.h>
#import "SHReportAnnotation.h"

@interface SHMapViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) SHReportAnnotation *reportAnnotaion;

@end

@implementation SHMapViewController

#pragma mark - Setters/Getters

- (SHReportAnnotation *)reportAnnotaion
{
    if (!_reportAnnotaion) {
        _reportAnnotaion = [[SHReportAnnotation alloc] init];
    }
    
    return _reportAnnotaion;
}

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView addAnnotation:self.reportAnnotaion];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    panGesture.delegate = self;
    [self.mapView addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    pinchGesture.delegate = self;
    [self.mapView addGestureRecognizer:pinchGesture];
	// Do any additional setup after loading the view.
    
    MKPinAnnotationView *pan = [[MKPinAnnotationView alloc] initWithAnnotation:self.reportAnnotaion reuseIdentifier:@"oo"];
    pan.center = self.mapView.center;
    [self.mapView addSubview:pan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture Recognizer Delegate Methods

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    self.reportAnnotaion.coordinate = self.mapView.centerCoordinate;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //let the map view's and our gesture recognizers work at the same time...
    return YES;
}

#pragma mark - MapView Delegate methods

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateRegion region = mapView.region;
    self.reportAnnotaion.coordinate = region.center;
}

#define PIN_REUSE_ID @"pin"

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SHReportAnnotation class]]) {
        MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PIN_REUSE_ID];
        pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
        
        return pinAnnotationView;
    }
    else
    {
        return [mapView viewForAnnotation:annotation];
    }

}

@end
