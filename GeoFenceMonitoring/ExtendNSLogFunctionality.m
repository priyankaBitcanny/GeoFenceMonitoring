//
//  ExtendNSLogFunctionality.m
//  ExtendNSLog
//
//  Created by Ayush Kumar Sethi on 11/04/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import "ExtendNSLogFunctionality.h"
#import "Utility.h"

@implementation ExtendNSLogFunctionality



void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...)
{
    // Type to hold information about variable arguments.
    va_list ap;
    
    // Initialize a variable argument list.
    va_start (ap, format);
    
    // NSLog only adds a newline to the end of the NSLog format if
    // one is not already there.
    // Here we are utilizing this feature of NSLog()
    if (![format hasSuffix: @"\n"]){
        format = [format stringByAppendingString: @"\n"];
    }
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    
    // End using variable argument list.
    va_end (ap);
    
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    fprintf(stderr, "(%s) (%s:%d) %s",
            functionName, [fileName UTF8String],
            lineNumber, [body UTF8String]);
    NSDateFormatter * globalDF = [[NSDateFormatter alloc] init];
    [globalDF setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
    
    [Utility setLogStr:[NSString stringWithFormat:@"%@\n%@[%@]\n",[Utility getLogStr],body,[globalDF stringFromDate:[NSDate date]]]];
    
}

@end
