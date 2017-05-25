//
//  ViewController.m
//  GeoFenceMonitoring
//
//  Created by Ayush Kumar Sethi on 24/05/17.
//  Copyright © 2017 BitCanny. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Utility.h"

@interface ViewController (){
AppDelegate * appDelegate;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCurrentLocation) name:@"NotificationSetCurrentLocation" object:nil];
    
    self.hubnameTF.delegate=self;
    self.currLocTF.delegate=self;
    
    //------- picker----------
    self.accuracyArray=[[NSMutableArray alloc] initWithObjects:@"AccuracyBestForNavigation",@"AccuracyBest",@"AccuracyNearestTenMeters",@"AccuracyHundredMeters",@"AccuracyKilometer",@"AccuracyThreeKilometers", nil];
    appDelegate.fenceAccuracy = [[Utility getGeoFenceAccuracy] floatValue];
    selectedAccuracyIndex=(int)(appDelegate.fenceAccuracy-1.0);
    NSLog(@"selectedAccuracyIndex %ld",selectedAccuracyIndex);
    self.picVw.delegate=self;
    self.picVw.dataSource=self;
    [self.picVw selectRow:selectedAccuracyIndex inComponent:0 animated:YES];
    
    //------tableview--------
    self.latLongDic = [[NSMutableDictionary alloc] initWithDictionary:[Utility getLatLongDic]];
    NSLog(@"\n startUpdatingUserLocation from didload");
    appDelegate.needToSetUpGeofence = @"1";
    [appDelegate startUpdatingUserLocation];
    self.hubTableView.delegate=self;
    self.hubTableView.dataSource=self;
    [self.hubTableView reloadData];
    
}

#pragma mark - Dismiss Keyboard
-(void)dismissAllKeyboard {
    [self.currLocTF resignFirstResponder];
    [self.hubnameTF resignFirstResponder];
}
#pragma mark - TextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.currLocTF) {
        [self.hubnameTF becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)setCurrentLocation{
    self.currLocTF.text = [NSString stringWithFormat:@"%f,%f",appDelegate.currentLocation.coordinate.latitude,appDelegate.currentLocation.coordinate.longitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)CurrLocOnClick:(id)sender {
    NSLog(@"\n startUpdatingUserLocation on CurrLocOnClick");
    appDelegate.isUpdatingFromHome = @"1";
    [appDelegate startUpdatingUserLocation];
}

- (IBAction)createHubOnClick:(id)sender {
    
    if(self.currLocTF.text.length!=0 && self.hubnameTF.text.length!=0){
        [self.latLongDic setObject:self.currLocTF.text forKey:self.hubnameTF.text];
        [Utility setLatLongDic:self.latLongDic];
        NSLog(@"\n startUpdatingUserLocation on creating hub");
        appDelegate.needToSetUpGeofence = @"1";
        [appDelegate startUpdatingUserLocation];
        self.currLocTF.text=@"";
        self.hubnameTF.text=@"";
        [self showAlertViewWithTitle:@"Hub added" andMessage:@"Monitoring started for added hub"];
        [self.hubTableView reloadData];
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

#pragma mark- PickerViewdelegate

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.accuracyArray.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.accuracyArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    selectedAccuracyIndex=row;
    
    NSLog(@"Accuracy set to %@",[self.accuracyArray objectAtIndex:selectedAccuracyIndex]);
    appDelegate.fenceAccuracy = (selectedAccuracyIndex + 1) * 1.0;
    [Utility setGeoFenceAccuracy:[NSString stringWithFormat:@"%f",appDelegate.fenceAccuracy]];
    
    [appDelegate stopMonitoringGeoFences];
    NSLog(@"\n startUpdatingUserLocation accuracy changed");
    appDelegate.needToSetUpGeofence = @"1";
    [appDelegate startUpdatingUserLocation];
}


#pragma mark- UITableViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // We only have one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.latLongDic allKeys] count];
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat width = CGRectGetWidth(tableView.bounds);
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,height)] ;
    container.backgroundColor=[UIColor colorWithRed:(55/255.0) green:(55/255.0) blue:(55/255.0) alpha:1.0];
    //container.layer.borderWidth=1.0;
    
    UILabel *SlNoLbl =  [[UILabel alloc] init];
    
    NSMutableArray * headerArr;
    headerArr = [[NSMutableArray alloc] initWithObjects:@"Home",@"Latitude-Longitude", nil];
    
    float startX=0;
    float widthVal=tableView.frame.size.width/[headerArr count];
    for (int i=0; i<[headerArr count]; i++) {
        if(i==0){
            widthVal=100;
        }
        else{
            widthVal=tableView.frame.size.width-100;
        }
        SlNoLbl =  [[UILabel alloc] init];
        SlNoLbl.frame=CGRectMake(startX, 0, widthVal, height);
        SlNoLbl.text = [headerArr objectAtIndex:i];
        SlNoLbl.numberOfLines=2;
        SlNoLbl.backgroundColor=[UIColor clearColor];
        SlNoLbl.font=[UIFont boldSystemFontOfSize:14.0];
        SlNoLbl.textColor=[UIColor whiteColor];
        SlNoLbl.layer.borderColor=[UIColor grayColor].CGColor;
        SlNoLbl.layer.borderWidth=.5;
        [container addSubview:SlNoLbl];
        startX+=widthVal;
    }
    
    return container;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HomeTableViewCell";
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    cell.homeLbl.text = [[self.latLongDic allKeys] objectAtIndex:indexPath.row];
    cell.latLongLbl.text = [self.latLongDic objectForKey:[[self.latLongDic allKeys] objectAtIndex:indexPath.row]];
    
    cell.homeLbl.backgroundColor=[UIColor colorWithRed:(211/255.0) green:(211/255.0) blue:(211/255.0) alpha:1.0];;
    cell.homeLbl.layer.borderColor=[UIColor grayColor].CGColor;
    cell.homeLbl.layer.borderWidth=.5;
    
    cell.latLongLbl.backgroundColor=[UIColor colorWithRed:(211/255.0) green:(211/255.0) blue:(211/255.0) alpha:1.0];
    cell.latLongLbl.layer.borderColor=[UIColor grayColor].CGColor;
    cell.latLongLbl.layer.borderWidth=.5;

    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath.row;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Would you like delete home?"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete",nil];
    [alertView show];
}

#pragma mark- alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex %ld",buttonIndex);
    if (buttonIndex==1) {//delete
        [self.latLongDic removeObjectForKey:[[self.latLongDic allKeys] objectAtIndex:selectedIndex]];
        [Utility setLatLongDic:self.latLongDic];
        [self.hubTableView reloadData];
    }
    else{
        
    }
    
}

@end


#pragma mark - HomeTableViewCell

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end
