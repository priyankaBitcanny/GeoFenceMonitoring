//
//  ViewController.h
//  GeoFenceMonitoring
//
//  Created by Ayush Kumar Sethi on 24/05/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    long selectedAccuracyIndex;
    long selectedIndex;
}

@property (strong, nonatomic) NSMutableDictionary * latLongDic;

@property (strong, nonatomic) NSMutableArray *accuracyArray;

@property (weak, nonatomic) IBOutlet UILabel *appLbl;

@property (weak, nonatomic) IBOutlet UITextField *currLocTF;

@property (weak, nonatomic) IBOutlet UITextField *hubnameTF;

@property (weak, nonatomic) IBOutlet UITextField *radiusTF;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (weak, nonatomic) IBOutlet UIButton *addFenceBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveRadiusBtn;

@property (weak, nonatomic) IBOutlet UITableView *hubTableView;

@property (weak, nonatomic) IBOutlet UIPickerView *picVw;

- (IBAction)CurrLocOnClick:(id)sender;

- (IBAction)createHubOnClick:(id)sender;

- (IBAction)radiusOnClick:(id)sender;

- (IBAction)nextOnClick:(id)sender;

@end

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *homeLbl;

@property (weak, nonatomic) IBOutlet UILabel *latLongLbl;

@property (weak, nonatomic) IBOutlet UILabel *statusLbl;


@end
