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

@interface SHMapViewController () <MKMapViewDelegate>

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapView Delegate methods

#define PIN_REUSE_ID @"pin"

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PIN_REUSE_ID];
    pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    
    return pinAnnotationView;
}

@end
