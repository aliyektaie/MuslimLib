//
//  QuranWordByWordTranslationCell.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/26/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseCell.h"
#import "MuslimLib.h"
#import <UIImageView+AFNetworking.h>

#define HEIGHT_OF_MORPHOLOGY_LABEL 25

@interface QuranWordByWordTranslationCell : BaseCell

@property (strong, nonatomic) UIImageView* lblArabicText;
@property (strong, nonatomic) UILabel* lblTransliteration;
@property (strong, nonatomic) NSMutableArray* morphologyLabels;
@property (strong, nonatomic) UILabel* lblTranslation;
@property (strong, nonatomic) UIImage* tempImage;

@property (strong, nonatomic) VerseWordTranslation* model;

@end
