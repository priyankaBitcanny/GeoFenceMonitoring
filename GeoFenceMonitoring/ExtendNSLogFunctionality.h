//
//  ExtendNSLogFunctionality.h
//  ExtendNSLog
//
//  Created by Ayush Kumar Sethi on 11/04/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define NSLog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
#define NSLog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#endif

@interface ExtendNSLogFunctionality : NSObject

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

@end

