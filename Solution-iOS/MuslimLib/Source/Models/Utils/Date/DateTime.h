//
//  DateTime.h
//  MemoreX
//
//  Created by Yektaie on 2/5/15.
//  Copyright (c) 2015 Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTime : NSObject

- (instancetype) init: (NSInteger)year month: (NSInteger)month day: (NSInteger)day hour: (NSInteger)hour minute: (NSInteger)minute second: (NSInteger)second;

@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger hour;
@property (assign, nonatomic) NSInteger minute;
@property (assign, nonatomic) NSInteger second;

+ (DateTime*)now;
- (NSDate*) toNSDate;
+ (DateTime*) fromNSDate:(NSDate*)date;
- (NSString*)toString;
@end
