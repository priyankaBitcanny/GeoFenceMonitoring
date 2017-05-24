//
//  Utility.m
//  GeoFenceMonitoring
//
//  Created by Ayush Kumar Sethi on 24/05/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import "Utility.h"

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

+(void)setLatLongDic:(NSMutableDictionary *)hubStatusTimingDic{
    [[NSUserDefaults standardUserDefaults] setObject:hubStatusTimingDic forKey:@"LatLongDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end
