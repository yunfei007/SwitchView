//
//  QSCIllSwitchView.h
//  qingsongchou
//
//  Created by yf on 2018/9/21.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSCIllSwitchView : UIView

@property (nonatomic,assign) int defaultIndex;

@property (nonatomic,strong) NSArray * illDataArr;

//选中某栏目回调
@property (nonatomic,copy) void (^switchBlock)(NSString * channelIndex,NSString * channel,int index);


-(void)setSelectIndex:(int)index;

@end
