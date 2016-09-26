//
//  QuranWordByWordTranslationCell.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/26/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseCell.h"
#import "MuslimLib.h"

@interface QuranWordByWordTranslationCell : BaseCell

@property (strong, nonatomic) UILabel* lblArabicText;
@property (strong, nonatomic) UILabel* lblTransliteration;
@property (strong, nonatomic) UILabel* lblTranslation;

@property (strong, nonatomic) VerseWordTranslation* model;

@end
