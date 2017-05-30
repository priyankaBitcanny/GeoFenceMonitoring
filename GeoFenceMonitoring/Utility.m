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

@end
