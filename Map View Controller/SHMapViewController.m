//
//  SHMapViewController.m
//  Map View Controller
//
//  Created by Scott Hoyt on 3/6/14.
//  Copyright (c) 2014 Wild Onion Labs. All rights reserved.
//

#import "SHMapViewController.h"
#import <MapKit/MapKit.h>
#import "SHPinAnnotation.h"

@interface SHMapViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) SHPinAnnotation *centerAnnotaion;
@property (strong, nonatomic) MKPinAnnotationView *centerAnnotationView;
@property (strong, nonatomic) UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;

@end

@implementation SHMapViewController

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
        //_centerAnnotationView.backgroundColor = [UIColor blueColor];
    }
    
    return _centerAnnotationView;
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
//    [self.mapView addAnnotation:self.centerAnnotaion];
//    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    panGesture.delegate = self;
//    [self.mapView addGestureRecognizer:panGesture];
//    
//    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    pinchGesture.delegate = self;
//    [self.mapView addGestureRecognizer:pinchGesture];
//	// Do any additional setup after loading the view.
    
    [self.mapView addSubview:self.centerAnnotationView];
    //[self.mapView addSubview:self.testView];
}

#define PIN_WIDTH_OFFSET 7.75
#define PIN_HEIGHT_OFFSET 5

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.centerAnnotationView.center = self.mapView.center;
//    CGPoint centerMapPoint = [self.mapView convertCoordinate:self.mapView.centerCoordinate toPointToView:self.mapView];
//    CGFloat xoffset = CGRectGetMidX(self.centerAnnotationView.bounds) - PIN_WIDTH_OFFSET;
//    CGFloat yoffset = -CGRectGetMidY(self.centerAnnotationView.bounds) + PIN_HEIGHT_OFFSET;
//    self.centerAnnotationView.center = CGPointMake(centerMapPoint.x + xoffset,
//                                                   centerMapPoint.y + yoffset);
//    self.centerAnnotationView.center = CGPointMake(CGRectGetMidX(self.mapView.bounds),
//                                                   CGRectGetMidY(self.mapView.bounds));
    
    //self.centerAnnotationView.center = centerMapPoint;
//    CGFloat xoffset = -CGRectGetMidX(self.centerAnnotationView.frame);
//    CGFloat yoffset = - CGRectGetMaxY(self.centerAnnotationView.frame);
//    xoffset = 0;
//    yoffset = 0;
//    
//    self.centerAnnotationView.frame = CGRectMake(centerMapPoint.x + xoffset,
//                                                  centerMapPoint.y + yoffset,
//                                                  self.centerAnnotationView.frame.size.width,
//                                                  self.centerAnnotationView.frame.size.height);
    //self.testView.center = self.mapView.center;

    //self.centerAnnotationView.center = self.mapView.center;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGPoint centerMapPoint = [self.mapView convertCoordinate:self.mapView.centerCoordinate toPointToView:self.mapView];
    CGFloat xoffset = CGRectGetMidX(self.centerAnnotationView.bounds) - PIN_WIDTH_OFFSET;
    CGFloat yoffset = -CGRectGetMidY(self.centerAnnotationView.bounds) + PIN_HEIGHT_OFFSET;
    self.centerAnnotationView.center = CGPointMake(centerMapPoint.x + xoffset,
                                                   centerMapPoint.y + yoffset);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture Recognizer Delegate Methods

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
//    self.centerAnnotaion.coordinate = self.mapView.centerCoordinate;
//    self.centerAnnotaion.title = [NSString stringWithFormat:@"%f, %f", self.centerAnnotaion.coordinate.latitude, self.centerAnnotaion.coordinate.longitude];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //let the map view's and our gesture recognizers work at the same time...
    return YES;
}

#pragma mark - MapView Delegate methods

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    //MKCoordinateRegion region = mapView.region;
//    self.centerAnnotaion.coordinate = mapView.centerCoordinate;
//    self.centerAnnotaion.title = [NSString stringWithFormat:@"%f, %f", self.centerAnnotaion.coordinate.latitude, self.centerAnnotaion.coordinate.longitude];
//    self.latLabel.text = [NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.latitude];
//    self.longLabel.text = [NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.longitude];
//    //self.centerAnnotationView.center = self.mapView.center;
    
    CGPoint centerMapPoint = [self.mapView convertCoordinate:self.mapView.centerCoordinate toPointToView:self.mapView];
    CGFloat xoffset = CGRectGetMidX(self.centerAnnotationView.bounds) - PIN_WIDTH_OFFSET;
    CGFloat yoffset = -CGRectGetMidY(self.centerAnnotationView.bounds) + PIN_HEIGHT_OFFSET;
    self.centerAnnotationView.center = CGPointMake(centerMapPoint.x + xoffset,
                                                   centerMapPoint.y + yoffset);
}

//#define PIN_REUSE_ID @"pin"
//
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[SHPinAnnotation class]]) {
//        MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PIN_REUSE_ID];
//        pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
//        
//        return pinAnnotationView;
//    }
//    else
//    {
//        return [mapView viewForAnnotation:annotation];
//    }
//
//}

@end
