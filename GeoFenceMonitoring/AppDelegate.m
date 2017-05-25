//
//  AppDelegate.m
//  GeoFenceMonitoring
//
//  Created by Ayush Kumar Sethi on 24/05/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import "AppDelegate.h"
#import "Utility.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize currentLocation,isUpdatingFromHome;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDictionary* locationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey];
    if (locationInfo != nil){
        NSLog(@"App luanched for location info %@",locationInfo);
        [self configureLocationService];
    }
    else{
        NSLog(@"App luanched normally");
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
            [application registerUserNotificationSettings:settings];
        }
        
        if(![Utility getGeoFenceRadius]){
            [Utility setGeoFenceRadius:@"130"];
        }
        if(![Utility getGeoFenceAccuracy]){
            [Utility setGeoFenceAccuracy:@"4.0"];
        }
        self.fenceRadius = [[Utility getGeoFenceRadius] floatValue];
        self.fenceAccuracy = [[Utility getGeoFenceAccuracy] floatValue];
        isUpdatingFromHome = @"0";
    }
    
    
    
    
    return YES;
}

#pragma mark - Local Notification

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"didReceiveLocalNotification");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


#pragma mark - Core Location

-(void)initialiseLocationManager{
    NSLog(@"initialiseLocationManager");
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    self.locationManager.allowsBackgroundLocationUpdates=YES;
    [self setLocationManagerAccuracy];
}

- (void)configureLocationService
{
    NSLog(@"configureLocationService");
    if (!self.locationManager) {
        [self initialiseLocationManager];
    }
    
    switch ([CLLocationManager authorizationStatus])
    {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.locationManager requestAlwaysAuthorization];
            }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self showAlertViewWithTitle:@"Sorry" andMessage:@"Location Services are not enabled on this device."];
            break;
            
    }
}

-(BOOL)isLocationServiceEnabled
{
    BOOL isEnabled = NO;
    if ([CLLocationManager locationServicesEnabled])
    {
        switch ([CLLocationManager authorizationStatus])
        {
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:
            case kCLAuthorizationStatusNotDetermined:
                break;
                
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                isEnabled = YES;
                break;
                
            default:
                break;
        }
    }
    NSLog(@"isLocationServiceEnabled %d",isEnabled);
    return isEnabled;
}

- (void)startUpdatingUserLocation{
    
    currentLocation = nil;
    NSLog(@"startUpdatingUserLocation");
    if([self isLocationServiceEnabled]){
        NSLog(@"LocationServiceEnabled startUpdating");
        if (!self.locationManager) {
            [self initialiseLocationManager];
        }
        [self.locationManager startUpdatingLocation];
    }
    else{
        NSLog(@"LocationService not Enabled");
        if ([CLLocationManager locationServicesEnabled]){
            if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
                [self configureLocationService];
            }
        }
    }
}

- (void)stopMonitoringGeoFences{
    NSLog(@"region count %ld",[self.locationManager.monitoredRegions count]);
    if([self isLocationServiceEnabled]){
        if (!self.locationManager) {
            [self initialiseLocationManager];
        }
        //-----------
        for (CLRegion* region in self.locationManager.monitoredRegions)
        {
            [self.locationManager stopMonitoringForRegion:region];
            break;
        }
        //-----------
    }
    else{
        if ([CLLocationManager locationServicesEnabled]){
            if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
                [self configureLocationService];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)locstatus {
    NSLog(@"didChangeAuthorizationStatus %d",locstatus);
    switch (locstatus) {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusDenied: {
            [self.locationManager stopUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            break;
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self.locationManager startUpdatingLocation];
        }
            break;
        default:
            break;
    }
}

-(void)setLocationManagerAccuracy{
    
    if (self.fenceAccuracy == 1.0)
    {
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    }
    else if (self.fenceAccuracy == 2.0)
    {
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    else if (self.fenceAccuracy == 3.0)
    {
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
    else if (self.fenceAccuracy == 4.0)
    {
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    }
    else if (self.fenceAccuracy == 5.0)
    {
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    }
    else if (self.fenceAccuracy == 6.0)
    {
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    }
    else
    {
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    NSLog(@"Location manager - distanceFilter : %f self.fenceAccuracy %f accuracySetTo : %f meters",self.locationManager.distanceFilter,self.fenceAccuracy,self.locationManager.desiredAccuracy);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    
    CLLocationDistance distanceThreshold = 2.0; // in meters
    if (!currentLocation || [currentLocation distanceFromLocation:newLocation] > distanceThreshold)
    {
        NSLog(@"Got location");
        currentLocation = newLocation;
        [self.locationManager stopUpdatingLocation];
        NSLog(@"stopUpdatingLocation");
        if([isUpdatingFromHome isEqualToString:@"1"]){
            NSLog(@"Got location to isUpdatingFromHome");
            isUpdatingFromHome = @"0";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationSetCurrentLocation" object:nil];
        }
        else{
            NSLog(@"Got location to setUpGeofences");
            [self setUpGeofences];
        }
        
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Started Monitoring for region : %@", region.identifier);
    //[self.locationManager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(nullable CLRegion *)region
              withError:(NSError *)error{
    NSLog(@"updateRadius : Monitoring Failed for region : %@ with error : %@", region.identifier,error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"updateRadius : Location manager - distanceFilter : %f accuracy : %f",manager.distanceFilter,manager.desiredAccuracy);
    [self showNotificationForRegion:region andType:@"entered" andRadius:YES];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"updateRadius : Location manager - distanceFilter : %f accuracy : %f",manager.distanceFilter,manager.desiredAccuracy);
    [self showNotificationForRegion:region andType:@"exited" andRadius:NO];
}

- (void)showNotificationForRegion:(CLRegion*)region andType:(NSString*)notifType andRadius:(BOOL)radius
{
    
    NSString *hubOccupantSettings = region.identifier;
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive) {
        NSLog(@"[Debug]:Geofence: %@ region:%@",notifType,region.identifier);
        //App is in foreground. Act on it.
        [self showAlertViewWithTitle:@"" andMessage:[NSString stringWithFormat:@"You have %@ the region for %@" , notifType , hubOccupantSettings]];
    }
    else{
        NSLog(@"[Debug]:Geofence: %@ region:%@",notifType,region.identifier);
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        localNotification.alertBody = [NSString stringWithFormat:@"You have %@ the region for %@" , notifType , hubOccupantSettings];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }

    
}

- (void)setUpGeofences
{
    
    if (![self isLocationServiceEnabled]) {
        NSLog(@"setUpGeofences not executed");
        return;
    }
    
    [self setLocationManagerAccuracy];
    
    NSMutableDictionary * latLongDic = [[NSMutableDictionary alloc] initWithDictionary:[Utility getLatLongDic]];
    
    NSArray *homeList = [latLongDic allKeys];
    
    NSLog(@"setUpGeofences homeList %@ self.locationManager.monitoredRegions %@",homeList,self.locationManager.monitoredRegions);
    
    for (int i=0; i<[homeList count]; i++)
    {
        NSString * home = [homeList objectAtIndex:i];
        BOOL shallFormNewRegion = YES;
        
        NSLog(@"index %d home %@",i,home);
        
        for (CLRegion* region in self.locationManager.monitoredRegions)
        {
            NSLog(@"region.identifier %@",region.identifier);
            
            if ([region.identifier isEqualToString:home]) {
                
                NSLog(@"identifier matched %@",home);
                
                NSArray * latlongArr = [[latLongDic objectForKey:home] componentsSeparatedByString:@","];
                
                CLLocationCoordinate2D center1 = CLLocationCoordinate2DMake([[latlongArr objectAtIndex:0] floatValue], [[latlongArr objectAtIndex:1] floatValue]);
                
                CLLocationCoordinate2D center2 = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude);
                
                if (!CLLocationCoordinateEqual(center1, center2)) {
                    NSLog(@"center mismatched home %@",home);
                    [self.locationManager stopMonitoringForRegion:region];
                    shallFormNewRegion = YES;
                }
                else{
                    NSLog(@"center matched home %@",home);
                    shallFormNewRegion = NO;
                    [self checkRegionStatus:region];
                }
                
                break;
            }
        }
        
        if (shallFormNewRegion) {
            [self createNewRegionToTrack:home];
        }
    }
    
    NSMutableArray *arrRegionIdentifiers = [[NSMutableArray alloc] init];
    for (CLRegion* region in self.locationManager.monitoredRegions)
        [arrRegionIdentifiers addObject:region.identifier];
    
    NSMutableArray *arrCurrentRegionIdentifiers = [[NSMutableArray alloc] init];
    for (NSString* key in homeList)
        [arrCurrentRegionIdentifiers addObject:key];
    
    NSMutableSet *setOld = [NSMutableSet setWithArray:arrRegionIdentifiers];
    NSMutableSet *setNew = [NSMutableSet setWithArray:arrCurrentRegionIdentifiers];
    //Finding deleted Devices
    [setOld minusSet:setNew];
    
    NSArray *arrDeletedDevices = [setOld allObjects];
    for (NSString* entityId in arrDeletedDevices){
        for (CLRegion* region in self.locationManager.monitoredRegions){
            if ([region.identifier isEqualToString:entityId]) {
                [self.locationManager stopMonitoringForRegion:region];
                break;
            }
        }
    }
}


BOOL CLLocationCoordinateEqual(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2)
{
    return (fabs(coordinate1.latitude - coordinate2.latitude) <= DBL_EPSILON &&
            fabs(coordinate1.longitude - coordinate2.longitude) <= DBL_EPSILON);
}


-(void)createNewRegionToTrack:(NSString *)home{
    
    NSLog(@"createNewRegionToTrack");
    
    NSMutableDictionary * latLongDic = [[NSMutableDictionary alloc] initWithDictionary:[Utility getLatLongDic]];
    NSArray * latlongArr = [[latLongDic objectForKey:home] componentsSeparatedByString:@","];
    
    NSLog(@"createNewRegionToTrack home %@ latlongArr %@",home,latlongArr);
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([[latlongArr objectAtIndex:0] floatValue], [[latlongArr objectAtIndex:1] floatValue]);
    
    CLRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:self.fenceRadius identifier:home];
    
    if([CLLocationManager isMonitoringAvailableForClass:[CLRegion class]])
    {
        NSLog(@"Monitoring Available");
        [self.locationManager startMonitoringForRegion:region];
    }
    else{
        NSLog(@"Monitoring NOT Available");
    }
    [self checkRegionStatus:region];
    
}

-(void)checkRegionStatus:(CLRegion *)region{
    
    NSLog(@"Checking status for %@",region.identifier);
    
    NSString * statusStr = @"exited";
    if ([region containsCoordinate:CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)]) {
        statusStr = @"entered";
    }
    
    NSLog(@"Checked status %@ for %@",statusStr,region.identifier);
    
    //App is in foreground. Act on it.
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    
    if (state == UIApplicationStateActive) {
        //App is in foreground. Act on it.
        [self showAlertViewWithTitle:@"" andMessage:[NSString stringWithFormat:@"You have %@ the region for %@" ,statusStr,region.identifier]];
    }
    else{
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = [NSString stringWithFormat:@"You have %@ the region for %@",statusStr ,region.identifier];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

- (void)clearGeofences
{
    NSLog(@"clearGeofences");
    if (!self.locationManager) {
        [self initialiseLocationManager];
    }
    
    for (CLRegion* region in self.locationManager.monitoredRegions){
        [self.locationManager stopMonitoringForRegion:region];
    }
}


- (void)showAlertViewWithTitle:(NSString*)title andMessage:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    
    
    [alertView show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
