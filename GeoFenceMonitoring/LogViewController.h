//
//  LogViewController.h
//  GeoFenceMonitoring
//
//  Created by Ayush Kumar Sethi on 30/05/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

- (IBAction)prevOnClick:(id)sender;

- (IBAction)reloDOnClick:(id)sender;

@end
