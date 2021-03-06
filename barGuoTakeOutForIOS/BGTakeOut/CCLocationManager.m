//
//  CCLocationManager.m
//  MMLocationManager
//
//  Created by WangZeKeJi on 14-12-10.
//  Copyright (c) 2014年 Chen Yaoqiang. All rights reserved.
//

#import "CCLocationManager.h"
#import "Toolkit.h"
@interface CCLocationManager (){
    CLLocationManager *_manager;

}
@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;

@end

@implementation CCLocationManager



+ (CCLocationManager *)shareLocation{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:CCLastLongitude];
        float latitude = [standard floatForKey:CCLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:CCLastCity];
        self.lastAddress=[standard objectForKey:CCLastAddress];
    }
    return self;
}
//获取经纬度
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}
//获取省市
- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

//- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
//{
//    self.cityBlock = [cityBlock copy];
//    self.errorBlock = [errorBlock copy];
//    [self startLocation];
//}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    

    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if (placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             _lastCity = [NSString stringWithFormat:@"%@",placemark.locality];
             [standard setObject:_lastCity forKey:CCLastCity];//省市地址
//             NSLog(@"______%@",_lastCity);

             _lastAddress = [NSString stringWithFormat:@"%@%@%@%@",placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare];//详细地址
//             NSLog(@"______%@",_lastAddress);


         }
         if (_cityBlock) {
             _cityBlock(_lastCity);
             _cityBlock = nil;
         }
         if (_addressBlock) {
             _addressBlock(_lastAddress);
             _addressBlock = nil;
         }

         
     }];
    
    _lastCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude ,newLocation.coordinate.longitude );
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }

//    NSLog(@"%f--%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    [standard setObject:@(newLocation.coordinate.latitude) forKey:CCLastLatitude];
    [standard setObject:@(newLocation.coordinate.longitude) forKey:CCLastLongitude];

    [manager stopUpdatingLocation];
    
}


-(void)startLocation
{
//    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
//    {
        _manager=[[CLLocationManager alloc]init];
//        _manager.delegate=self;
//        _manager.desiredAccuracy = kCLLocationAccuracyBest;
//        if ([Toolkit isSystemIOS8]) {
//            [_manager requestAlwaysAuthorization];
//        }
//        
//        _manager.distanceFilter=100;
//        [_manager startUpdatingLocation];
    
        // 如果定位服务可用
        if([CLLocationManager locationServicesEnabled])
        {
            DLog( @"开始执行定位服务" );
            // 设置定位精度：最佳精度
            _manager.desiredAccuracy = kCLLocationAccuracyBest;
            // 设置距离过滤器为0米，表示每移动50米更新一次位置
            _manager.distanceFilter = kCLDistanceFilterNone;
            // 将视图控制器自身设置为CLLocationManager的delegate
            // 因此该视图控制器需要实现CLLocationManagerDelegate协议
            _manager.delegate = self;
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
                    
                    [_manager requestAlwaysAuthorization];
                }
                
            }
            // 开始监听定位信息
            [_manager startUpdatingLocation];
        }
        else
        {
            DLog( @"无法使用定位服务！" );
        }
//    }
//    else
//    {
//        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alvertView show];
//        
//    }
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];

}
-(void)stopLocation
{
    _manager = nil;
}



@end
