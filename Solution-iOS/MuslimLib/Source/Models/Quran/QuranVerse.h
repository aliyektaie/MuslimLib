//
//  QuranVerse.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/11/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranSourahInfo.h"

@interface QuranVerse : NSObject

@property (assign, nonatomic) int verseNumber;
@property (strong, nonatomic) QuranSourahInfo* sourahInfo;
@property (strong, nonatomic) NSString* text;

- (QuranVerse*)cloneVerse;

@end
