//
//  QuranVerse.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/11/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranVerse.h"

@implementation QuranVerse

- (QuranVerse*)cloneVerse {
    QuranVerse* result = [[QuranVerse alloc] init];

    result.verseNumber = self.verseNumber;
    result.sourahInfo = self.sourahInfo;
    result.text = self.text;

    return result;
}
@end
