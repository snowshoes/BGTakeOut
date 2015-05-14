//
//  OtherOfMineViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/7.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "OtherOfMineViewController.h"
#import "DataProvider.h"
#import "CommenDef.h"
#import "AppDelegate.h"

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height

@interface OtherOfMineViewController ()
@end

@implementation OtherOfMineViewController
{
    UILabel *companyshow;
    
    UITextView * tousu;
    UILabel * uilabel;
    UILabel * lbl_zishu;
    UIButton * btn_tousu;
    
    
    UILabel * lbl_SetgroupTitle;
    UIView *pushMsg;
    UILabel *lbl_pushMsg;
    UIView *zixunTel;
    UILabel *lal_zixunTel;
    UILabel *lbl_About;
    UIView * banbenNow;
    UILabel * lbl_banbenNow;
    UIView * yijian;
    UILabel * lbl_yijian;
    UIButton * logout;
    UILabel * lbl_zhongyang;
    UILabel * lbl_banquanfuhao;
    
    UITextView * zhiwei;
    UITextView * zhaoshang;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self addLeftButton:@"ic_actionbar_back.png"];
    [self setBarTitle:_Othertitle];
    
    
    switch (_celltag) {
        case 0:
            
            break;
        case 1:
            companyshow=[[UILabel alloc] initWithFrame:CGRectMake(10, NavigationBar_HEIGHT+30, KWidth-20, KHeight-NavigationBar_HEIGHT-40)];
            companyshow.text=@"公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介";
            companyshow.lineBreakMode=UILineBreakModeWordWrap;
            companyshow.numberOfLines=0;
            companyshow.font=[UIFont fontWithName:@"Helvetica" size:14];
            companyshow.backgroundColor=[UIColor whiteColor];
            [self.view addSubview:companyshow];
            break;
        case 2:
            tousu=[[UITextView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 80)];
            [tousu setKeyboardType:UIKeyboardTypeDefault];
            tousu.delegate=self;
            [self.view addSubview:tousu];
            
            uilabel=[[UILabel alloc] initWithFrame:CGRectMake(17, NavigationBar_HEIGHT+20+8, 100, 10)];
            uilabel.text = @"请填写投诉内容..";
            uilabel.enabled = NO;//lable必须设置为不可用
            uilabel.backgroundColor = [UIColor clearColor];
            [self.view addSubview:uilabel];
            lbl_zishu=[[UILabel alloc] initWithFrame:CGRectMake(KWidth-160, NavigationBar_HEIGHT+20+tousu.frame.size.height-30, 150, 10)];
            lbl_zishu.text=@"还能输入140个字";
            lbl_zishu.enabled=NO;
            lbl_zishu.backgroundColor=[UIColor clearColor];
            [self.view addSubview:lbl_zishu];
            btn_tousu=[[UIButton alloc] initWithFrame:CGRectMake(20, tousu.frame.origin.y+tousu.frame.size.height+10, KWidth-40, 35)];
            btn_tousu.backgroundColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
            [btn_tousu addTarget:self action:@selector(TouSuSubmit) forControlEvents:UIControlEventTouchUpInside];
            [btn_tousu setTitle:@"提交" forState:UIControlStateNormal];
            [self.view addSubview:btn_tousu];
            break;
        case 10:
            
            [self chengpin];
            
            break;
        case 11:
            [self GetZhaoShangInfo];
            break;
        case 20:
            lbl_SetgroupTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, NavigationBar_HEIGHT+20+10, 80, 15)];
            lbl_SetgroupTitle.text=@"帮助";
            [self.view addSubview:lbl_SetgroupTitle];
            pushMsg=[[UIView alloc] initWithFrame:CGRectMake(0, lbl_SetgroupTitle.frame.origin.y+lbl_SetgroupTitle.frame.size.height+2, KWidth, 40)];
            pushMsg.backgroundColor=[UIColor whiteColor];
            lbl_pushMsg=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            lbl_pushMsg.text=@"推送消息";
            [pushMsg addSubview:lbl_pushMsg];
            [self.view addSubview:pushMsg];
            zixunTel=[[UIView alloc] initWithFrame:CGRectMake(0, pushMsg.frame.origin.y+pushMsg.frame.size.height+1, KWidth, 40)];
            zixunTel.backgroundColor=[UIColor whiteColor];
            lal_zixunTel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            lal_zixunTel.text=@"咨询电话";
            [zixunTel addSubview:lal_zixunTel];
            [self.view addSubview:zixunTel];
            
            lbl_About=[[UILabel alloc] initWithFrame:CGRectMake(10, zixunTel.frame.size.height+zixunTel.frame.origin.y+10, 200, 15)];
            lbl_About.text=@"关于巴国外卖";
            [self.view addSubview:lbl_About];
            banbenNow=[[UIView alloc] initWithFrame:CGRectMake(0, lbl_About.frame.origin.y+lbl_About.frame.size.height+2, KWidth, 40)];
            banbenNow.backgroundColor=[UIColor whiteColor];
            lbl_banbenNow=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
            lbl_banbenNow.text=@"当前版本：1.1.0";
            [banbenNow addSubview:lbl_banbenNow];
            [self.view addSubview:banbenNow];
            yijian=[[UIView alloc] initWithFrame:CGRectMake(0, banbenNow.frame.origin.y+banbenNow.frame.size.height+1, KWidth, 40)];
            yijian.backgroundColor=[UIColor whiteColor];
            lbl_yijian=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            lbl_yijian.text=@"意见反馈";
            [yijian addSubview:lbl_yijian];
            [self.view addSubview:yijian];
            
            logout=[[UIButton alloc] initWithFrame:CGRectMake(40, yijian.frame.origin.y+yijian.frame.size.height+5, KWidth-80, 30)];
            logout.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
            [logout setTitle:@"退出账号" forState:UIControlStateNormal];
            [logout addTarget:self action:@selector(LogoutFuc) forControlEvents:UIControlEventTouchUpInside];
            [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.view addSubview:logout];
            
            lbl_banquanfuhao=[[UILabel alloc] initWithFrame:CGRectMake(30, KHeight-80, KWidth-60, 20)];
            lbl_banquanfuhao.text=@"Coryright©2015-2018";
            [lbl_banquanfuhao setTextAlignment:NSTextAlignmentCenter];
            lbl_banquanfuhao.font=[UIFont fontWithName:@"Helvetica" size:12];
            lbl_banquanfuhao.textColor=[UIColor grayColor];
            [self.view addSubview:lbl_banquanfuhao];
            
            lbl_zhongyang=[[UILabel alloc] initWithFrame:CGRectMake(30, KHeight-50, KWidth-60, 20)];
            lbl_zhongyang.text=@"阿克苏巴国城网络科技有限公司";
            [lbl_zhongyang setTextAlignment:NSTextAlignmentCenter];
            lbl_zhongyang.font=[UIFont fontWithName:@"Helvetica" size:12];
            lbl_zhongyang.textColor=[UIColor grayColor];
            [self.view addSubview:lbl_zhongyang];
            break;
        default:
            break;
    }
}

-(void)TouSuSubmit
{
    NSLog(@"提交投诉");
    DataProvider * dataprovider =[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitBackCall:"];
    [dataprovider SubmitTousu:tousu.text anduserid:_UserInfoData[@"userid"]];
}
-(void)textViewDidChange:(UITextView *)textView
{
    int textlength=textView.text.length ;
    if (textlength== 0) {
        uilabel.text = @"请填写投诉内容..";
    }else{
        uilabel.text = @"";
        lbl_zishu.text=[NSString stringWithFormat:@"还能输入%d个字",140-textlength];
    }
}
-(void)SubmitBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (1==[dict[@"status"] integerValue]) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                      message:NSLocalizedString(dict[@"msg"], nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)BackBtnClick
{
    [self.view removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)LogoutFuc
{
    NSDictionary * dict=[[NSDictionary alloc] init];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    //        NSString * data=[[NSString alloc] initWithFormat:dict];
    //        NSDictionary * userdata=@{@"userdata":data};
    //        NSArray * dataarray =[[NSArray alloc] initWithObjects:data, nil];
    BOOL result= [dict writeToFile:plistPath atomically:YES];
    if (result) {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"退出成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)chengpin
{
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"chengpinBackCall:"];
    [dataprovider chengpinInfo];
}
-(void)chengpinBackCall:(id)dict
{
    NSLog(@"%@",dict);
    NSArray * array=[[NSArray alloc] initWithArray:dict[@"data"]];
    for (int i=0; i<array.count; i++) {
        UIView *lastView;
        UIView * BackView_zhaopinxinxi;
        if (i==0) {
            BackView_zhaopinxinxi=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 100)];
        }
        else
        {
            lastView=[self.view.subviews lastObject];
            BackView_zhaopinxinxi=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y, SCREEN_WIDTH, 100)];
        }
        UILabel * lbl_zhiweiname=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
        lbl_zhiweiname.text=[NSString stringWithFormat:@"%d、%@",i,array[i][@"zhiwei"]];
        [BackView_zhaopinxinxi addSubview:lbl_zhiweiname];
        UILabel * lbl_zhiweicontent=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_zhiweiname.frame.size.height+10, SCREEN_WIDTH-20, 60)];
        [lbl_zhiweicontent setLineBreakMode:NSLineBreakByWordWrapping];
        lbl_zhiweicontent.numberOfLines=0;
        lbl_zhiweicontent.text=array[i][@"content"];
        [BackView_zhaopinxinxi addSubview:lbl_zhiweicontent];
        [self.view addSubview:BackView_zhaopinxinxi];
    }
    UIView * lastView=[self.view.subviews lastObject];
    
    zhiwei=[[UITextView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, KWidth, 80)];
    [zhiwei setKeyboardType:UIKeyboardTypeDefault];
    zhiwei.delegate=self;
    [self.view addSubview:zhiwei];
    
    UILabel *uilabelzhiwei=[[UILabel alloc] initWithFrame:CGRectMake(17, lastView.frame.origin.y+lastView.frame.size.height+5+8, 100, 10)];
    uilabelzhiwei.text = @"请填写投诉内容..";
    uilabelzhiwei.enabled = NO;//lable必须设置为不可用
    uilabelzhiwei.backgroundColor = [UIColor clearColor];
    [self.view addSubview:uilabelzhiwei];
    UILabel * lbl_zishuzhiwei=[[UILabel alloc] initWithFrame:CGRectMake(KWidth-160, lastView.frame.origin.y+lastView.frame.size.height+5+zhiwei.frame.size.height-30, 150, 10)];
    lbl_zishuzhiwei.text=@"还能输入140个字";
    lbl_zishuzhiwei.enabled=NO;
    lbl_zishuzhiwei.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lbl_zishuzhiwei];
    UIButton * btn_zhiwei=[[UIButton alloc] initWithFrame:CGRectMake(20, zhiwei.frame.origin.y+zhiwei.frame.size.height+10, SCREEN_WIDTH-40, 35)];
    btn_zhiwei.backgroundColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
    [btn_zhiwei addTarget:self action:@selector(zhiweiSubmit) forControlEvents:UIControlEventTouchUpInside];
    [btn_zhiwei setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:btn_zhiwei];
    
}
-(void)zhiweiSubmit
{
    if (zhiwei.text.length>0) {
        NSString * content= zhiwei.text;
        NSDictionary * prm=@{@"userid":_UserInfoData[@"userid"],@"content":content};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"zhiweiSubmitBackCall:"];
        [dataprovider chengpinSubmit:prm];
    }
    
}
-(void)zhiweiSubmitBackCall:(id)dict
{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:dict[@"msg"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}

-(void)GetZhaoShangInfo
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetZhaoShangInfoBackCall:"];
    [dataprovider GetZhaoShangInfo];
}
-(void)GetZhaoShangInfoBackCall:(id)dict
{
    NSLog(@"%@",dict);
    NSArray * array=[[NSArray alloc] initWithArray:dict[@"data"]];
    for (int i=0; i<array.count; i++) {
        UIView *lastView;
        UIView * BackView_zhaopinxinxi;
        if (i==0) {
            BackView_zhaopinxinxi=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 100)];
        }
        else
        {
            lastView=[self.view.subviews lastObject];
            BackView_zhaopinxinxi=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y, SCREEN_WIDTH, 100)];
        }
        UILabel * lbl_zhiweiname=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
        lbl_zhiweiname.text=[NSString stringWithFormat:@"%d、%@",i,array[i][@"zhiwei"]];
        [BackView_zhaopinxinxi addSubview:lbl_zhiweiname];
        UILabel * lbl_zhiweicontent=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_zhiweiname.frame.size.height+10, SCREEN_WIDTH-20, 60)];
        [lbl_zhiweicontent setLineBreakMode:NSLineBreakByWordWrapping];
        lbl_zhiweicontent.numberOfLines=0;
        lbl_zhiweicontent.text=array[i][@"content"];
        [BackView_zhaopinxinxi addSubview:lbl_zhiweicontent];
        [self.view addSubview:BackView_zhaopinxinxi];
    }
    UIView * lastView=[self.view.subviews lastObject];
    
    zhaoshang=[[UITextView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, KWidth, 80)];
    [zhaoshang setKeyboardType:UIKeyboardTypeDefault];
    zhaoshang.delegate=self;
    [self.view addSubview:zhaoshang];
    
    UILabel *uilabelzhiwei=[[UILabel alloc] initWithFrame:CGRectMake(17, lastView.frame.origin.y+lastView.frame.size.height+5+8, 100, 10)];
    uilabelzhiwei.text = @"请填写投诉内容..";
    uilabelzhiwei.enabled = NO;//lable必须设置为不可用
    uilabelzhiwei.backgroundColor = [UIColor clearColor];
    [self.view addSubview:uilabelzhiwei];
    UILabel * lbl_zishuzhiwei=[[UILabel alloc] initWithFrame:CGRectMake(KWidth-160, lastView.frame.origin.y+lastView.frame.size.height+5+zhiwei.frame.size.height-30, 150, 10)];
    lbl_zishuzhiwei.text=@"还能输入140个字";
    lbl_zishuzhiwei.enabled=NO;
    lbl_zishuzhiwei.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lbl_zishuzhiwei];
    UIButton * btn_zhiwei=[[UIButton alloc] initWithFrame:CGRectMake(20, zhiwei.frame.origin.y+zhiwei.frame.size.height+10, SCREEN_WIDTH-40, 35)];
    btn_zhiwei.backgroundColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
    [btn_zhiwei addTarget:self action:@selector(zhiweiSubmit) forControlEvents:UIControlEventTouchUpInside];
    [btn_zhiwei setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:btn_zhiwei];

}
-(void)zhaoshangSubmit
{
    if (zhaoshang.text.length>0) {
        NSString * content= zhaoshang.text;
        NSDictionary * prm=@{@"userid":_UserInfoData[@"userid"],@"content":content};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"zhaoshangSubmitBackCall:"];
        [dataprovider zhaoshangSubmit:prm];
    }
    
}
-(void)zhaoshangSubmitBackCall:(id)dict
{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:dict[@"msg"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}

@end