//
//  MapViewController.m
//  GeoFenceMonitoring
//
//  Created by Priyanka Sen on 01/09/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import "MapViewController.h"
#import "Utility.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView,latLongDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    
    self.mapView.delegate = self;
    [self addFences];
}

-(void)addFences{
    
    self.latLongDic = [[NSMutableDictionary alloc] initWithDictionary:[Utility getLatLongDic]];
    NSMutableArray * latLongArr;
    
    for (int i=0; i<[[self.latLongDic allKeys] count]; i++) {
        
        latLongArr = [[NSMutableArray alloc] initWithArray:[[self.latLongDic objectForKey:[[self.latLongDic allKeys] objectAtIndex:i]] componentsSeparatedByString:@","]];
        
        CLLocationDistance fenceDistance = [[Utility getGeoFenceRadius] floatValue];
        CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake([[latLongArr objectAtIndex:0] floatValue], [[latLongArr objectAtIndex:1] floatValue]);
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
        [self.mapView addOverlay: circle];
        
        
        MKPointAnnotation *point;
        point = [[MKPointAnnotation alloc] init];
        point.coordinate = circleMiddlePoint;
        point.title = [[self.latLongDic allKeys] objectAtIndex:i];
        point.subtitle = [self.latLongDic objectForKey:[[self.latLongDic allKeys] objectAtIndex:i]];
        [self.mapView addAnnotation:point];
    }
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    // Add an annotation
    
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay

{
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:(MKCircle *)overlay];
    circleView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
    circleView.strokeColor = [UIColor blueColor];
    circleView.lineWidth = 1.0;
    return circleView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
