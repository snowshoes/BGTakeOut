//
//  YJViewController.h
//  SMS_SDKDemo
//
//  Created by 中扬科技 on 14-6-27.
//  Copyright (c) 2014年 中扬科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SMS_SDK/SMS_SDKResultHanderDef.h>

@interface YJViewController : UIViewController

@property(nonatomic,strong)  UIButton *friends;
@property(nonatomic,strong)  UIButton *registerUserBtn;
@property(nonatomic,strong) ShowNewFriendsCountBlock friendsBlock;

@end
