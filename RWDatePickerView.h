//
//  RWDatePickerView.h
//  RunwuProject
//
//  Created by songmingguang on 2017/9/2.
//  Copyright © 2017年 qiaowandong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DateModel_start,
    DateModel_end,
} RWDateModel;

@interface RWDatePickerView : UIView

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, strong) NSDate *minimumDate;

@property (nonatomic ,assign) RWDateModel dateModel;//0： 开始时间  1： 结束时间
@property (nonatomic ,assign) NSInteger dateStyle;//0： 普通时间样式  1： 带 “至今” 样式

- (void)close:(id)sender;
-(BOOL)isToday;

@end
