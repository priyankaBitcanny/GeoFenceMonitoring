//
//  Utility.m
//  GeoFenceMonitoring
//
//  Created by Ayush Kumar Sethi on 24/05/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"

@implementation Utility

+(NSString *)getGeoFenceRadius{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"GeoFenceRadius"];
}

+(void)setGeoFenceRadius:(NSString *)GeoFenceRadius{
    [[NSUserDefaults standardUserDefaults] setObject:GeoFenceRadius forKey:@"GeoFenceRadius"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString *)getGeoFenceAccuracy{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"GeoFenceAccuracy"];
}

+(void)setGeoFenceAccuracy:(NSString *)GeoFenceRadius{
    [[NSUserDefaults standardUserDefaults] setObject:GeoFenceRadius forKey:@"GeoFenceAccuracy"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSMutableDictionary *)getLatLongDic{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"LatLongDic"];
}

+(void)setLatLongDic:(NSMutableDictionary *)hubLatLongDic{
    [[NSUserDefaults standardUserDefaults] setObject:hubLatLongDic forKey:@"LatLongDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSMutableDictionary *)getStatusDic{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"StatusDic"];
}

+(void)setStatusDic:(NSMutableDictionary *)hubStatusDic{
    [[NSUserDefaults standardUserDefaults] setObject:hubStatusDic forKey:@"StatusDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString *)getLogStr{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"logStr"];
}

+(void)setLogStr:(NSString *)logStr{
    [[NSUserDefaults standardUserDefaults] setObject:logStr forKey:@"logStr"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void)showToast:(NSString *)message{
    // Make toast with a duration and position
    CSToastStyle *style = [CSToastManager sharedStyle];
    style.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    style.titleColor = [UIColor whiteColor];
    style.messageColor = [UIColor whiteColor];
    style.verticalPadding = 10;
    style.verticalMarginOffset = 0;
    style.enableFullScreenWidth = NO;
    style.cornerRadius = 10.0;
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate.window.rootViewController.view makeToast:message
                                                 duration:2.0
                                                 position:CSToastPositionBottom style:style];
}

@end
