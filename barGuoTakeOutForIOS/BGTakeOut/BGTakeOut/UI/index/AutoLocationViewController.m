//
//  AutoLocationViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/20.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "AutoLocationViewController.h"
#import "CCLocationManager.h"
#import "DataProvider.h"
#import "CommenDef.h"
#import "AppDelegate.h"

#define kSWidth self.view.bounds.size.width
#define kSHeight self.view.bounds.size.height
#define KAreaListHeight 50
#define KAreaListY 121
#define Kleft self.view.bounds.size.width/8
#define KScrollHeight 300

@interface AutoLocationViewController ()
@property (nonatomic,strong)UIButton * autoLocation;
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@property(nonatomic ,strong)UIButton * sender;
@property(nonatomic,strong)UIButton * selectArea;//手动选择地区
@property(nonatomic,strong)UIView * SelectView;


@end

@implementation AutoLocationViewController
{
    NSString * province;//省份
    NSString * city;//市
    NSString *district;//县区
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加导航栏
    [self addLeftButton:@"ic_actionbar_back.png"];
    
#pragma mark 添加手动切换按钮
    UIView * lastObject=[self.view.subviews lastObject];
    CGFloat y=lastObject.frame.size.height;
    CGFloat h=60*kSHeight/568;
    _selectArea=[[UIButton alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20 , kSWidth, h)];
    _selectArea.backgroundColor=[UIColor whiteColor];
    _selectArea.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [_selectArea setTitle:@"    手动切换省 市 区 街道" forState:UIControlStateNormal];
    [_selectArea setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectArea addTarget:self action:@selector(GetAreaList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectArea];
    
    #pragma mark 添加手动输入送餐地址按钮
    lastObject=[self.view.subviews lastObject];
    y=lastObject.frame.size.height+lastObject.frame.origin.y+1;
    UIButton * selectAreaPsn=[[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth, h)];
    selectAreaPsn.backgroundColor=[UIColor whiteColor];
    selectAreaPsn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [selectAreaPsn setTitle:@"    详细送餐地址" forState:UIControlStateNormal];
    [selectAreaPsn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:selectAreaPsn];
    
    #pragma mark添加切换地址
    lastObject=[self.view.subviews lastObject];
    y=lastObject.frame.size.height+lastObject.frame.origin.y+1;
    UIView * backgroundview =[[UIView alloc] initWithFrame:CGRectMake(0, y, kSWidth, h)];
    backgroundview.backgroundColor=[UIColor whiteColor];
    UIButton * changeAdress=[[UIButton alloc] initWithFrame:CGRectMake(15, 10, kSWidth-30, 40)];
    changeAdress.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    [changeAdress setTitle:@"切换地址" forState:UIControlStateNormal];
    [changeAdress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backgroundview addSubview:changeAdress];
    [self.view addSubview:backgroundview];
    
    #pragma mark添加自动定位按钮
    lastObject=[self.view.subviews lastObject];
    y=lastObject.frame.size.height+lastObject.frame.origin.y+5;
    _autoLocation=[[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth, h-20)];
    _autoLocation.backgroundColor=[UIColor whiteColor];
    [_autoLocation setImage:[UIImage imageNamed:@"Image-3"] forState:UIControlStateNormal];
    _autoLocation.imageEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 280);
    _autoLocation.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [_autoLocation setTitle:@"      自动定位" forState:UIControlStateNormal];
    [_autoLocation setTitleColor:[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_autoLocation addTarget:self action:@selector(AutoGetLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_autoLocation];
    
    #pragma mark 添加历史纪录按钮
    lastObject=[self.view.subviews lastObject];
    y=lastObject.frame.size.height+lastObject.frame.origin.y+5;
    UIButton * historyLocation=[[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth, h-30)];
    historyLocation.backgroundColor=[UIColor whiteColor];
    historyLocation.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [historyLocation setTitle:@"  历史记录" forState:UIControlStateNormal];
    [historyLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:historyLocation];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
#pragma mark 自动定位
-(void)AutoGetLocation
{
    [[CCLocationManager shareLocation] getAddress:^(NSString *addressString) {
        NSRange range=[addressString rangeOfString:@"中国"];
        [_mynavigationItem setTitle:[addressString substringFromIndex:range.length+range.location]];
    }];
}

#pragma mark 获取数据
-(void)GetAreaList
{
    _SelectView =[[UIView alloc] initWithFrame:CGRectMake(Kleft, KAreaListY, kSWidth/4*3, KScrollHeight+40)];
    DataProvider * dataProvider =[[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"BulidAreaList:"];
    [dataProvider GetArea:@"" andareatype:@"0"];
}
#pragma mark 新建地区选择view
-(void)BulidAreaList:(id)dict
{
    UIScrollView * areaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSWidth/4, KScrollHeight)];
    areaScroll.scrollEnabled=YES;
    areaScroll.backgroundColor=[UIColor grayColor];
    id result =dict;
    if (result) {
        NSArray * areaArray =[[NSArray alloc ] initWithArray:result[@"data"]];
        for (int i=0; i<areaArray.count; i++) {
            UIButton * areaitem=[[UIButton alloc] initWithFrame:CGRectMake(0, i*(KAreaListHeight+1), kSWidth/4, KAreaListHeight)];
            areaitem.backgroundColor=[UIColor whiteColor];
            [areaitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [areaitem setTitle:[NSString stringWithFormat:@"%@",areaArray[i][@"provinceName"]] forState:UIControlStateNormal];
            areaitem.tag=[areaArray[i][@"provinceId"] intValue];
            [areaitem addTarget:self action:@selector(AreaItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [areaScroll addSubview:areaitem];
        }
        areaScroll.contentSize=CGSizeMake(0, areaArray.count*(KAreaListHeight+1));
    }
    [_SelectView addSubview:areaScroll];
    [self.view addSubview:_SelectView];
}

#pragma mark 选择省份事件
-(void)AreaItemClick:(UIButton *)sender
{
    
    NSArray * superarray= sender.superview.subviews;
    for (UIView * item in superarray) {
        if ([item isKindOfClass:[UIButton class]]) {
            UIButton * items=(UIButton *)item;
            if(item.tag!=sender.tag)
            {
                item.backgroundColor=sender.backgroundColor;
                [items setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
    sender.backgroundColor=[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    DataProvider * dataProvider =[[DataProvider alloc] init];
    NSString * str=[NSString stringWithFormat:@"00%ld",(long)sender.tag];
    switch (str.length) {
        case 6:
            province=[NSString stringWithFormat:@"%@——",sender.currentTitle];
            [dataProvider setDelegateObject:self setBackFunctionName:@"SecondBulidAreaList:"];
            [dataProvider GetArea:str andareatype:@"1"];
            break;
        case 9:
            city=[NSString stringWithFormat:@"%@——",sender.currentTitle];
            [dataProvider setDelegateObject:self setBackFunctionName:@"ThridBulidAreaList:"];
            [dataProvider GetArea:str andareatype:@"2"];
            break;
        case 12:
        {
            district= sender.currentTitle;
            NSLog(@"00%ld",(long)sender.tag);
            UIButton * submitArea=[[UIButton alloc] initWithFrame:CGRectMake(0,300, kSWidth/4*3, 40)];
            submitArea.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
            [submitArea setTitle:@"确定" forState:UIControlStateNormal];
            [submitArea addTarget:self action:@selector(submitAreaClick:) forControlEvents:UIControlEventTouchUpInside];
            [_SelectView addSubview:submitArea];
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark 创建市列表
-(void)SecondBulidAreaList:(id)dict
{
    UIScrollView * CityareaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(kSWidth/4, 0, kSWidth/4, KScrollHeight)];
    CityareaScroll.scrollEnabled=YES;
    CityareaScroll.backgroundColor=[UIColor grayColor];
    id result =dict;
    if (result) {
        NSArray * areaArray =[[NSArray alloc ] initWithArray:result[@"data"]];
        for (int i=0; i<areaArray.count; i++) {
            UIButton * areaitem=[[UIButton alloc] initWithFrame:CGRectMake(0, i*(KAreaListHeight+1), kSWidth/4, KAreaListHeight)];
            areaitem.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
            [areaitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [areaitem setTitle:[NSString stringWithFormat:@"%@",areaArray[i][@"cityName"]] forState:UIControlStateNormal];
            areaitem.tag=[areaArray[i][@"cityId"] intValue];
            [areaitem addTarget:self action:@selector(AreaItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [CityareaScroll addSubview:areaitem];
        }
        CityareaScroll.contentSize=CGSizeMake(0, areaArray.count*(KAreaListHeight+1));
    }
    [_SelectView addSubview:CityareaScroll];
    
}

#pragma mark 创建县区列表
-(void)ThridBulidAreaList:(id)dict
{
    UIScrollView * ThirdareaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(kSWidth/2, 0, kSWidth/4, KScrollHeight)];
    ThirdareaScroll.scrollEnabled=YES;
    ThirdareaScroll.backgroundColor=[UIColor grayColor];
    id result =dict;
    if (result) {
        NSArray * areaArray =[[NSArray alloc ] initWithArray:result[@"data"]];
        for (int i=0; i<areaArray.count; i++) {
            UIButton * areaitem=[[UIButton alloc] initWithFrame:CGRectMake(0, i*(KAreaListHeight+1), kSWidth/4, KAreaListHeight)];
            areaitem.backgroundColor=[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
            [areaitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [areaitem setTitle:[NSString stringWithFormat:@"%@",areaArray[i][@"districtName"]] forState:UIControlStateNormal];
            areaitem.tag=[areaArray[i][@"districtId"] intValue];
            [areaitem addTarget:self action:@selector(AreaItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [ThirdareaScroll addSubview:areaitem];
        }
        ThirdareaScroll.contentSize=CGSizeMake(0, areaArray.count*(KAreaListHeight+1));
    }
    [_SelectView addSubview:ThirdareaScroll];
}

#pragma mark 提交选定的地区
-(void)submitAreaClick:(UIButton *)sender
{
//    NSLog(@"SUBMIT%@",province);
//    NSLog(@"SUBMIT%@",city);
//    NSLog(@"SUBMIT%@",district);
    NSString *lastArea=[NSString stringWithFormat:@"%@%@%@",province,city,district];
    [_selectArea setTitle:lastArea forState:UIControlStateNormal];
    _selectArea.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    
    [sender.superview removeFromSuperview];
}



#pragma mark 返回按钮
-(void)clickLeftButton
{
    [self.view removeFromSuperview];
}

@end