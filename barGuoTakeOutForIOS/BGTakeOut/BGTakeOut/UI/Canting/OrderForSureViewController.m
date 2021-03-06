//
//  OrderForSureViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/7.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "OrderForSureViewController.h"
#import "ShoppingCarModel.h"
#import "DataProvider.h"
#import "Pingpp.h"
#import "CommenDef.h"
#import "OrderInfoViewController.h"
#import "AddressListViewController.h"
#import "OrderListViewController.h"

@interface OrderForSureViewController ()
@property(nonatomic,strong)AddressListViewController * myaddresslist;
@end

@implementation OrderForSureViewController
{
    NSDictionary *OrderInfo;
    UIView * myPage;
    
    UITextView * Costommessage;
    UILabel *uilabel;
    UILabel *lbl_zishu;
    
    UIButton * PayOnLine;
    UIButton * PayWXWay;
    UIButton * PayOutLine;
    BOOL PayOnLineForChange;//yes代表在线支付
    BOOL PayWX;
    
    NSDictionary * dictPayWay;
    
    NSDictionary *dictionary;
    NSDictionary * address;
    NSDictionary * orderinfodetial;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    PayOnLineForChange=YES;
    PayWX=NO;
    dictPayWay=[[NSDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(existUserInfo) name:@"OrderPay_success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JumpToOrderList) name:@"OrderPay_filed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAddressBackCall:) name:@"select_address" object:nil];
    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self setBarTitle:@"订单确认"];
    [self addLeftButton:@"ic_actionbar_back.png"];
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetPayWayBackCall:"];
    [dataprovider GetpayWayInRes:_resid];
    
    address =[[NSDictionary alloc] init];
    
}


-(void)GetPayWayBackCall:(id)dict
{
    if (1==[dict[@"status"] integerValue]) {
        dictPayWay=dict[@"data"];
        myPage=[[UIView alloc]initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+21, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT-20)];
        myPage.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [self.view addSubview:myPage];
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        dictionary =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"Btn_AddressDefaultBackCall:"];
        [dataprovider GetUserAddressListWithPage:@"1" andnum:@"8" anduserid:dictionary[@"userid"] andisgetdefault:@"1"];
        
        UIView * BackgroundView1=[[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 50)];
        BackgroundView1.backgroundColor=[UIColor whiteColor];
        UIImageView * img_add=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
        img_add.image=[UIImage imageNamed:@"add-40"];
        [BackgroundView1 addSubview:img_add];
        UILabel * lbl_addtitle=[[UILabel alloc] initWithFrame:CGRectMake(img_add.frame.origin.x+img_add.frame.size.width+10, 15, 200, 20)];
        lbl_addtitle.text=@"新增收餐地址";
        lbl_addtitle.textColor=[UIColor redColor];
        [BackgroundView1 addSubview:lbl_addtitle];
        UIButton * btn_addaddress=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackgroundView1.frame.size.width, BackgroundView1.frame.size.height)];
        [btn_addaddress addTarget:self action:@selector(Btn_addressAddClick) forControlEvents:UIControlEventTouchUpInside];
        [BackgroundView1 addSubview:btn_addaddress];
        [myPage addSubview:BackgroundView1];
        
        UIView * lastView=[myPage.subviews lastObject];
        UIView * fillview=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y, SCREEN_WIDTH, 5)];
        [myPage addSubview:fillview];
        
        for (int i=0; i<_orderData.count; i++) {
            lastView=[myPage.subviews lastObject];
            UIView *orderBackground=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, SCREEN_WIDTH,30)];
            UIView * icon=[[UIView alloc] initWithFrame:CGRectMake(10, 12.5, 5, 5)];
            icon.layer.masksToBounds=YES;
            icon.layer.cornerRadius=2.5;
            icon.backgroundColor=[UIColor colorWithRed:85/255.0 green:195/255.0 blue:38/255.0 alpha:1.0];
            [orderBackground addSubview:icon];
            lastView=[self.view.subviews lastObject];
            orderBackground.backgroundColor=[UIColor whiteColor];
            ShoppingCarModel *item=_orderData[i];
            UILabel *itemName=[[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width+20, 5, 150, 20)];
            itemName.text=item.Goods[@"name"];
            [orderBackground addSubview:itemName];
            UILabel * itemnum=[[UILabel alloc] initWithFrame:CGRectMake(itemName.frame.origin.x+itemName.frame.size.width, 5, 40, 20)];
            itemnum.text=[NSString stringWithFormat:@"x%d",item.Num];
            [orderBackground addSubview:itemnum];
            UILabel * itemprice=[[UILabel alloc] initWithFrame:CGRectMake(itemnum.frame.origin.x+itemnum.frame.size.width+20, 5, 80, 20)];
            itemprice.text=[NSString stringWithFormat:@"¥%.2f",item.Num*[item.Goods[@"price"] floatValue]];
            [orderBackground addSubview:itemprice];
            [myPage addSubview:orderBackground];
        }
        
        lastView=[myPage.subviews lastObject];
        Costommessage=[[UITextView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y+5, SCREEN_WIDTH, 80)];
        [Costommessage setKeyboardType:UIKeyboardTypeDefault];
        Costommessage.delegate=self;
        [myPage addSubview:Costommessage];
        uilabel=[[UILabel alloc] initWithFrame:CGRectMake(17, lastView.frame.size.height+lastView.frame.origin.y+18, 100, 15)];
        uilabel.text = @"给餐厅留言..";
        uilabel.font=[UIFont systemFontOfSize:13];
        uilabel.enabled = NO;//lable必须设置为不可用
        uilabel.backgroundColor = [UIColor clearColor];
        [myPage addSubview:uilabel];
        lbl_zishu=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, lastView.frame.size.height+lastView.frame.origin.y+Costommessage.frame.size.height-15, 150, 15)];
        lbl_zishu.text=@"还能输入140个字";
        lbl_zishu.font=[UIFont systemFontOfSize:13];
        lbl_zishu.enabled=NO;
        lbl_zishu.backgroundColor=[UIColor clearColor];
        [myPage addSubview:lbl_zishu];
        
        lastView=Costommessage;
        UIView *peisongfeiView=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, SCREEN_WIDTH, 40)];
        peisongfeiView.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_peisongfei=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_peisongfei.text=@"配送费";
        lbl_peisongfei.textColor=[UIColor colorWithRed:255/255.0 green:113/255.0 blue:14/255.0 alpha:1.0];
        [peisongfeiView addSubview:lbl_peisongfei];
        UILabel * lbl_peisongprice=[[UILabel alloc] initWithFrame:CGRectMake(250, 10, 40, 20)];
        lbl_peisongprice.text=[NSString stringWithFormat:@"¥%@",_peiSongFeiData];
        lbl_peisongprice.textColor=[UIColor colorWithRed:255/255.0 green:113/255.0 blue:14/255.0 alpha:1.0];
        [peisongfeiView addSubview:lbl_peisongprice];
        [myPage addSubview:peisongfeiView];
        
        lastView=peisongfeiView;
        UIView * hejiBackView=[[UIView alloc] initWithFrame:CGRectMake(0,  lastView.frame.origin.y+lastView.frame.size.height+5, SCREEN_WIDTH, 40)];
        hejiBackView.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_title.text=@"合计";
        [hejiBackView addSubview:lbl_title];
        UILabel * lbl_orderprice=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 10, 80, 20)];
        lbl_orderprice.text=[NSString stringWithFormat:@"¥%.2f",[_orderSumPrice floatValue]];//[_orderSumPrice floatValue]+[_peiSongFeiData floatValue]
        lbl_orderprice.textAlignment= NSTextAlignmentRight;
        [hejiBackView addSubview:lbl_orderprice];
        [myPage addSubview:hejiBackView];
        
        lastView=[myPage.subviews lastObject];
        UIView * PayWayBackView=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, SCREEN_WIDTH, 80)];
        PayWayBackView.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_payname=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
        lbl_payname.text=@"支付方式";
        [PayWayBackView addSubview:lbl_payname];
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 1)];
        fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [PayWayBackView addSubview:fenge];
        
        if ([dictPayWay[@"isonlinepay"] intValue]==1) {
            PayOnLine=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/3-100)/2, 48, 100, 25)];
            [PayOnLine setTitle:@"支付宝" forState:UIControlStateNormal];
            PayOnLine.titleLabel.font=[UIFont systemFontOfSize:15];
            PayOnLine.tag=1;
            [PayOnLine setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
            [PayOnLine addTarget:self action:@selector(ChangePayWay:) forControlEvents:UIControlEventTouchUpInside];
            [PayOnLine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [PayWayBackView addSubview:PayOnLine];
            PayWXWay=[[UIButton alloc] initWithFrame:CGRectMake(PayOnLine.frame.origin.x+PayOnLine.frame.size.width+(SCREEN_WIDTH/3-100)/2, 48, 100, 25)];
            [PayWXWay setTitle:@"微信支付" forState:UIControlStateNormal];
            PayWXWay.titleLabel.font=[UIFont systemFontOfSize:15];
            PayWXWay.tag=2;
            [PayWXWay setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
            [PayWXWay addTarget:self action:@selector(ChangePayWay:) forControlEvents:UIControlEventTouchUpInside];
            [PayWXWay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [PayWayBackView addSubview:PayWXWay];
        }
        if ([dictPayWay[@"iscod"] intValue]==1) {
            PayOutLine=[[UIButton alloc] initWithFrame:CGRectMake(PayWXWay.frame.origin.x+PayWXWay.frame.size.width+(SCREEN_WIDTH/3-100)/2, 48, 100, 25)];
            [PayOutLine setTitle:@"货到付款" forState:UIControlStateNormal];
            [PayOutLine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [PayOutLine setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
            PayOutLine.titleLabel.font=[UIFont systemFontOfSize:15];
            PayOutLine.tag=3;
            [PayOutLine addTarget:self action:@selector(ChangePayWay:) forControlEvents:UIControlEventTouchUpInside];
            [PayWayBackView addSubview:PayOutLine];
        }
        
        [myPage addSubview:PayWayBackView];
        
        lastView=[myPage.subviews lastObject];
        UIButton * submitOrder=[[UIButton alloc] initWithFrame:CGRectMake(20, lastView.frame.origin.y+lastView.frame.size.height+5, SCREEN_WIDTH-40, 30)];
        [submitOrder setTitle:@"提交订单" forState:UIControlStateNormal];
        [submitOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitOrder.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
        submitOrder.layer.masksToBounds=YES;
        submitOrder.layer.cornerRadius=3;
        [submitOrder addTarget:self action:@selector(SubmitOrderfunc) forControlEvents:UIControlEventTouchUpInside];
        [myPage addSubview:submitOrder];
        [SVProgressHUD dismiss];
    }
}
-(void)Btn_addressAddClick
{
    if (dictionary){
        self.myaddresslist=[[AddressListViewController alloc] init];
        self.myaddresslist.userid=dictionary[@"userid"];
        self.myaddresslist.isSelect=YES;
        [self.navigationController pushViewController:_myaddresslist animated:YES];
    }else
    {
        _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UIView * item =_myLogin.view;
        [_myLogin setDelegateObject:self setBackFunctionName:@"LoginBackCall:"];
        [self.view addSubview:item];
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
-(void)textViewDidChange:(UITextView *)textView
{
    int textlength=textView.text.length ;
    if (textlength== 0) {
        uilabel.text = @"给餐厅留言..";
    }else{
        uilabel.text = @"";
        lbl_zishu.text=[NSString stringWithFormat:@"还能输入%d个字",140-textlength];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)ChangePayWay:(UIButton *)sender
{
    if (1==sender.tag) {
        PayOnLineForChange=YES;
        PayWX=NO;
        [PayOnLine setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
        [PayOutLine setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
        [PayWXWay setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
    }
    if(2==sender.tag)
    {
        PayOnLineForChange=YES;
        PayWX=YES;
        [PayWXWay setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
        [PayOutLine setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
        [PayOnLine setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
    }
    if(3==sender.tag)
    {
        PayOnLineForChange=NO;
        PayWX=NO;
        [PayWXWay setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
        [PayOutLine setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
        [PayOnLine setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
    }
}

-(void)SubmitOrderfunc
{
    
    if (dictionary) {
        [self BuildDataToSubmit:dictionary];
    }
    else
    {
        _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UIView * item =_myLogin.view;
        [_myLogin setDelegateObject:self setBackFunctionName:@"LoginBackCall:"];
        [self.view addSubview:item];
    }
}

-(void)LoginBackCall:(id)dict
{
    if (1==[dict[@"status"] integerValue]) {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        dictionary =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
}
#pragma mark 构建提交订餐所需的参数
-(void)BuildDataToSubmit:(id)dict
{
    NSMutableDictionary * prm=[[NSMutableDictionary alloc] init];
    [prm setObject:[NSString stringWithFormat:@"%.2f",[_orderSumPrice floatValue]] forKey:@"orderprice"];
    
    if (dict[@"userid"]) {
        if (address[@"address"]&&address[@"phonenum"]) {
            [prm setObject:address[@"addressdetail"] forKey:@"address"];
            [prm setObject:address[@"phonenum"] forKey:@"phonenum"];
            [prm setObject:dict[@"userid"] forKey:@"userid"];
            
            if (dict[@"username"]) {
                [prm setObject:dict[@"username"] forKey:@"realname"];//此处需修改
                [prm setObject:dict[@"username"] forKey:@"username"];
                
                if (PayOnLineForChange) {
                    if(PayWX)
                    {
                        [prm setObject:@"2"forKey:@"payway"];
                    }
                    else
                    {
                        [prm setObject:@"0"forKey:@"payway"];
                    }
                    
                }else
                {
                    [prm setObject:@"1"forKey:@"payway"];
                }
                if (Costommessage.text) {
                    [prm setObject:Costommessage.text forKey:@"remark"];
                }
                NSMutableArray * orderdataArray=[[NSMutableArray alloc] init];

                for (int i=0; i<_orderData.count; i++) {
                    NSMutableDictionary * dict=[[NSMutableDictionary alloc] init];
                    ShoppingCarModel *item=_orderData[i];
                    [dict setObject:item.Goods[@"goodsid"] forKey:@"goodsid"];
                    [dict setObject:item.Goods[@"name"] forKey:@"goodsname"];
                    [dict setObject:item.Goods[@"activity"] forKey:@"activity"];
                    [dict setObject:[NSString stringWithFormat:@"%d",item.Num] forKey:@"count"];
                    [dict setObject:item.Goods[@"price"] forKey:@"price"];
                    
                    [orderdataArray addObject:dict];
                    
                    [prm setObject:item.Goods[@"resid"] forKey:@"resid"];
                }
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderdataArray
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                             encoding:NSUTF8StringEncoding];
                [prm setObject:jsonString  forKey:@"goodsdetail"];
                DataProvider * dataprovider=[[DataProvider alloc] init];
                [dataprovider setDelegateObject:self setBackFunctionName:@"submitOrderBackCall:"];
                [dataprovider SubmitOrder:prm];
                
                
            }
        }else
        {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择地址" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
        
    }
    
}

-(void)submitOrderBackCall:(id)dict
{
    NSLog(@"提交订单%@",dict);
    if ([dict[@"status"] intValue]==1) {
        OrderInfo=dict[@"data"];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetChargeBackCall:"];
        if (PayOnLineForChange) {
            if (PayWX) {
                NSDictionary * prm=@{@"channel":@"wx",@"amount":[NSString stringWithFormat:@"%.0f",([_orderSumPrice floatValue])*100],@"ordernum":dict[@"data"][@"ordernum"],@"subject":@"外卖微信支付",@"body":@"外卖"};
//                NSDictionary * prm=@{@"channel":@"wx",@"amount":@"1",@"ordernum":dict[@"data"][@"ordernum"],@"subject":@"外卖微信支付",@"body":@"外卖"};
                [dataprovider GetchargeForPay:prm];
            }
            else
            {
                NSDictionary * prm=@{@"channel":@"alipay",@"amount":[NSString stringWithFormat:@"%.0f",([_orderSumPrice floatValue])*100],@"ordernum":dict[@"data"][@"ordernum"],@"subject":@"外卖2",@"body":@"外卖"};
//                NSDictionary * prm=@{@"channel":@"alipay",@"amount":@"1",@"ordernum":dict[@"data"][@"ordernum"],@"subject":@"外卖2",@"body":@"外卖"};
                [dataprovider GetchargeForPay:prm];
            }
            
        }
        else
        {
            NSLog(@"货到付款，直接跳到订单详情页");
            OrderInfoViewController * orderinfoVC=[[OrderInfoViewController alloc] init];
            orderinfoVC.orderInfoDetial=dict[@"data"];
            orderinfoVC.lastprice=[_orderSumPrice floatValue];
            orderinfoVC.orderData=_orderData;
            [self.navigationController pushViewController:orderinfoVC animated:YES];
        }
        

    }
}



-(void)GetChargeBackCall:(id)dict
{
    NSLog(@"%@",dict);
    
    
    if (dict) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str_data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (PayOnLineForChange) {
            if (PayWX) {
                [Pingpp createPayment:str_data viewController:self appURLScheme:@"wx9039702cc87118c0" withCompletion:^(NSString *result, PingppError *error) {
                    if ([result isEqualToString:@"success"]) {
                        NSLog(@"支付成功");
                    } else {
                        NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                    }
                }];
            }else{
                [Pingpp createPayment:str_data viewController:self appURLScheme:@"BGTakeOut" withCompletion:^(NSString *result, PingppError *error) {
                    if ([result isEqualToString:@"success"]) {
                        NSLog(@"支付成功");
                    } else {
                        NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                    }
                }];
            }
            
        }
        
        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
-(void)Btn_AddressDefaultBackCall:(id)dict
{
    if (1==[dict[@"status"] intValue]) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        if (arrayitem.count>0) {
            address=arrayitem[0];
        }
        
    }
    [self BuildDefaultAddress];
}


-(void)BuildDefaultAddress
{
    if (address[@"realname"]) {
        UIView * BackgroundView1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        BackgroundView1.backgroundColor=[UIColor grayColor];
        UILabel * lbl_name=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 20)];
        lbl_name.text=address[@"realname"];
        lbl_name.textColor=[UIColor whiteColor];
        [BackgroundView1 addSubview:lbl_name];
        UILabel * lbl_phoneNum=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, 0, 150, 20)];
        lbl_phoneNum.text=address[@"phonenum"];
        lbl_phoneNum.textColor=[UIColor whiteColor];
        [BackgroundView1 addSubview:lbl_phoneNum];
        UILabel * lbl_address=[[UILabel alloc]initWithFrame:CGRectMake(10, lbl_name.frame.origin.y+lbl_name.frame.size.height+3,SCREEN_WIDTH-50 , 20)];
        [lbl_address setLineBreakMode:NSLineBreakByWordWrapping];
        lbl_address.numberOfLines=0;
        lbl_address.font=[UIFont systemFontOfSize:13];
        lbl_address.text=[NSString stringWithFormat:@"［默认］%@",address[@"addressdetail"]];
        lbl_address.textColor=[UIColor whiteColor];
        [BackgroundView1 addSubview:lbl_address];
        UIButton * btn_addaddress=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackgroundView1.frame.size.width, BackgroundView1.frame.size.height)];
        [btn_addaddress addTarget:self action:@selector(Btn_addressAddClick) forControlEvents:UIControlEventTouchUpInside];
        [BackgroundView1 addSubview:btn_addaddress];
        [myPage addSubview:BackgroundView1];
    }
}

-(void)existUserInfo
{
    OrderInfoViewController * orderinfoVC=[[OrderInfoViewController alloc] init];
    orderinfoVC.orderInfoDetial=OrderInfo;
    orderinfoVC.lastprice=[_orderSumPrice intValue]+[_peiSongFeiData intValue];
    orderinfoVC.orderData=_orderData;
    [self.navigationController pushViewController:orderinfoVC animated:YES];

}
-(void)JumpToOrderList
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary * userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];

    OrderListViewController *myOrderList=[[OrderListViewController alloc] init];
    myOrderList.userid=userinfoWithFile[@"userid"];
    [self.navigationController pushViewController:myOrderList animated:YES];
}

-(void)selectAddressBackCall:(NSNotification *)notice
{
    address=[notice object];
    [self BuildDefaultAddress];
}

@end
