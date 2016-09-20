//
//  QuranTranslationInfo.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/10/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewImageLabelSwitchCell.h"
#import "QuranVerse.h"

@interface QuranTranslationInfo : NSObject <IItemWithTextImageAndSelection>

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* language;
@property (strong, nonatomic) NSString* pathTemplate;

- (NSString*)getTitleString;
- (UIImage*)getImage;
- (BOOL)isSelected;

- (NSString*)getTranslation:(QuranVerse*)verse;

@end
