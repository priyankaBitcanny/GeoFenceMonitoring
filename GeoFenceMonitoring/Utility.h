//
//  Utility.h
//  GeoFenceMonitoring
//
//  Created by Ayush Kumar Sethi on 24/05/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Toast.h"

@interface Utility : NSObject

+(NSString *)getGeoFenceRadius;

+(void)setGeoFenceRadius:(NSString *)GeoFenceRadius;

+(NSString *)getGeoFenceAccuracy;

+(void)setGeoFenceAccuracy:(NSString *)GeoFenceRadius;

+(NSMutableDictionary *)getLatLongDic;

+(void)setLatLongDic:(NSMutableDictionary *)hubLatLongDic;

+(NSMutableDictionary *)getStatusDic;

+(void)setStatusDic:(NSMutableDictionary *)hubStatusDic;

+(NSString *)getLogStr;

+(void)setLogStr:(NSString *)logStr;

+(void)showToast:(NSString *)message;

@end
