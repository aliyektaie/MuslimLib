//
//  CacheUtils.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/12/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "CacheUtils.h"

#define MAX_CACHE_SIZE 20

@implementation CacheUtils

+ (int)getCacheEntryIndex:(NSMutableArray*)cache withTitle:(NSString*)title {
    int result = -1;

    for (int i = 0; i < cache.count; i++) {
        CacheEntry* entry = [cache objectAtIndex:i];

        if ([entry.title isEqualToString:title]) {
            result = i;
            break;
        }
    }

    return result;
}

+ (BOOL)hasCacheEntry:(NSMutableArray*)cache withTitle:(NSString*)title {
    return [CacheUtils getCacheEntryIndex:cache withTitle:title] >= 0;
}

+ (id)getCachedContent:(NSMutableArray*)cache withTitle:(NSString*)title {
    id result = nil;

    for (int i = 0; i < cache.count; i++) {
        CacheEntry* entry = [cache objectAtIndex:i];

        if ([entry.title isEqualToString:title]) {
            result = entry.value;
            break;
        }
    }

    return result;
}

+ (void)setContentCache:(NSString*)title content:(id)content inCache:(NSMutableArray*)cache {
    if (![CacheUtils hasCacheEntry:cache withTitle:title]) {
        CacheEntry* entry = [[CacheEntry alloc] init];
        entry.title = title;
        entry.value = content;

        [cache addObject:entry];

        while (cache.count > MAX_CACHE_SIZE) {
            [cache removeObjectAtIndex:0];
        }
    } else {
        NSInteger index = [self getCacheEntryIndex:cache withTitle:title];

        CacheEntry* entry = [cache objectAtIndex:index];
        [cache removeObjectAtIndex:index];
        [cache addObject:entry];
    }
}

@end

@implementation CacheEntry

@end
