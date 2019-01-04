//
//  QSCIllAttrModel.h
//  qingsongchou
//
//  Created by yf on 2018/9/21.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSCIllAttrModel : NSObject

//是否选中
@property (nonatomic,copy) NSString * isSelect;  // 0是未选中    1是选中

@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * display_name;
@property (nonatomic,copy) NSString * channel;

@end
