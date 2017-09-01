//
//  LogViewController.m
//  GeoFenceMonitoring
//
//  Created by Ayush Kumar Sethi on 30/05/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import "LogViewController.h"
#import "Utility.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    
    self.logTextView.text = [Utility getLogStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)prevOnClick:(id)sender {
    [Utility setLogStr:@""];
    self.logTextView.text = [Utility getLogStr];
}

- (IBAction)reloDOnClick:(id)sender {
    self.logTextView.text = [Utility getLogStr];
}
@end
