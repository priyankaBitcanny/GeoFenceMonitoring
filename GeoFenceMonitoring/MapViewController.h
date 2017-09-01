//
//  MapViewController.h
//  GeoFenceMonitoring
//
//  Created by Priyanka Sen on 01/09/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSMutableDictionary * latLongDic;


@end
