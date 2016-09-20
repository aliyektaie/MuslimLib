//
//  CacheUtils.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/12/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheUtils : NSObject

+ (int)getCacheEntryIndex:(NSMutableArray*)cache withTitle:(NSString*)title;
+ (BOOL)hasCacheEntry:(NSMutableArray*)cache withTitle:(NSString*)title;
+ (id)getCachedContent:(NSMutableArray*)cache withTitle:(NSString*)title;
+ (void)setContentCache:(NSString*)title content:(id)content inCache:(NSMutableArray*)cache;

@end

@interface CacheEntry : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) id value;

@end
