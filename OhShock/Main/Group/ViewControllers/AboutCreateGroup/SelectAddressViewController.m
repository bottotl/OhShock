//
//  SelectAddressViewController.m
//  OhShock
//
//  Created by chenlong on 16/1/9.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "UIView+Layout.h"
#import "AddressCell.h"

#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SVProgressHUD.h"

@interface SelectAddressViewController ()<UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>

@property (assign ,nonatomic) CLLocationCoordinate2D coordinate;
@property (strong ,nonatomic) AMapSearchAPI *search;
@property (strong ,nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) BOOL hasLocation;

@end

@implementation SelectAddressViewController{
    AddressCell *selectAddress;
    UITableView *mainTableView;
    CLLocationManager *_locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(239, 239, 244);
     _dataArr=[[NSMutableArray alloc]initWithCapacity:0];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(done)];
    self.navigationItem.rightBarButtonItem = rightButton;

    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:nil options:nil];
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[AddressCell class]])
        {
            selectAddress = (AddressCell *)currentObject;
            break;
        }
    }

    selectAddress.frame = CGRectMake(0, 5, kScreen_Width, 44);
    selectAddress.layer.shadowColor = [UIColor blackColor].CGColor;
    selectAddress.layer.shadowOffset = CGSizeMake(0, 5);
    selectAddress.layer.shadowRadius = 5;
    selectAddress.layer.shadowOpacity = 0.4;
    [self.view addSubview:selectAddress];
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, kScreen_Width, kScreen_Height - 118) style:UITableViewStylePlain];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:mainTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"选择地址";
    _locationManager = (CLLocationManager *)[[AMapLocationManager alloc]init];
    _locationManager.delegate=self;
    
    [_locationManager startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    _locationManager.delegate = nil;
    _search.delegate = nil;
    [super viewDidDisappear:animated];
}

- (void)done{
    if (![self isBlankString:selectAddress.addNameLabel.text]) {
        if (_doneBlock) {
            _doneBlock(selectAddress.addNameLabel.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"还未选择地址！"];
        return;
    }
}

//判断字符串是否为空（包括全为空格）
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"addressCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    }
    cell.addNameLabel.text = [_dataArr[indexPath.row] objectForKey:@"name"];
    cell.addDetailLabel.text = [_dataArr[indexPath.row] objectForKey:@"address"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectAddress.addNameLabel.text = [_dataArr[indexPath.row] objectForKey:@"name"];
    selectAddress.addDetailLabel.text = [_dataArr[indexPath.row] objectForKey:@"address"];
}

#pragma mark location delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    if (location) {
        if (!_hasLocation) {
            _coordinate = location.coordinate;
            _hasLocation = YES;
            _search=[[AMapSearchAPI alloc]init];
            _search.delegate=self;
            //            逆地理编码搜索
            AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc]init];
            regeoRequest.location=[AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
            regeoRequest.requireExtension = YES;
            [_search AMapReGoecodeSearch:regeoRequest];
            
            //            poi搜索
            AMapPOIAroundSearchRequest *poiRequest = [[AMapPOIAroundSearchRequest alloc]init];
            poiRequest.radius = 500;
            poiRequest.location=[AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
            poiRequest.keywords = @"汽车|餐饮|商家|住宅|普通地名|生活|医院|风景|政府|金融";
            poiRequest.sortrule = 0;
            [_search AMapPOIAroundSearch:poiRequest  ];
        }
    }
}

//逆地理编码搜索回调
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    NSString *city,*district,*street;
    city = response.regeocode.addressComponent.city ;
    district = response.regeocode.addressComponent.district;
    street = response.regeocode.addressComponent.streetNumber.street;
    if (city == nil || [city isEqualToString:@"(null)"] || [city isEqualToString:@"null"]) {
        city = @"";
    }
    if (district == nil || [district isEqualToString:@"(null)"] || [district isEqualToString:@"null"]) {
        district = @"";
    }
    if (street == nil || [street isEqualToString:@"(null)"] || [street isEqualToString:@"null"]) {
        street = @"";
    }
    
    selectAddress.addNameLabel.text=[NSString stringWithFormat:@"%@%@%@",city,district,street];
    selectAddress.addDetailLabel.text=response.regeocode.formattedAddress;
}

//poi搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if(response.pois.count == 0)
    {
        return;
    }
    
    for (AMapPOI *info in response.pois)
    {
        if (info.address == nil ||[info.address isEqualToString:@""]) {
            info.address = info.name;
        }
        NSDictionary *dic = @{@"name":info.name,@"address":info.address};
        [_dataArr addObject:dic];
    }
    [mainTableView reloadData];
}



@end
