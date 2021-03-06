//
//  LoginViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/4.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegViewController.h"
#import "CommenDef.h"
#import "DataProvider.h"
#import <SMS_SDK/SMS_SDK.h>
#import "AppDelegate.h"
#import "ForgetPwdViewController.h"
#import "SecriteViewController.h"



#define KWidth self.view.frame.size.width

@interface LoginViewController ()
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@property(nonatomic,strong)ForgetPwdViewController * myForgetpwd;
@property(nonatomic,strong)SecriteViewController *mysecriteVC;

@end

@implementation LoginViewController
{
    UITextField * txt_phoneNum;
    UITextField * txt_pwd;
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBarTitle:@"登录"];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self addLeftButton:@"ic_actionbar_back.png"];
    [self addRightbuttontitle:@"注册"];
    
    
    UIView * BackgroundView1=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+25, SCREEN_WIDTH, 40)];
    BackgroundView1.backgroundColor=[UIColor whiteColor];
    UILabel * PhoneNum =[[UILabel alloc ] initWithFrame:CGRectMake(10, 5, 80, 30)];
    PhoneNum.text=@"手机号：";
    [BackgroundView1 addSubview:PhoneNum];
    UIView * lastView=[[BackgroundView1 subviews] lastObject];
    CGFloat x=lastView.frame.origin.x+lastView.frame.size.width;
    txt_phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(x, 0, 200, 40)];
    [txt_phoneNum setKeyboardType:UIKeyboardTypeNumberPad];
    [txt_phoneNum setPlaceholder:@"请输入手机号"];
    [BackgroundView1 addSubview:txt_phoneNum];
    [self.view addSubview:BackgroundView1];
    
    lastView=BackgroundView1;
    UIView * BackgroundView2=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y+1, SCREEN_WIDTH, 40)];
    BackgroundView2.backgroundColor=[UIColor whiteColor];
    UILabel * Pwd =[[UILabel alloc ] initWithFrame:CGRectMake(10, 5, 80, 30)];
    Pwd.text=@"密码：";
    [BackgroundView2 addSubview:Pwd];
    lastView=[[BackgroundView2 subviews] lastObject];
    x=lastView.frame.origin.x+lastView.frame.size.width;
    txt_pwd=[[UITextField alloc] initWithFrame:CGRectMake(x, 0, 200, 40)];
    [txt_pwd setPlaceholder:@"输入密码"];
    [txt_pwd setKeyboardType:UIKeyboardTypeAlphabet];
    [BackgroundView2 addSubview:txt_pwd];
    [self.view addSubview:BackgroundView2];
    
    UILabel * lbl_secrit=[[UILabel alloc] initWithFrame:CGRectMake(10, BackgroundView2.frame.origin.y+BackgroundView2.frame.size.height+10, 170, 15)];
    lbl_secrit.text=@"点击下一步表示您已完成阅读";
    lbl_secrit.textColor=[UIColor grayColor];
    lbl_secrit.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:lbl_secrit];
    UIButton * btn_secrit=[[UIButton alloc] initWithFrame:CGRectMake(lbl_secrit.frame.origin.x+lbl_secrit.frame.size.width, lbl_secrit.frame.origin.y, 60, 15)];
    [btn_secrit setTitle:@"隐私政策" forState:UIControlStateNormal];
    [btn_secrit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn_secrit.titleLabel.font=[UIFont systemFontOfSize:13];
    [btn_secrit addTarget:self action:@selector(btn_secritClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_secrit];
    
    
    UIButton * btn_login=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-260)/2, btn_secrit.frame.origin.y+btn_secrit.frame.size.height+10, 260, 40)];
    [btn_login setBackgroundColor:[UIColor colorWithRed:228/255.0 green:58/255.0 blue:33/255.0 alpha:1.0]];
    [btn_login setTitle:@"登录" forState:UIControlStateNormal];
    [btn_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_login.layer.masksToBounds=YES;
    btn_login.layer.cornerRadius=5;
    [btn_login addTarget:self action:@selector(LoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_login];
    
    UIButton * btn_ForgetPwd=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-140, btn_login.frame.origin.y+btn_login.frame.size.height+10, 120, 20)];
    [btn_ForgetPwd setTitle:@"密码找回" forState:UIControlStateNormal];
    [btn_ForgetPwd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_ForgetPwd addTarget:self action:@selector(Btn_ForgetPwdClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_ForgetPwd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btn_secritClick
{
    _mysecriteVC=[[SecriteViewController alloc] initWithNibName:@"SecriteViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_mysecriteVC animated:YES];
}

-(void)LoginClick
{
//    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    if (txt_phoneNum.text!=nil&&txt_pwd.text!=nil) {
        DataProvider * dataprovider =[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"LoginBack:"];
        [dataprovider Login:txt_phoneNum.text andPwd:txt_pwd.text];
    }
    else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                      message:NSLocalizedString(@"账号或密码不正确", nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)LoginBack:(id)dict
{
    [SVProgressHUD dismiss];
    if (1==[dict[@"status"] intValue]&&[dict[@"data"][@"isavailable"] isEqualToString:@"1"]) {
//        NSString * path=[[NSBundle mainBundle] pathForResource:@"UserInfo" ofType:@"plist"];
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        BOOL result= [dict[@"data"] writeToFile:plistPath atomically:YES];
        if (result) {
//            NSLog(@"congsdfksadjfjsadklfjsadkjfkasdjfsdakjfkal%@",[[NSDictionary alloc] initWithContentsOfFile:plistPath]);
            SEL func_selector = NSSelectorFromString(callBackFunctionName);
            if ([CallBackObject respondsToSelector:func_selector]) {
                NSLog(@"回调成功...");
                [CallBackObject performSelector:func_selector withObject:dict];
            }else{
                NSLog(@"回调失败...");
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        NSString * token=get_sp(@"devicetoken");
        DLog(@"%@",get_sp(@"devicetoken"));
            //!!!:  已经登录完成，
            DataProvider* dataProvider=[[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"commitSuccess:"];
            [dataProvider commitdevicetokenWithUserid:dict[@"data"][@"userid"] token:token];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"账号或密码错误" maskType:SVProgressHUDMaskTypeBlack];
    }
    
}
-(void)commitSuccess:(id)dict{
    DLog(@"commitDeviceTokenSuccess:%@",dict[@"msg"]);
    if (dict[@"status"]) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
}
-(void)clickRightButton:(UIButton *)sender
{
    RegViewController* reg=[[RegViewController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
//    [self.navigationController pushViewController:reg animated:YES];
    
}

-(void)Btn_ForgetPwdClick
{
    self.myForgetpwd=[[ForgetPwdViewController alloc] initWithNibName:@"ForgetPwdViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_myForgetpwd animated:YES];
}
@end
