//
//  RWDatePickerView.m
//  RunwuProject
//
//  Created by songmingguang on 2017/9/2.
//  Copyright © 2017年 qiaowandong. All rights reserved.
//

#import "RWDatePickerView.h"

static const NSInteger yearStart = 1949;
static const NSInteger yearCount = 100;
static const NSInteger monthCount = 12;

@interface RWDatePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,assign) NSInteger currentYear;
@property (nonatomic ,assign) NSInteger currentMonth;
@property (nonatomic ,assign) NSInteger currentDay;
@property (nonatomic ,assign) NSInteger dayCount;

@end
@implementation RWDatePickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        [self addGestureRecognizer:tap];

        [self initDate];
        _picker = [[UIPickerView alloc]initWithFrame:self.bounds];
        _picker.alpha = 0.7;
        _picker.backgroundColor = [UIColor whiteColor];
        _picker.delegate = self;
        [self addSubview:_picker];

        [self checkDefaultDate];
    }
    return self;
}
-(void)initDate{
    NSDate *currentDate = [NSDate date];
    _currentYear = currentDate.year;
    _currentMonth = currentDate.month;
    _currentDay = currentDate.day;
    _dayCount = [self getNumberOfDaysInMonth];
    
    _dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",_currentYear,_currentMonth,_currentDay];
}
-(void)checkDefaultDate{
    NSDate *currentDate = [NSDate date];
    if (![_dateString isEqualToString:@"至今"]) {
         currentDate = [NSDate dateWithFormaterString:_dateString];
    }
    NSComparisonResult resultMin = [self.minimumDate compare:currentDate];
    NSComparisonResult resultMax = [self.maximumDate compare:currentDate];
    
    if (resultMin == NSOrderedDescending) {
        [_picker selectRow:self.minimumDate.year-yearStart inComponent:0 animated:YES];
        [_picker selectRow:self.minimumDate.month-1 inComponent:1 animated:YES];
        [_picker selectRow:self.minimumDate.day-1 inComponent:2 animated:YES];
        [self refreshDateStringWithDate:self.minimumDate];
    }else if(resultMax==NSOrderedAscending){
        [_picker selectRow:self.maximumDate.year-yearStart inComponent:0 animated:YES];
        [_picker selectRow:self.maximumDate.month-1 inComponent:1 animated:YES];
        [_picker selectRow:self.maximumDate.day-1 inComponent:2 animated:YES];
        [self refreshDateStringWithDate:self.maximumDate];
    }else{
        [_picker selectRow:currentDate.year-yearStart inComponent:0 animated:YES];
        [_picker selectRow:currentDate.month-1 inComponent:1 animated:YES];
        [_picker selectRow:currentDate.day-1 inComponent:2 animated:YES];
    }
}
-(void)refreshDateStringWithDate:(NSDate *)date{
    _currentYear = date.year;
    _currentMonth = date.month;
    _currentDay = date.day;
    _dayCount = [self getNumberOfDaysInMonth];
    _dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",_currentYear,_currentMonth,_currentDay];
}
-(void)refreshDateString{
    if ([self isToday]&&_dateStyle == 1){
        _dateString = @"至今";
    }else{
        _dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",_currentYear,_currentMonth,_currentDay];
    }
}
-(NSDate *)minimumDate{
    if (!_minimumDate) {
        _minimumDate =  [NSDate dateWithFormaterString:@"1949-1-1"];
    }
    return _minimumDate;
}
-(NSDate *)maximumDate{
    if (!_maximumDate) {
        _maximumDate =  [NSDate dateWithFormaterString:@"2049-1-1"];
    }
    return _maximumDate;
}
-(RWDateModel )dateModel{
    if (!_dateModel) {
        _dateModel =  DateModel_start;
    }
    return _dateModel;
}
-(NSInteger )dateStyle{
    if (!_dateStyle) {
        _dateStyle =  0;
    }
    [self refreshDateString];
    return _dateStyle;
}
#pragma mark - picker -

// 返回pickerView的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 27;
}

// 返回pickerView 每行的内容
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        NSInteger year = yearStart+row;
        if (self.dateStyle == 1) {
            if([self isToday]&&year == [NSDate date].year){
                return @"至今";
            }
        }
        
        return [NSString stringWithFormat:@"%ld",year];
    }else if(component == 1){
        if (self.dateStyle == 1) {
            if([self isToday]&&row+1 == [NSDate date].month){
                return @"--";
            }
        }
        return [NSString stringWithFormat:@"%ld",row+1];
    }else{
        if (self.dateStyle == 1) {
            if([self isToday]&&row+1 == [NSDate date].day){
                return @"--";
            }
        }
        return [NSString stringWithFormat:@"%ld",row+1];
    }
    return nil;
}
-(BOOL)isToday{
    if (_currentYear == [NSDate date].year&&_currentMonth == [NSDate date].month&&_currentDay == [NSDate date].day) {
        return YES;
    }
    return NO;
}
//// 返回pickerView 每行的view
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
//
//}

// 选中行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(component == 0){
        _currentYear = yearStart+row;
    }else if(component == 1){
        _currentMonth = row+1;
        [self getNumberOfDaysInMonth];
    }else{
        _currentDay = row+1;
    }
    [self refreshDateString];
    [self checkDefaultDate];
    [pickerView reloadAllComponents];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return yearCount;
    }else if (component == 1){
        return monthCount;
    }else{
        return _dayCount;
    }
    
}


- (NSInteger)getNumberOfDaysInMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese]; // 指定日历的算法
    
    NSDate * currentDate = [NSDate dateWithFormaterString:[NSString stringWithFormat:@"%ld-%ld-%ld",_currentYear,_currentMonth,_currentDay]];
    // 只要个时间给日历,就会帮你计算出来。这里的时间取当前的时间。
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:currentDate];
    _dayCount = range.length;
    return range.length;
}
- (void)updateConstraints {
    [super updateConstraints];
    if (_picker) {
        _picker.frame = self.bounds;
    }
}

- (void)close:(id)sender {
    [self removeFromSuperview];
}

@end
