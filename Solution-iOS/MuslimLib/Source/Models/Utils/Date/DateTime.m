//
//  DateTime.m
//  MemoreX
//
//  Created by Yektaie on 2/5/15.
//  Copyright (c) 2015 Yektaie. All rights reserved.
//

#import "DateTime.h"

@implementation DateTime

- (instancetype) init: (NSInteger)__year month: (NSInteger)__month day: (NSInteger)__day hour: (NSInteger)__hour minute: (NSInteger)__minute second: (NSInteger)__second {
    self = [super init];
    
    if (self) {
        self.year = __year;
        self.month = __month;
        self.day = __day;
        self.hour = __hour;
        self.minute = __minute;
        self.second = __second;
    }
    
    return self;
}

- (NSDate*) toNSDate {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:self.day];
    [comps setMonth:self.month];
    [comps setYear:self.year];
    [comps setHour:self.hour];
    [comps setMinute:self.minute];
    [comps setSecond:self.second];
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (DateTime*) fromNSDate:(NSDate*)date {
    DateTime* result = [[DateTime alloc] init];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    result.year = [components year];
    result.month = [components month];
    result.day = [components day];
    result.hour = [components hour];
    result.minute = [components minute];
    result.second = [components second];
    
    
    return result;
}

+ (DateTime*)now {
    NSDate* date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    DateTime* result = [[DateTime alloc] init:year month:month day:day hour:hour minute:minute second:second];
    return result;
}

- (NSString*)toString {
    return [NSString stringWithFormat:@"%d/%d/%d %d:%d:%d", (int)self.year, (int)self.month, (int)self.day, (int)self.hour, (int)self.minute, (int)self.second];
}
@end
