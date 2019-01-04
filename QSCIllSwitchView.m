//
//  QSCIllSwitchView.m
//  qingsongchou
//
//  Created by yf on 2018/9/21.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import "QSCIllSwitchView.h"
#import "QSCIllAttrModel.h"
#import "QSCCommunityChannelModel.h"
#import "QSCCommunitySubChannelModel.h"
#import "QSCGlobalMethod.h"

@interface QSCIllSwitchView()

@property(nonatomic,strong)UIScrollView *sv;
//sv的内容view
@property(nonatomic,strong)UIView * container;
//view
@property(nonatomic,strong)UIView * bottomLineView;

@end

@implementation QSCIllSwitchView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self stepSubViews];
    }
    return self;
}

-(void)stepSubViews
{
    _sv = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.pagingEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollView];
        
        scrollView;
    });
    [self.sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    
    _container = ({
        UIView *container = [UIView new];
        container.backgroundColor = [UIColor clearColor];
        [self.sv addSubview:container];
        
        container;
    });
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.sv);
        make.height.equalTo(self.sv);
    }];
    
    //底部分割线
    UIView * cutLine = [[UIView alloc] init];
    cutLine.backgroundColor = [UIColor colorWithGivenHexColorString:@"#e5e5e5"];
    [self addSubview:cutLine];
    
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(-10);
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setIllDataArr:(NSArray *)illDataArr
{
    if (illDataArr) {
        _illDataArr = illDataArr.mutableCopy;
    }else{
        _illDataArr = [[NSMutableArray alloc] init];
    }
    
    //清空
    for (UIView * subView in _container.subviews) {
        [subView removeFromSuperview];
    }
    //过渡视图添加子视图
    UIView *previousView =nil;
    for(int i =0; i<_illDataArr.count; i++){
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        
        id model = _illDataArr[i];
        if ([model isKindOfClass:[QSCCommunitySubChannelModel class]]) {
            QSCCommunitySubChannelModel * subChannelModel = (QSCCommunitySubChannelModel *)model;
            NSString * title = subChannelModel.channel_name;
            [btn setTitle:title forState:UIControlStateNormal];
        }else if ([model isKindOfClass:[QSCCommunityChannelModel class]]){
            QSCCommunityChannelModel * channelModel = (QSCCommunityChannelModel *)model;
            NSString * title = channelModel.channel_name;
            [btn setTitle:title forState:UIControlStateNormal];
        }else{
            QSCIllAttrModel * attrModel = (QSCIllAttrModel *)model;
            NSString * title = attrModel.display_name;
            [btn setTitle:title forState:UIControlStateNormal];
        }
        
        if (i==_defaultIndex) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        }else{
            btn.selected = NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        
        [btn setTitleColor:[UIColor colorWithGivenHexColorString:@"#666666"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithGivenHexColorString:@"#333333"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:btn];
        
        CGFloat width = [QSCGlobalMethod sizeOfText:btn.titleLabel.text font:16].width+30;

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(_container);
            make.width.mas_equalTo(width);
            
            if (previousView)
            {
                if (i==1) {
                    make.left.equalTo(previousView.mas_right).offset(0);
                }else{
                    make.left.mas_equalTo(previousView.mas_right);
                }
            }
            else
            {
                make.left.mas_equalTo(0);
            }
        }];
        
        previousView = btn;
    }
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(previousView.mas_right);
    }];
    
    
    //底部横线
    UIButton * tempBtn = _container.subviews[_defaultIndex];
    
    _bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = [UIColor colorWithGivenHexColorString:@"#43ac43"];
    [_container addSubview:self.bottomLineView];
    
    CGFloat lastX = _bottomLineView.center.x;
    
    CGFloat w = [QSCGlobalMethod sizeOfText:tempBtn.titleLabel.text font:16].width+5;
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_container);
        make.centerX.mas_equalTo(tempBtn);
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(2.5);
    }];
    
    // 注意需要再执行一次更新约束
    [self layoutIfNeeded];
    
    if (_sv.contentSize.width > _sv.width) {
        int p = _sv.contentSize.width / _sv.width;
        CGFloat wMax = _sv.contentSize.width - p*(_sv.width);
        if (_bottomLineView.center.x > lastX) {
            //左滑时
            CGFloat w = _bottomLineView.center.x - self.center.x;
            if(w>0 && _sv.contentOffset.x < wMax){
                if ((_sv.contentOffset.x + w) < wMax) {
                    _sv.contentOffset = CGPointMake(_sv.contentOffset.x + w, 0);
                }else{
                    _sv.contentOffset = CGPointMake(wMax, 0);
                }
            }
        }else{
            //右滑时
            CGFloat w = self.center.x - (_sv.contentSize.width-_bottomLineView.center.x);
            if (w<0 && _sv.contentOffset.x > 0) {
                if ((_sv.contentOffset.x + w) > 0) {
                    _sv.contentOffset = CGPointMake(_sv.contentOffset.x + w, 0);
                }else{
                    _sv.contentOffset = CGPointMake(0, 0);
                }
            }
        }
    }
}

-(void)btnClick:(UIButton *)btn
{
    for (UIView * subView in self.container.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)subView;
            button.selected = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    btn.selected = YES;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    CGFloat width = [QSCGlobalMethod sizeOfText:btn.titleLabel.text font:16].width;
    
    CGFloat lastX = _bottomLineView.center.x;
    
    [UIView animateWithDuration:0.25 animations:^{
        [_bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_container);
            make.centerX.mas_equalTo(btn);
            make.width.mas_equalTo(width+5);
            make.height.mas_equalTo(2.5);
        }];
        
        // 注意需要再执行一次更新约束
        [self layoutIfNeeded];
        
        if (_sv.contentSize.width > _sv.width) {
            int p = _sv.contentSize.width / _sv.width;
            CGFloat wMax = _sv.contentSize.width - p*(_sv.width);
            if (_bottomLineView.center.x > lastX) {
                //左滑时
                CGFloat w = _bottomLineView.center.x - self.center.x;
                if(w>0 && _sv.contentOffset.x < wMax){
                    if ((_sv.contentOffset.x + w) < wMax) {
                        _sv.contentOffset = CGPointMake(_sv.contentOffset.x + w, 0);
                    }else{
                        _sv.contentOffset = CGPointMake(wMax, 0);
                    }
                }
            }else{
                //右滑时
                CGFloat w = self.center.x - (_sv.contentSize.width-_bottomLineView.center.x);
                if (w<0 && _sv.contentOffset.x > 0) {
                    if ((_sv.contentOffset.x + w) > 0) {
                        _sv.contentOffset = CGPointMake(_sv.contentOffset.x + w, 0);
                    }else{
                        _sv.contentOffset = CGPointMake(0, 0);
                    }
                }
            }
        }
    }];
    
    NSString * channel = @"";
    
    id model = _illDataArr[btn.tag-100];
    if ([model isKindOfClass:[QSCCommunitySubChannelModel class]]) {
        QSCCommunitySubChannelModel * subChannelModel = (QSCCommunitySubChannelModel *)model;
        channel = subChannelModel.channel_id;
        self.switchBlock(subChannelModel.channel_index,channel,btn.tag-100);
    }else if ([model isKindOfClass:[QSCCommunityChannelModel class]]){
        QSCCommunityChannelModel * channelModel = (QSCCommunityChannelModel *)model;
        channel = channelModel.channel_id;
        self.switchBlock(channelModel.channel_index,channel,btn.tag-100);
    }else{
        QSCIllAttrModel * attrModel = (QSCIllAttrModel *)model;
        channel = attrModel.channel;
        self.switchBlock(@"",channel,btn.tag-100);
    }
    
}

-(void)setSelectIndex:(int)index
{
    for (UIView * subView in self.container.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)subView;
            button.selected = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    
    NSArray * subViews = _container.subviews;
    UIButton * btn = subViews[index];
    btn.selected = YES;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    NSLog(@"%f--%f--%@",btn.x,btn.width,btn.titleLabel.text);
    CGFloat width = [QSCGlobalMethod sizeOfText:btn.titleLabel.text font:16].width;
    
    CGFloat lastX = _bottomLineView.center.x;
    
    [UIView animateWithDuration:0.25 animations:^{
        [_bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_container);
            make.centerX.mas_equalTo(btn);
            make.width.mas_equalTo(width+5);
            make.height.mas_equalTo(2.5);
        }];
        
        // 注意需要再执行一次更新约束
        [self layoutIfNeeded];
        
        if (_sv.contentSize.width > _sv.width) {
            int p = _sv.contentSize.width / _sv.width;
            CGFloat wMax = _sv.contentSize.width - p*(_sv.width);
            if (_bottomLineView.center.x > lastX) {
                //左滑时
                CGFloat w = _bottomLineView.center.x - self.center.x;
                if(w>0 && _sv.contentOffset.x < wMax){
                    if ((_sv.contentOffset.x + w) < wMax) {
                        _sv.contentOffset = CGPointMake(_sv.contentOffset.x + w, 0);
                    }else{
                        _sv.contentOffset = CGPointMake(wMax, 0);
                    }
                }
            }else{
                //右滑时
                CGFloat w = self.center.x - (_sv.contentSize.width-_bottomLineView.center.x);
                if (w<0 && _sv.contentOffset.x > 0) {
                    if ((_sv.contentOffset.x + w) > 0) {
                        _sv.contentOffset = CGPointMake(_sv.contentOffset.x + w, 0);
                    }else{
                        _sv.contentOffset = CGPointMake(0, 0);
                    }
                }
            }
        }
    }];
}
@end
