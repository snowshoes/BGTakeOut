//
//  CantingInfoViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/27.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "CantingInfoViewController.h"
#import "DataProvider.h"
#import "GoodsTableViewCell.h"
#import "ShoppingCarModel.h"
#import "JSBadgeView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "TQStarRatingView.h"
#import "CommenDef.h"
#import "AppDelegate.h"

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define KAreaListHeight 50 //scollview中的button的高度
#define KURL @"http://121.42.139.60/baguo/"

@interface CantingInfoViewController ()

@property(nonatomic,strong) NYSegmentedControl *CantingsegmentedControl;
@property(nonatomic,strong)UIView * CantingPage;
@property(nonatomic,strong)UIView * CantingOtherPage;
@property(nonatomic,strong)UIScrollView * areaScroll;
@property(nonatomic,strong)UITableView * GoodsList;
@property(nonatomic,strong)UIView * ShoppingListView;
@property(nonatomic,strong)UIImageView *radiusimageView;
@property(nonatomic,strong)UILabel * lableinShoppingList;
@property(nonatomic,strong)JSBadgeView *badgeView;
@property(nonatomic,strong)UIView * shoppingListPage;
@property(nonatomic,strong)UILabel * locationForbadge;
@end

@implementation CantingInfoViewController
{
    NSArray * GoodsListArray;
    NSMutableArray * ShoppingCar;
    BOOL isClick;
    UIButton *  choseDone;
    UIView * CantingsegmentView;//放segmentcontrol的view
    NSDictionary * dictionary;
    NSMutableArray * lbl_array;
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ShoppingCar=[[NSMutableArray alloc] init];
    isClick=NO;
    [self setBarTitle:_name];
    [self addLeftButton:@"ic_actionbar_back.png"];
    
    
    //添加Segmented Control
    UIView * lastView=[self.view.subviews lastObject];
    CantingsegmentView=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 40)];
    CantingsegmentView.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    self.CantingsegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"餐厅菜单", @"店铺详情"]];
    [self.CantingsegmentedControl addTarget:self action:@selector(CantingSegMentControlClick) forControlEvents:UIControlEventValueChanged];
    self.CantingsegmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    self.CantingsegmentedControl.titleTextColor = [UIColor whiteColor];
    self.CantingsegmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    self.CantingsegmentedControl.selectedTitleTextColor = [UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    self.CantingsegmentedControl.borderWidth = 1.0f;
    self.CantingsegmentedControl.borderColor = [UIColor whiteColor];
    self.CantingsegmentedControl.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    //self.segmentedControl.segmentIndicatorInset = 2.0f;
    self.CantingsegmentedControl.cornerRadius=16.0f;
    self.CantingsegmentedControl.segmentIndicatorGradientTopColor = [UIColor whiteColor];
    self.CantingsegmentedControl.segmentIndicatorGradientBottomColor = [UIColor whiteColor];
    self.CantingsegmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    self.CantingsegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    self.CantingsegmentedControl.selectedSegmentIndex = 0;
    [self.CantingsegmentedControl sizeToFit];
    self.CantingsegmentedControl.frame=CGRectMake(22, 2, KWidth-44, 36);
    [CantingsegmentView addSubview:_CantingsegmentedControl];
    [self.view addSubview:CantingsegmentView];
    
    lastView=[self.view.subviews lastObject];
    CGFloat ViewHeight=lastView.frame.origin.y+lastView.frame.size.height;
    _CantingPage=[[UIView alloc] initWithFrame:CGRectMake(0,ViewHeight , KWidth, KHeight-ViewHeight-50)];
    [self.view addSubview:_CantingPage];
    
    _shoppingListPage=[[UIView alloc] initWithFrame:CGRectMake(0, KHeight-50, KWidth, 250)];
    
    _ShoppingListView =[[UIView alloc] initWithFrame:CGRectMake(0, KHeight-50, KWidth, 50)];
    _ShoppingListView.backgroundColor=[UIColor whiteColor];
    choseDone=[[UIButton alloc] initWithFrame:CGRectMake(KWidth-90, 0, 90, 50)];
    choseDone.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    [choseDone setTitle:@"选好了" forState:UIControlStateNormal];
    [choseDone addTarget:self action:@selector(payForShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    [choseDone setEnabled:NO];
    [_ShoppingListView addSubview:choseDone];
    _lableinShoppingList=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, KWidth-100, 30)];
    [_lableinShoppingList setTextAlignment:NSTextAlignmentCenter];
    _lableinShoppingList.text=@"购物车内没有物品";
    [_ShoppingListView addSubview:_lableinShoppingList];
    [self.view addSubview:_ShoppingListView];
    
    
    
    [self.view addSubview:_shoppingListPage];
    
    
    _radiusimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gouwuche_icon"]];
    _radiusimageView.backgroundColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
    _radiusimageView.frame = CGRectMake(10,KHeight-85, 50, 50);
    _radiusimageView.layer.masksToBounds =YES;
    _radiusimageView.layer.cornerRadius =25;
    _radiusimageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowGouWuChe)];
    [_radiusimageView addGestureRecognizer:singleTap1];
    [self.view addSubview:_radiusimageView];
    
    _locationForbadge=[[UILabel alloc] initWithFrame:CGRectMake(_radiusimageView.frame.origin.x+_radiusimageView.frame.size.width-5, _radiusimageView.frame.origin.y, 5, 5)];
    [self.view addSubview:_locationForbadge];
    
    
    
    DataProvider * cantingdataprovider =[[DataProvider alloc] init];
    [cantingdataprovider setDelegateObject:self setBackFunctionName:@"BuildCategray:"];
    [cantingdataprovider GetCantingCategory:_resid];
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


#pragma mark 创建左侧的分类栏
-(void)BuildCategray:(id)dict
{
    NSLog(@"%@",dict);
    if (1==[dict[@"status"] integerValue]) {
        _areaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth/3, _CantingPage.frame.size.height)];
        _areaScroll.scrollEnabled=YES;
        _areaScroll.backgroundColor=[UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:1.0];
        id result =dict;
        if (result) {
            NSArray * areaArray =[[NSArray alloc ] initWithArray:result[@"data"]];
            for (int i=0; i<areaArray.count; i++) {
                UIButton * areaitem=[[UIButton alloc] initWithFrame:CGRectMake(0, i*(KAreaListHeight+1), KWidth/3, KAreaListHeight)];
                areaitem.backgroundColor=[UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:1.0];
                
                [areaitem setTag:i];
                [areaitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [areaitem setTitle:[NSString stringWithFormat:@"%@",areaArray[i][@"name"]] forState:UIControlStateNormal];
                [areaitem addTarget:self action:@selector(CantingItemClick:) forControlEvents:UIControlEventTouchUpInside];
                [_areaScroll addSubview:areaitem];
            }
            _areaScroll.contentSize=CGSizeMake(0, areaArray.count*(KAreaListHeight+1));
        }
        [_CantingPage addSubview:_areaScroll];
    }
    
}

-(void)CantingclickLeftButton
{
    [self.view removeFromSuperview];
}

-(void)CantingSegMentControlClick
{
    if (1==self.CantingsegmentedControl.selectedSegmentIndex) {
        _CantingPage.hidden=YES;
        NSLog(@"other");
        _ShoppingListView.hidden=YES;
        _radiusimageView.hidden=YES;
        if (_badgeView) {
            _badgeView.hidden=YES;
        }
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        dictionary =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
        if (dictionary) {
            DataProvider *dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"CanTingXiangqingBackCall:"];
            [dataprovider GetCantingXiangqing:_resid anduserid:dictionary[@"userid"]];
        }
    }
    else
    {
        _CantingPage.hidden=NO;
        _ShoppingListView.hidden=NO;
        _radiusimageView.hidden=NO;
        if (_badgeView) {
            _badgeView.hidden=NO;
        }
        _CantingOtherPage.hidden=YES;
    }
}
-(void)CantingItemClick:(UIButton *)sender
{
    for (UIView * item in _areaScroll.subviews) {
        if ([item isKindOfClass:[UIButton class]]) {
            UIButton * itemBtn =(UIButton *)item;
            item.backgroundColor=[UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:1.0];
            [itemBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        }
    }
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    DataProvider * dataprovider =[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"BuildGoodsList:"];
    [dataprovider GetGoodsinCategory:[NSString stringWithFormat:@"%d",(int)sender.tag]];
}

-(void)BuildGoodsList:(id)dict
{
    NSLog(@"%@",dict);
    GoodsListArray=dict[@"data"];
    if (_GoodsList) {
        [_GoodsList removeFromSuperview];
    }
    if (![GoodsListArray isEqual:@""]) {
        _GoodsList=[[UITableView alloc] initWithFrame:CGRectMake(KWidth/3, 0, KWidth-KWidth/3, _CantingPage.frame.size.height)];
        _GoodsList.delegate=self;
        _GoodsList.dataSource=self;
        [_CantingPage addSubview:_GoodsList];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return GoodsListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GoodsTableViewCell";
    GoodsTableViewCell *cell = (GoodsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:self options:nil] lastObject];
        [cell.goodimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,GoodsListArray[indexPath.row][@"pic"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.goodName.text=GoodsListArray[indexPath.row][@"name"];
        cell.goodPrice.text=[NSString stringWithFormat:@"¥%@",GoodsListArray[indexPath.row][@"price"]];
        cell.goodSell.text=[NSString stringWithFormat:@"已售%@份",GoodsListArray[indexPath.row][@"soldnum"]];
        cell.personPush.text=[NSString stringWithFormat:@"推荐%@",GoodsListArray[indexPath.row][@"recommendnum"]];
        UIButton * image_add=[[UIButton alloc] initWithFrame:CGRectMake(187, 57, 20, 20)];
        image_add.layer.masksToBounds=YES;
        image_add.layer.cornerRadius=12.5;
        [image_add setImage:[UIImage imageNamed:@"jia_quan.png"] forState:UIControlStateNormal];
        [image_add addTarget:self action:@selector(GoodsAddClick:) forControlEvents:UIControlEventTouchUpInside];
        [image_add setTag:indexPath.row];
        [cell addSubview:image_add];
        
        UIButton * image_jian=[[UIButton alloc] initWithFrame:CGRectMake(131, 57, 20, 20)];
        image_jian.layer.masksToBounds=YES;
        image_jian.layer.cornerRadius=12.5;
        [image_jian setImage:[UIImage imageNamed:@"jian_quan.png"] forState:UIControlStateNormal];
        [image_jian setTag:indexPath.row];
        [cell addSubview:image_jian];
        UILabel * lbl_cellNum=[[UILabel alloc] initWithFrame:CGRectMake(150, 57, 37, 20)];
        [lbl_cellNum setTextAlignment:NSTextAlignmentCenter];
        lbl_cellNum.tag=indexPath.row;
        lbl_cellNum.font=[UIFont systemFontOfSize:13];
        [cell addSubview:lbl_cellNum];
        [lbl_array addObject:lbl_cellNum];
    }
    else
    {
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark 点餐，点击后添加到购物车
-(void)GoodsAddClick:(UIButton *)sender
{
    NSLog(@"添加一份");
    [choseDone setEnabled:YES];
    [choseDone setBackgroundColor:[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0]];
    for (UILabel *item in lbl_array) {
        if (item.tag==sender.tag) {
            item.text=[NSString stringWithFormat:@"%d",[item.text intValue]+1];
        }
    }
    ShoppingCarModel * shopModel=[[ShoppingCarModel alloc] init];
    if (ShoppingCar.count>0) {
        int i=0;
        BOOL isExit=false;
        ShoppingCarModel * mydata;
        for (ShoppingCarModel * item in ShoppingCar) {
            i++;
            if (GoodsListArray[sender.tag][@"category"]==item.Goods[@"category"]&&GoodsListArray[sender.tag][@"goodsid"]==item.Goods[@"goodsid"]) {
                isExit=YES;
                mydata= ShoppingCar[[ShoppingCar indexOfObject:item]];
                break;
            }
        }
        if (!isExit) {
            shopModel.Num=1;
            shopModel.Goods=GoodsListArray[sender.tag];
            [ShoppingCar addObject:shopModel];
        }
        else
        {
            mydata.Num+=1;
        }
    }else{
        shopModel.Num=1;
        shopModel.Goods=GoodsListArray[sender.tag];
        [ShoppingCar addObject:shopModel];
    }
    if (_badgeView) {
         _badgeView.badgeText = [NSString stringWithFormat:@"%lu",(unsigned long)ShoppingCar.count];
    }
    else
    {
        _badgeView = [[JSBadgeView alloc] initWithParentView:_locationForbadge alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.badgeText = [NSString stringWithFormat:@"%lu",(unsigned long)ShoppingCar.count];
        _badgeView.backgroundColor=[UIColor redColor];
    }
}

-(void)ShowGouWuChe
{
    float SumPrice=0;
    [choseDone setEnabled:YES];
    [choseDone setBackgroundColor:[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0]];

    int viewheight=ShoppingCar.count<4?(ShoppingCar.count*50):200;
    UIScrollView * areaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, KWidth, viewheight)];
    areaScroll.scrollEnabled=YES;
    areaScroll.backgroundColor=[UIColor grayColor];
    for (int i=0; i<ShoppingCar.count; i++) {
        UIView * ShoppingGoods =[[UIView alloc] initWithFrame:CGRectMake(0, i*50+1, KWidth, 50)];
        ShoppingGoods.backgroundColor=[UIColor whiteColor];
        UILabel * nameofgoods=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, KWidth-150, 30)];
        [nameofgoods setTextAlignment:NSTextAlignmentCenter];
        ShoppingCarModel * item=ShoppingCar[i];
        nameofgoods.text=item.Goods[@"name"];
        [ShoppingGoods addSubview:nameofgoods];
        
        CGFloat x=nameofgoods.frame.origin.x+nameofgoods.frame.size.width;
        UIButton * jianBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, 10, 25, 25)];
        [jianBtn setImage:[UIImage imageNamed:@"jian_quan.png"] forState:UIControlStateNormal];
        [jianBtn addTarget:self action:@selector(jian_btnClick:) forControlEvents:UIControlEventTouchUpInside];
        jianBtn.tag=i;
        [ShoppingGoods addSubview:jianBtn];
        
        
        x=jianBtn.frame.origin.x+jianBtn.frame.size.width;
        UILabel * goodsnum=[[UILabel alloc] initWithFrame:CGRectMake(x, 10, 50, 30)];
        goodsnum.text=[NSString stringWithFormat:@"%d",item.Num];
        goodsnum.tag=110;
        [goodsnum setTextAlignment:NSTextAlignmentCenter];
        [ShoppingGoods addSubview:goodsnum];
        
        x=goodsnum.frame.origin.x+goodsnum.frame.size.width;
        UIButton * jiaBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, 10, 25, 25)];
        [jiaBtn setImage:[UIImage imageNamed:@"jia_quan.png"] forState:UIControlStateNormal];
        [jiaBtn addTarget:self action:@selector(jia_btnClick:) forControlEvents:UIControlEventTouchUpInside];
        jiaBtn.tag=i;
        [ShoppingGoods addSubview:jiaBtn];
        
        [areaScroll addSubview:ShoppingGoods];
        NSString * price=item.Goods[@"price"];
        SumPrice+=item.Num*[price floatValue];
    }
    areaScroll.contentSize=CGSizeMake(0, viewheight);
    if (!isClick) {
        //购物车列表出现
        [_shoppingListPage addSubview:areaScroll];
        _shoppingListPage.frame=CGRectMake(0, _shoppingListPage.frame.origin.y-viewheight-50, KWidth, viewheight+50);
        _radiusimageView.frame=CGRectMake(_radiusimageView.frame.origin.x, _radiusimageView.frame.origin.y-viewheight, _radiusimageView.frame.size.width, _radiusimageView.frame.size.height);
        _radiusimageView.backgroundColor=[UIColor colorWithRed:255/255 green:180/255 blue:0/255 alpha:1.0];
        _ShoppingListView.backgroundColor=[UIColor whiteColor];
        _lableinShoppingList.text=[NSString stringWithFormat:@"%.2f",SumPrice];
        [_lableinShoppingList setTextColor:[UIColor redColor]];
        _locationForbadge.frame=CGRectMake(_locationForbadge.frame.origin.x, _locationForbadge.frame.origin.y-viewheight, 5, 5);
        isClick=YES;
    }else
    {
        [_shoppingListPage addSubview:areaScroll];
        _shoppingListPage.frame=CGRectMake(0, _shoppingListPage.frame.origin.y+viewheight+50, KWidth, viewheight+50);
        _radiusimageView.frame=CGRectMake(_radiusimageView.frame.origin.x, _radiusimageView.frame.origin.y+viewheight, _radiusimageView.frame.size.width, _radiusimageView.frame.size.height);
        _radiusimageView.backgroundColor=[UIColor colorWithRed:255/255.0 green:180/255.0 blue:0/255.0 alpha:1.0];
        _ShoppingListView.backgroundColor=[UIColor whiteColor];
        _lableinShoppingList.text=[NSString stringWithFormat:@"%.2f",SumPrice];
        _locationForbadge.frame=CGRectMake(_locationForbadge.frame.origin.x, _locationForbadge.frame.origin.y+viewheight, 5, 5);
        isClick=NO;
    }
}
- (UIColor *) stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

-(void)jian_btnClick:(UIButton *)sender
{
    UILabel * mylable;
    NSArray * superarray=[[sender superview] subviews];
    for (int i=0; i<superarray.count; i++) {
        if ([superarray[i] isKindOfClass:[UILabel class]]) {
            mylable=superarray[i];
            if (110!=mylable.tag) {
                mylable=nil;
                continue;
            }
            break;
        }
    }
    int shengxia=[mylable.text intValue]-1;
    if (0==shengxia) {
        [sender.superview removeFromSuperview];
        [ShoppingCar removeObjectAtIndex:sender.tag];
        _badgeView.badgeText = [NSString stringWithFormat:@"%lu",(unsigned long)ShoppingCar.count];
        [self ShowGouWuChe];
    }
    else
    {
        mylable.text=[NSString stringWithFormat:@"%d",[mylable.text intValue]-1];
        ShoppingCarModel * modelofshoppingcar= ShoppingCar[sender.tag];
        modelofshoppingcar.Num-=1;
        _lableinShoppingList.text=[NSString stringWithFormat:@"%.2f",[_lableinShoppingList.text floatValue]-[modelofshoppingcar.Goods[@"price"] floatValue]] ;
    }
}
-(void)jia_btnClick:(UIButton *)sender
{
    UILabel * mylable;
    NSArray * superarray=[[sender superview] subviews];
    for (int i=0; i<superarray.count; i++) {
        if ([superarray[i] isKindOfClass:[UILabel class]]) {
            mylable=superarray[i];
            if (110!=mylable.tag) {
                mylable=nil;
                continue;
            }
            break;
        }
    }
    int shengxia=[mylable.text intValue]+1;
    if (0==shengxia) {
        [sender.superview removeFromSuperview];
        [ShoppingCar removeObjectAtIndex:sender.tag];
        [self ShowGouWuChe];
    }
    else
    {
        mylable.text=[NSString stringWithFormat:@"%d",[mylable.text intValue]+1];
        ShoppingCarModel * modelofshoppingcar= ShoppingCar[sender.tag];
        modelofshoppingcar.Num+=1;
        _lableinShoppingList.text=[NSString stringWithFormat:@"%.2f",[_lableinShoppingList.text floatValue]+[modelofshoppingcar.Goods[@"price"] floatValue]] ;
    }
    
    
}

-(void)payForShoppingCar
{
    _myOrderView=[[OrderForSureViewController alloc] initWithNibName:@"OrderForSureViewController" bundle:[NSBundle mainBundle]];
    _myOrderView.orderData=ShoppingCar;
    _myOrderView.resid=_resid;
    _myOrderView.peiSongFeiData=_peisongData;
    _myOrderView.orderSumPrice=_lableinShoppingList.text;
    [self.navigationController pushViewController:_myOrderView animated:YES];
}

-(void)CanTingXiangqingBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (dict[@"data"]) {
        [self addRightButton:@"shoucang@2x.png"];
        CGFloat y=CantingsegmentView.frame.origin.y+CantingsegmentView.frame.size.height;
        _CantingOtherPage=[[UIView alloc] initWithFrame:CGRectMake(0, y, KWidth, KHeight-y)];
        _CantingOtherPage.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        UIScrollView * otherViewScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-y)];
        otherViewScroll.scrollEnabled=YES;
        otherViewScroll.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        
        
        UIView * CantingHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _CantingOtherPage.frame.size.width,80)];
        CantingHeadView.backgroundColor=[UIColor whiteColor];
        UIImageView * cantingLogo=[[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 50, 50)];
        [cantingLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"logo"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [CantingHeadView addSubview:cantingLogo];
        UILabel * lbl_cantingName=[[UILabel alloc] initWithFrame:CGRectMake(cantingLogo.frame.origin.x+cantingLogo.frame.size.width+20, 10, 150, 20)];
        lbl_cantingName.text=dict[@"data"][@"name"];
        [CantingHeadView addSubview:lbl_cantingName];
        TQStarRatingView * pingjia=[[TQStarRatingView alloc]initWithFrame:CGRectMake(lbl_cantingName.frame.origin.x, lbl_cantingName.frame.origin.y+lbl_cantingName.frame.size.height+2, 80, 20) numberOfStar:[dict[@"data"][@"totalcredit"] intValue]];
        [CantingHeadView addSubview:pingjia];
        
        
        
        UIView * lastView=CantingHeadView;
        
        UIView * BackView_time=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, (KWidth-2)/3, 60)];
        BackView_time.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_qisongjia=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 40, 30)];
        lbl_qisongjia.text=[NSString stringWithFormat:@"¥%@",dict[@"data"][@"deliveryprice"]];
        [lbl_qisongjia setTextAlignment:NSTextAlignmentCenter];
        [BackView_time addSubview:lbl_qisongjia];
        UILabel * lbl_qisongjianame=[[UILabel alloc] initWithFrame:CGRectMake(lbl_qisongjia.frame.origin.x, lbl_qisongjia.frame.origin.y+lbl_qisongjia.frame.size.height+5, 40, 15)];
        lbl_qisongjianame.text=@"起送价";
        lbl_qisongjianame.font=[UIFont fontWithName:@"Helvetica" size:12];
        [lbl_qisongjianame setTextAlignment:NSTextAlignmentCenter];
        [BackView_time addSubview:lbl_qisongjianame];
        [otherViewScroll addSubview:BackView_time];
        
        UIView * BackView_WaiSongFei=[[UIView alloc] initWithFrame:CGRectMake(BackView_time.frame.origin.x+BackView_time.frame.size.width+1, lastView.frame.origin.y+lastView.frame.size.height+1, (KWidth-2)/3, 60)];
        BackView_WaiSongFei.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_waisongfei=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 40, 30)];
        lbl_waisongfei.text=[NSString stringWithFormat:@"¥%@",dict[@"data"][@"begindeliveryprice"]];
        [lbl_waisongfei setTextAlignment:NSTextAlignmentCenter];
        [BackView_WaiSongFei addSubview:lbl_waisongfei];
        UILabel * lbl_waisongfeiname=[[UILabel alloc] initWithFrame:CGRectMake(lbl_qisongjia.frame.origin.x, lbl_qisongjia.frame.origin.y+lbl_qisongjia.frame.size.height+5, 40, 15)];
        lbl_waisongfeiname.text=@"外送费";
        lbl_waisongfeiname.font=[UIFont fontWithName:@"Helvetica" size:12];
        [lbl_waisongfeiname setTextAlignment:NSTextAlignmentCenter];
        [BackView_WaiSongFei addSubview:lbl_waisongfeiname];
        [otherViewScroll addSubview:BackView_WaiSongFei];
        
        UIView * BackView_WaiSongTime=[[UIView alloc] initWithFrame:CGRectMake(BackView_WaiSongFei.frame.origin.x+BackView_WaiSongFei.frame.size.width+1, lastView.frame.origin.y+lastView.frame.size.height+1, (KWidth-2)/3, 60)];
        BackView_WaiSongTime.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_waisongtime=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 30)];
        lbl_waisongtime.text=[NSString stringWithFormat:@"%@",dict[@"data"][@"deliverytime"]];
        [lbl_waisongtime setTextAlignment:NSTextAlignmentCenter];
        [BackView_WaiSongTime addSubview:lbl_waisongtime];
        UILabel * lbl_waisongtimename=[[UILabel alloc] initWithFrame:CGRectMake(lbl_qisongjia.frame.origin.x, lbl_qisongjia.frame.origin.y+lbl_qisongjia.frame.size.height+5, 60, 15)];
        lbl_waisongtimename.text=@"外送时间";
        lbl_waisongtimename.font=[UIFont fontWithName:@"Helvetica" size:12];
        [lbl_waisongtimename setTextAlignment:NSTextAlignmentCenter];
        [BackView_WaiSongTime addSubview:lbl_waisongtimename];
        [otherViewScroll addSubview:BackView_WaiSongTime];
        
        lastView=BackView_WaiSongTime;
        UIView * BackView_userPingjia=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+5 , KWidth, 40)];
        BackView_userPingjia.backgroundColor=[UIColor whiteColor];
        UILabel * viewTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        [viewTitle setTextAlignment:NSTextAlignmentCenter];
        viewTitle.text=[NSString stringWithFormat:@"用户评论"];
        [BackView_userPingjia addSubview:viewTitle];
        UILabel * commentcount=[[UILabel alloc] initWithFrame:CGRectMake(viewTitle.frame.origin.x+viewTitle.frame.size.width+1, 10, 60, 20)];
        commentcount.text=[NSString stringWithFormat:@"(%@条)",dict[@"data"][@"commentCount"]];
        [BackView_userPingjia addSubview:commentcount];
        UIImageView * goImg=[[UIImageView alloc] initWithFrame:CGRectMake(KWidth-25, 10, 14, 20)];
        goImg.image=[UIImage imageNamed:@"go.png"];
        [BackView_userPingjia addSubview:goImg];
        [otherViewScroll addSubview:BackView_userPingjia];
        UIButton * btn_pingjia=[[UIButton alloc] initWithFrame:BackView_userPingjia.frame];
        [btn_pingjia addTarget:self action:@selector(GetPinglun) forControlEvents:UIControlEventTouchUpInside];
        [otherViewScroll addSubview:btn_pingjia];
        
        lastView=BackView_userPingjia;
        UIView * BackView_youhuiquan=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+5 , KWidth, 40)];
        BackView_youhuiquan.backgroundColor=[UIColor whiteColor];
        UIImageView * imgView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        imgView.image=[UIImage imageNamed:@"placeholder.png"];
        [BackView_youhuiquan addSubview:imgView];
        UILabel * lbl_Viewtitle=[[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+2, 10, 200, 20)];
        lbl_Viewtitle.text=[NSString stringWithFormat:@"餐厅可使用优惠券"];
        [BackView_youhuiquan addSubview:lbl_Viewtitle];
        [otherViewScroll addSubview:BackView_youhuiquan];
        
        lastView=BackView_youhuiquan;
        UIView * BackView_che=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+1 , KWidth, 40)];
        BackView_che.backgroundColor=[UIColor whiteColor];
        UIImageView * imgView_che=[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        imgView_che.image=[UIImage imageNamed:@"placeholder.png"];
        [BackView_che addSubview:imgView_che];
        UILabel * lbl_cheViewtitle=[[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+2, 10, 200, 20)];
        lbl_cheViewtitle.text=[NSString stringWithFormat:@"新用户可获Uber 5-50元券"];
        [BackView_che addSubview:lbl_cheViewtitle];
        [otherViewScroll addSubview:BackView_che];
        
        
        lastView=BackView_che;
        UIView * BackView_pic=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+5 , KWidth, 40)];
        BackView_pic.backgroundColor=[UIColor whiteColor];
        UILabel * picviewTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        picviewTitle.text=[NSString stringWithFormat:@"店铺相册"];
        [BackView_pic addSubview:picviewTitle];
        UILabel * piccount=[[UILabel alloc] initWithFrame:CGRectMake(viewTitle.frame.origin.x+viewTitle.frame.size.width+1, 10, 60, 20)];
        piccount.text=[NSString stringWithFormat:@"(%@条)",dict[@"data"][@"albumcount"]];
        [BackView_pic addSubview:piccount];
        goImg=[[UIImageView alloc] initWithFrame:CGRectMake(KWidth-25, 10, 14, 20)];
        goImg.image=[UIImage imageNamed:@"go.png"];
        [BackView_pic addSubview:goImg];
        [otherViewScroll addSubview:BackView_pic];
        UIButton * btn_pic=[[UIButton alloc] initWithFrame:BackView_pic.frame];
        [otherViewScroll addSubview:btn_pic];
        
        lastView=BackView_pic;
        UIView * yingyeTime=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+1 , KWidth, 40)];
        yingyeTime.backgroundColor=[UIColor whiteColor];
        UILabel * yingyeviewTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        [yingyeviewTitle setTextAlignment:NSTextAlignmentCenter];
        yingyeviewTitle.text=[NSString stringWithFormat:@"营业时间："];
        [yingyeTime addSubview:yingyeviewTitle];
        UILabel * lbl_time=[[UILabel alloc] initWithFrame:CGRectMake(viewTitle.frame.origin.x+viewTitle.frame.size.width+1, 10, 200, 20)];
        lbl_time.text=[NSString stringWithFormat:@"%@~%@",dict[@"data"][@"start"],dict[@"data"][@"end"]];
        [yingyeTime addSubview:lbl_time];
        [otherViewScroll addSubview:yingyeTime];
        
        lastView=yingyeTime;
        UIView * BackView_Tel=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+1 , KWidth, 40)];
        BackView_Tel.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_TelTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        [lbl_TelTitle setTextAlignment:NSTextAlignmentCenter];
        lbl_TelTitle.text=[NSString stringWithFormat:@"联系电话："];
        [BackView_Tel addSubview:lbl_TelTitle];
        UILabel * lbl_Tel=[[UILabel alloc] initWithFrame:CGRectMake(viewTitle.frame.origin.x+viewTitle.frame.size.width+1, 10, 200, 20)];
        lbl_Tel.text=[NSString stringWithFormat:@"%@",dict[@"data"][@"contactnum"]];
        [BackView_Tel addSubview:lbl_Tel];
        [otherViewScroll addSubview:BackView_Tel];
        
        
        lastView=[otherViewScroll.subviews lastObject];
        UIView * BackView_address=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+5 , KWidth, 40)];
        BackView_address.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_addressTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        [lbl_addressTitle setTextAlignment:NSTextAlignmentCenter];
        lbl_addressTitle.text=[NSString stringWithFormat:@"店铺地址："];
        [BackView_address addSubview:lbl_addressTitle];
        UILabel * lbl_address=[[UILabel alloc] initWithFrame:CGRectMake(viewTitle.frame.origin.x+viewTitle.frame.size.width+1, 10, 200, 20)];
        lbl_address.text=[NSString stringWithFormat:@"%@",dict[@"data"][@"addressname"]];
        [BackView_address addSubview:lbl_address];
        [otherViewScroll addSubview:BackView_address];
        
        
        lastView=[otherViewScroll.subviews lastObject];
        UIView * BackView_Show=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+5 , KWidth, 140)];
        BackView_Show.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_ShowTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        lbl_ShowTitle.text=[NSString stringWithFormat:@"简介："];
        [BackView_Show addSubview:lbl_ShowTitle];
        UILabel * lbl_Show=[[UILabel alloc] initWithFrame:CGRectMake(5, lbl_ShowTitle.frame.origin.y+lbl_ShowTitle.frame.size.height+2, BackView_Show.frame.size.width-10, 100)];
        lbl_Show.text=[NSString stringWithFormat:@"%@",dict[@"data"][@"introduction"]];
        [lbl_Show setLineBreakMode:NSLineBreakByWordWrapping];
        lbl_Show.numberOfLines=0;
        lbl_Show.font=[UIFont fontWithName:@"Helvetica" size:14];
        [BackView_Show addSubview:lbl_Show];
        [otherViewScroll addSubview:BackView_Show];
        
        
        otherViewScroll.contentSize=CGSizeMake(KWidth, BackView_Show.frame.origin.y+BackView_Show.frame.size.height);
        [otherViewScroll addSubview:CantingHeadView];
        [_CantingOtherPage addSubview:otherViewScroll];
        [self.view addSubview:_CantingOtherPage];
    }
    
}

-(void)GetPinglun
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getPinglunBackCall:"];
    [dataprovider GetPinglun:_resid andpage:@"1" andnumInPage:@"6" andiscontaintext:@"1"];
    
}
-(void)getPinglunBackCall:(id)dict
{
    NSLog(@"评论%@",dict);
}

-(void)clickRightButton:(UIButton *)sender
{
    
    if (dictionary) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"AddColctionBackCall:"];
        NSDictionary * prm=@{@"resid":_resid,@"userid":dictionary[@"userid"],@"type":@"1"};
        [dataprovider AddOrDelcollection:prm];
    }else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"请先登录" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
}
-(void)AddColctionBackCall:(id)dict
{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:dict[@"msg"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
    [self addRightButton:@"shoucang-@2x.png"];
}

@end