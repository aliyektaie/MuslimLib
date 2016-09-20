//
//  ArabicLabel.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "ArabicLabel.h"
#import "Utils.h"
#import "Settings.h"
#import "NSString+MD5.h"
#import "CacheUtils.h"

#define SOURAH_HEADER_HEIGHT [self getSourahHeaderHeight]
#define AYA_SIGN_DIM [ArabicLabel getAyaSignDim]
#define AYA_SIGN_MARGIN 0
#define MAX_LINE_HEIGHT [self getLineHeight]
#define SPACE_WIDTH 5
#define VAGHF_SIGN_WIDTH 10

#define CTF(x) (x * 1.0 / 256)
#define SCALE(x) (x * 1.0 / [UIScreen mainScreen].scale)
#define LEFT_BORDER [self getBorderLeft]
#define RIGHT_BORDER [self getBorderRight]
#define VERTICAL_BORDER [self getVerticalMargins]
#define VIEW_WIDTH CGRectGetWidth(self.frame)
#define VIEW_HEIGHT CGRectGetHeight(self.frame)
#define CADR_WIDTH [self getCadreWidth]
#define CONTENT_MARGIN [self getContentMargin]
#define CONENT_RECT CGRectMake(LEFT_BORDER + CADR_WIDTH + CONTENT_MARGIN, VERTICAL_BORDER + CONTENT_MARGIN + [self getPageTopOffset], VIEW_WIDTH - LEFT_BORDER - RIGHT_BORDER - 2 * CADR_WIDTH - 2 * CONTENT_MARGIN, VIEW_HEIGHT - 2 * VERTICAL_BORDER - 2 * CADR_WIDTH - 2 * CONTENT_MARGIN)
#define SET_STROCK_COLOR CGContextSetRGBStrokeColor(context, CTF(140), CTF(105), CTF(0), 1.0)
#define MIN_LINE_HEIGHT ([self getFontSize] * 1.11)

#define MARGIN 10


@interface ArabicLabel() {
    NSMutableArray* lines;
    UIFont* verseSignFont;
}

@end

@implementation ArabicLabel

static UIImage* verseSign;
static UIFont* quranFont;
static NSMutableArray* cache;

- (instancetype)init {
    self = [super init];

    if (self) {
        verseSignFont = [Utils createDefaultFont:[self getVerseSignFont]];
        [ArabicLabel setup];

        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
    }

    return self;
}

+ (void)setup {
    if (quranFont == nil) {
        quranFont = [UIFont fontWithName:[Settings getDefaultArabicFont] size:[ArabicLabel getFontSize]];
        verseSign = [UIImage imageNamed:@"VerseSign"];
        cache = [[NSMutableArray alloc] init];
    }
}

+ (int)getFontSize {
    int result = 34;
    
    NSString* defaultFont = [Settings getDefaultArabicFont];
    if ([defaultFont isEqualToString:@"Scheherazade-Regular"]) {
        result = (int)(result * 1.0);
    } else if ([defaultFont isEqualToString:@"Al_Mushaf"]) {
        result = (int)(result * 0.95);
    } else if ([defaultFont isEqualToString:@"KFGQPCUthmanTahaNaskh"]) {
        result = (int)(result * 0.8);
    }
    
    return result;
}

+ (void)invalidateQuranFont {
    quranFont = nil;
}

- (void)setText:(NSString *)text {
    _text = text;

    lines = nil;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (lines == nil) {
        [self splitLines];
    }

    CGFloat currentY = 0;

    for (int i = 0; i < lines.count; i++) {
        NSString* line = [lines objectAtIndex:i];
        BOOL isLastLine = NO;
        if (i == lines.count - 1) {
            isLastLine = YES;
        }

        [self drawLine:line atY:currentY - 5 isEnd:isLastLine];
        currentY += [ArabicLabel getLineHeight];
    }
}

- (void)drawLine:(NSString*)line atY:(CGFloat)y isEnd:(BOOL)isLastLine {
    if (isLastLine) {
        [self drawQuranTextCenter:line xPosition:0 yPosition:y];
    } else {
        [self drawQuranText:line xPosition:0 yPosition:y];
    }
}

- (void)drawQuranTextCenter:(NSString*)text xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition
{
    [self drawQuranText:text xPosition:xPosition yPosition:yPosition center:YES];
}


- (void)drawQuranText:(NSString*)text xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition
{
    [self drawQuranText:text xPosition:xPosition yPosition:yPosition center:NO];
}

- (void)drawQuranText:(NSString*)text xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition center:(BOOL)shouldCenter {
    NSArray* words = [ArabicLabel removeEmpties:[text componentsSeparatedByString:@" "]];

    xPosition += MARGIN;
    CGFloat widthAvailable = CGRectGetWidth(self.frame) - 2 * MARGIN;
    CGFloat endX = xPosition + widthAvailable;

    CGFloat totalWidth = 0;
    int vaghfCount = 0;

    for (int i = 0; i < words.count; i++) {
        NSString* word = [words objectAtIndex:i];
        if ([word rangeOfString:@"["].location != NSNotFound) {
            totalWidth += AYA_SIGN_DIM;
        } else if ([word rangeOfString:@"<"].location != NSNotFound) {
            totalWidth += VAGHF_SIGN_WIDTH;
            vaghfCount++;
        } else {
            totalWidth += [ArabicLabel widthOfString:word withFont:quranFont];
        }
    }

    int bot = (int)(words.count - 1 - vaghfCount);
    CGFloat spaceWidth = 0;
    if (bot != 0) {
        spaceWidth = (widthAvailable - totalWidth) / bot;;
    }

    if (shouldCenter) {
        CGFloat tempSpace = 7;
        CGFloat temp = totalWidth + (words.count - 1) * tempSpace;
        if (temp < widthAvailable) {
            endX = xPosition + (widthAvailable + temp) / 2;
            widthAvailable = temp;
            spaceWidth = tempSpace;
        }
    }

    for (int i = 0; i < words.count; i++) {
        BOOL isVaghf = NO;
        NSString* word = [words objectAtIndex:i];

        CGFloat wordWidth = 0;

        if ([word rangeOfString:@"["].location != NSNotFound) {
            wordWidth = i == 0 ? AYA_SIGN_MARGIN + AYA_SIGN_DIM : 2 * AYA_SIGN_MARGIN + AYA_SIGN_DIM;

            CGRect verseSignRect;
            if (i == words.count - 1 && !shouldCenter) {
                verseSignRect = CGRectMake(AYA_SIGN_MARGIN, yPosition + [self getAyaTopMargin], AYA_SIGN_DIM, AYA_SIGN_DIM * 1.3f);
            } else {
                verseSignRect = CGRectMake(endX - wordWidth + AYA_SIGN_MARGIN, yPosition + [self getAyaTopMargin], AYA_SIGN_DIM, AYA_SIGN_DIM * 1.3f);
            }
            [verseSign drawInRect:verseSignRect];

            verseSignRect = CGRectMake(verseSignRect.origin.x, verseSignRect.origin.y + 0.40f * AYA_SIGN_DIM, CGRectGetWidth(verseSignRect), [self getVerseSignFont]);

            word = [word substringFromIndex:1];
            word = [word substringToIndex:word.length - 1];

            NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            textStyle.alignment = NSTextAlignmentCenter;

            NSDictionary* textFontAttributes = @{NSFontAttributeName: verseSignFont, NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: textStyle};

            [word drawInRect:verseSignRect withAttributes: textFontAttributes];
        } else if ([word rangeOfString:@"<"].location != NSNotFound) {
            wordWidth = VAGHF_SIGN_WIDTH;
            int vaghfPriorSpace = (int)(spaceWidth * 0.7);

            word = [self getVaghfText:word];

            CGRect textRect = CGRectMake(endX - wordWidth + vaghfPriorSpace, yPosition, 50, [ArabicLabel getLineHeight]);
            NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            textStyle.alignment = NSTextAlignmentLeft;

            NSDictionary* textFontAttributes = @{NSFontAttributeName: quranFont, NSForegroundColorAttributeName: [UIColor redColor], NSParagraphStyleAttributeName: textStyle};

            [word drawInRect: textRect withAttributes: textFontAttributes];
            isVaghf = YES;
        } else {
            wordWidth = [ArabicLabel widthOfString:word withFont:quranFont];

            CGRect textRect = CGRectMake(endX - wordWidth, yPosition, wordWidth, [ArabicLabel getLineHeight] * 10);
            NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            textStyle.alignment = NSTextAlignmentLeft;

            NSDictionary* textFontAttributes = @{NSFontAttributeName: quranFont, NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: textStyle};
            
            [word drawInRect: textRect withAttributes: textFontAttributes];
        }
        
        endX = endX - wordWidth - (isVaghf ? 0 : spaceWidth);
    }
}

- (NSString*)getVaghfText:(NSString*)vaghfSign {
    NSString* result = @"";

    if ([vaghfSign isEqualToString:@"<moaneghe>"]) {
        result = @"ۛ";
    } else if ([vaghfSign isEqualToString:@"<sali>"]) {
        result = @"ۖ";
    } else if ([vaghfSign isEqualToString:@"<jayez>"]) {
        result = @"ۚ";
    } else if ([vaghfSign isEqualToString:@"<motlagh>"]) {
        result = @"ۢ";
    } else if ([vaghfSign isEqualToString:@"<mamnu>"]) {
        result = @"ۙ";
    } else if ([vaghfSign isEqualToString:@"<gholi>"]) {
        result = @"ۗ";
    }

    return result;
}

- (void)splitLines {
    CGFloat lineWidth = CGRectGetWidth(self.frame) - 2 * MARGIN;

    lines = [ArabicLabel splitLineStatic:lineWidth text:self.text font:quranFont];
}

+ (NSMutableArray*)splitLineStatic:(CGFloat)lineWidth text:(NSString*)text font:(UIFont*)font {
    
    NSString* currentLine = @"";
    CGFloat remainedInLine = lineWidth;
    NSMutableArray* lines = [[NSMutableArray alloc] init];
    int verseSignCountInLine = 0;
    int verseSignWidthInLine = 0;

    NSArray* words = [ArabicLabel removeEmpties:[text componentsSeparatedByString:@" "]];
    for (int j = 0; j < words.count; j++) {
        BOOL allowSplitLine = YES;
        NSString* word = [words objectAtIndex:j];
        CGFloat wordWidth = 0;

        if ([word rangeOfString:@"["].location != NSNotFound) {
            wordWidth = 2 * AYA_SIGN_MARGIN + AYA_SIGN_DIM;
            verseSignWidthInLine += [ArabicLabel widthOfString:word withFont:font];
            verseSignCountInLine++;
        } else if ([word rangeOfString:@"<"].location != NSNotFound) {
            wordWidth = VAGHF_SIGN_WIDTH;
            allowSplitLine = NO;
        } else {
            wordWidth = [ArabicLabel widthOfString:word withFont:font];
        }

        if (remainedInLine - wordWidth <= 0 && allowSplitLine) {
            remainedInLine = lineWidth;
            [lines addObject:currentLine];

            currentLine = @"";
            verseSignCountInLine = 0;
            verseSignWidthInLine = 0;
        }

        if ([currentLine length] == 0) {
            currentLine = word;
        } else {
            currentLine = [NSString stringWithFormat:@"%@ %@", currentLine, word];
        }

        remainedInLine = lineWidth - ([ArabicLabel widthOfString:[ArabicLabel replaceVaghfs:currentLine with:@"*"] withFont:font] - verseSignWidthInLine + verseSignCountInLine * AYA_SIGN_DIM);
    }


    if ([currentLine length] > 0) {
        [lines addObject:currentLine];
    }

    return lines;
}

+ (NSString*)replaceVaghfs:(NSString*)aya with:(NSString*)replacement {
    aya = [aya stringByReplacingOccurrencesOfString:@"<moaneghe>" withString:replacement];
    aya = [aya stringByReplacingOccurrencesOfString:@"<sali>" withString:replacement];
    aya = [aya stringByReplacingOccurrencesOfString:@"<gholi>" withString:replacement];
    aya = [aya stringByReplacingOccurrencesOfString:@"<mamnu>" withString:replacement];
    aya = [aya stringByReplacingOccurrencesOfString:@"<jayez>" withString:replacement];
    aya = [aya stringByReplacingOccurrencesOfString:@"<motlagh>" withString:replacement];

    return aya;
}

static NSMutableDictionary* stringWidthCache;

+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    if (stringWidthCache == nil) {
        stringWidthCache = [[NSMutableDictionary alloc] init];
    }
    
    NSString* hash = [NSString stringWithFormat:@"%@[at]%@%d", [string md5Hash], font.fontName, (int)font.pointSize];
    
    TempFloatContainer* value = [stringWidthCache objectForKey:hash];
    if (value == nil) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        CGFloat w = [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
        value = [[TempFloatContainer alloc] init];
        value.value = w;
    
        [stringWidthCache setObject:value forKey:hash];
    }
    
    return value.value;
}

+ (NSMutableArray*)removeEmpties:(NSArray*)list {
    NSMutableArray* result = [[NSMutableArray alloc] init];

    for (int i = 0; i < [list count]; i++) {
        NSString* l = [list objectAtIndex:i];
        if ([l length] > 0) {
            [result addObject:l];
        }
    }

    return result;
}

+ (int)getAyaSignDim {
    int result = 30;

    return result;
}

- (int)getAyaTopMargin {
    int result = 0;

    result = 7;
    return result;
}

- (CGFloat)getVerseSignFont {
    int result = 12;

    return result;
}

+ (int)getLineHeight {
    int result = 0;

    result = 60;
    return result;
}

+ (int)getHeightForText:(NSString*)text inWidth:(int)width {
    [ArabicLabel setup];

    NSArray* lines = [ArabicLabel splitLineStatic:width - 2 * MARGIN text:text font:quranFont];
    return (int)(lines.count * [ArabicLabel getLineHeight]);
}


@end

@implementation TempFloatContainer

@end
