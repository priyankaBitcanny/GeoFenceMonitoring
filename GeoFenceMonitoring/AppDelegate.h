//
//  AppDelegate.h
//  GeoFenceMonitoring
//
//  Created by Ayush Kumar Sethi on 24/05/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) NSString * isUpdatingFromHome;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property double fenceRadius;

@property double fenceAccuracy;

-(BOOL)isLocationServiceEnabled;

- (void)configureLocationService;

- (void)startUpdatingUserLocation;

- (void)stopMonitoringGeoFences;

@end

