//
//  QuranPageCell.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/10/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranPageView.h"
#import "Utils.h"
#import "MuslimLib.h"
#import "Settings.h"

#define SOURAH_HEADER_HEIGHT [self getSourahHeaderHeight]
#define AYA_SIGN_DIM [self getAyaSignDim]
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

@interface QuranPageView() {
    UIFont* quranFont;
    UIFont* verseSignFont;
    NSMutableArray* lines;
    int lineHeight;
    int updatedFontSize;
}

@end

@implementation QuranPageView

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self setup];
    }
    
    return self;
}


static NSMutableArray* splittedLineCache;

static UIImage* verseSign;
static UIImage* besmAllah;

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.page = 10;
    if (verseSign == nil) {
        verseSign = [UIImage imageNamed:@"VerseSign"];
        splittedLineCache = [[NSMutableArray alloc] init];

        besmAllah = [UIImage imageNamed:@"BesmAllah"];
    }

    quranFont = [UIFont fontWithName:[Settings getDefaultArabicFont] size:[self getFontSize]];
    verseSignFont = [Utils createDefaultFont:[self getVerseSignFont]];
}

- (void)setPage:(int)page {
    _page = page;

    updatedFontSize = 0;
    quranFont = [UIFont fontWithName:[Settings getDefaultArabicFont] size:[self getFontSize]];

    self.content = [self cloneContent:[[MuslimLib instance] getQuranVersesForPage:page]];
    for (int i = 0; i < self.content.count; i++) {
        QuranVerse* verse = [self.content objectAtIndex:i];
        verse.text = [verse.text stringByAppendingString:[NSString stringWithFormat:@" [%@] ", [Utils formatNumber:verse.verseNumber]]];
    }

    lines = nil;
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self setNeedsDisplay];
}

- (NSArray*)cloneContent:(NSArray*)array {
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:array.count];

    for (int i = 0; i < array.count; i++) {
        QuranVerse* verse = [array objectAtIndex:i];
        [result addObject:[verse cloneVerse]];
    }

    return result;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    [self drawBackground:rect];

    if (lines == nil) {
        [self splitLines];
    }

    CGFloat currentY = 0;

    for (int i = 0; i < lines.count; i++) {
        NSString* line = [lines objectAtIndex:i];
        if ([line isEqualToString:@"<new sourah>"]) {
            i++;
            int sourahIndex = [[lines objectAtIndex:i] intValue];
            [self drawSourahBegining:sourahIndex atY:currentY];

            currentY += SOURAH_HEADER_HEIGHT;
            continue;
        } else if ([line isEqualToString:@"<end sourah>"]) {
            continue;
        }

        BOOL isLastLine = NO;
        if (i == lines.count - 1) {
            isLastLine = YES;
        } else {
            isLastLine = [[lines objectAtIndex:i + 1] isEqualToString:@"<end sourah>"];
        }

        [self drawLine:line atY:currentY isEnd:isLastLine];
        currentY += lineHeight;
    }
}

- (void)drawSourahBegining:(int)sourahIndex atY:(CGFloat)y {
    y += (CADR_WIDTH + VERTICAL_BORDER + [self getPageTopOffset]);
    int margin = 5;

    CGContextRef context = UIGraphicsGetCurrentContext();
    SET_STROCK_COLOR;
    CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint(context, LEFT_BORDER + CADR_WIDTH, y + SOURAH_HEADER_HEIGHT - margin);
    CGContextAddLineToPoint(context, VIEW_WIDTH - RIGHT_BORDER - CADR_WIDTH, y + SOURAH_HEADER_HEIGHT - margin);
    CGContextStrokePath(context);

    CGContextMoveToPoint(context, LEFT_BORDER + CADR_WIDTH, y + margin);
    CGContextAddLineToPoint(context, VIEW_WIDTH - RIGHT_BORDER - CADR_WIDTH, y + margin);
    CGContextStrokePath(context);

    if (sourahIndex != 9 && sourahIndex != 1) {
        int besmHeight = (int)((SOURAH_HEADER_HEIGHT - 5 * margin) * 0.6);
        int besmWidth = (int)(besmHeight * 7.46);

        CGRect besmRect = CGRectMake(LEFT_BORDER + CADR_WIDTH + ((VIEW_WIDTH - LEFT_BORDER - RIGHT_BORDER - 2 * CADR_WIDTH) - besmWidth) / 2, y + 2 * margin, besmWidth, besmHeight);
        [besmAllah drawInRect:besmRect];

        NSString* title = [@"سوره " stringByAppendingString:[[MuslimLib instance] getSourahInfo:sourahIndex].titleArabic];

        UIFont* titleFont = [UIFont fontWithName:@"IRANSans" size:[self getSourahTitleFontSize:NO]];
        CGFloat width = [self widthOfString:title withFont:titleFont];
        CGRect textRect = CGRectMake(LEFT_BORDER + CADR_WIDTH + ((VIEW_WIDTH - LEFT_BORDER - RIGHT_BORDER - 2 * CADR_WIDTH) - width) / 2, y + 3 * margin + besmHeight, width, 100);
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentLeft;

        NSDictionary* textFontAttributes = @{NSFontAttributeName: titleFont, NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: textStyle};

        [title drawInRect: textRect withAttributes: textFontAttributes];
    } else {
        NSString* title = [@"سوره " stringByAppendingString:[[MuslimLib instance] getSourahInfo:sourahIndex].titleArabic];

        UIFont* titleFont = [UIFont fontWithName:@"IRANSans" size:[self getSourahTitleFontSize:YES]];
        CGFloat width = [self widthOfString:title withFont:titleFont];
        CGRect textRect = CGRectMake(LEFT_BORDER + CADR_WIDTH + ((VIEW_WIDTH - LEFT_BORDER - RIGHT_BORDER - 2 * CADR_WIDTH) - width) / 2, y + 2 * margin, width, 100);
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentLeft;

        NSDictionary* textFontAttributes = @{NSFontAttributeName: titleFont, NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: textStyle};

        [title drawInRect: textRect withAttributes: textFontAttributes];
    }
}

- (void)drawLine:(NSString*)line atY:(CGFloat)y isEnd:(BOOL)isLastLine {
    if (isLastLine) {
        [self drawQuranTextCenter:line xPosition:0 yPosition:y];
    } else {
        [self drawQuranText:line xPosition:0 yPosition:y];
    }
}

- (void)drawQuranText:(NSString*)text xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition
{
    [self drawQuranText:text xPosition:xPosition yPosition:yPosition center:NO];
}

- (void)drawQuranText:(NSString*)text xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition center:(BOOL)shouldCenter {
    NSArray* words = [self removeEmpties:[text componentsSeparatedByString:@" "]];

    CGFloat widthAvailable = CGRectGetWidth(CONENT_RECT);
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
            totalWidth += [self widthOfString:word withFont:quranFont];
        }
    }

    CGFloat spaceWidth = (widthAvailable - totalWidth) / (words.count - 1 - vaghfCount);

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
                verseSignRect = CGRectMake(AYA_SIGN_MARGIN + CONENT_RECT.origin.x, CONENT_RECT.origin.y + yPosition + [self getAyaTopMargin], AYA_SIGN_DIM, AYA_SIGN_DIM * 1.3f);
            } else {
                verseSignRect = CGRectMake(endX - wordWidth + AYA_SIGN_MARGIN + CONENT_RECT.origin.x, CONENT_RECT.origin.y + yPosition + [self getAyaTopMargin], AYA_SIGN_DIM, AYA_SIGN_DIM * 1.3f);
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

            CGRect textRect = CGRectMake(endX - wordWidth + vaghfPriorSpace + CONENT_RECT.origin.x,CONENT_RECT.origin.y + yPosition, 50, lineHeight);
            NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            textStyle.alignment = NSTextAlignmentLeft;

            NSDictionary* textFontAttributes = @{NSFontAttributeName: quranFont, NSForegroundColorAttributeName: [UIColor redColor], NSParagraphStyleAttributeName: textStyle};

            [word drawInRect: textRect withAttributes: textFontAttributes];
            isVaghf = YES;
        } else {
            wordWidth = [self widthOfString:word withFont:quranFont];

            CGRect textRect = CGRectMake(endX - wordWidth + CONENT_RECT.origin.x,CONENT_RECT.origin.y + yPosition, wordWidth, lineHeight * 2);
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

- (void)drawQuranTextCenter:(NSString*)text xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition
{
    [self drawQuranText:text xPosition:xPosition yPosition:yPosition center:YES];
}

- (void)splitLines {
    CGFloat lineWidth = CGRectGetWidth(CONENT_RECT);
    NSString* currentLine = @"";
    CGFloat remainedInLine = lineWidth;
    lines = [[NSMutableArray alloc] init];
    int verseSignCountInLine = 0;
    int verseSignWidthInLine = 0;

    for (int i = 0; i < self.content.count; i++) {
        QuranVerse* verse = [self.content objectAtIndex:i];

        if (verse.verseNumber == 1) {
            remainedInLine = lineWidth;
            if ([currentLine length] > 0) {
                [lines addObject:currentLine];
                [lines addObject:@"<end sourah>"];
            }
            [lines addObject:@"<new sourah>"];
            [lines addObject:[NSString stringWithFormat:@"%d", verse.sourahInfo.orderInBook]];

            currentLine = @"";
            verseSignCountInLine = 0;
            verseSignWidthInLine = 0;
        }

        NSArray* words = [self removeEmpties:[verse.text componentsSeparatedByString:@" "]];
        for (int j = 0; j < words.count; j++) {
            BOOL allowSplitLine = YES;
            NSString* word = [words objectAtIndex:j];
            CGFloat wordWidth = 0;

            if ([word rangeOfString:@"["].location != NSNotFound) {
                wordWidth = 2 * AYA_SIGN_MARGIN + AYA_SIGN_DIM;
                verseSignWidthInLine += [self widthOfString:word withFont:quranFont];
                verseSignCountInLine++;
            } else if ([word rangeOfString:@"<"].location != NSNotFound) {
                wordWidth = VAGHF_SIGN_WIDTH;
                allowSplitLine = NO;
            } else {
                wordWidth = [self widthOfString:word withFont:quranFont];
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

            remainedInLine = lineWidth - ([self widthOfString:[self replaceVaghfs:currentLine with:@"*"] withFont:quranFont] - verseSignWidthInLine + verseSignCountInLine * AYA_SIGN_DIM);
        }
    }

    if ([currentLine length] > 0) {
        [lines addObject:currentLine];
    }

    [lines addObject:@"<end sourah>"];

    int linesCount = 0;
    int beginSourahCount = 0;
    for (int i = 0; i < [lines count]; i++) {
        NSString* line = [lines objectAtIndex:i];
        if ([line isEqualToString:@"<new sourah>"]) {
            beginSourahCount++;
            i++;
        } else if ([line isEqualToString:@"<end sourah>"]) {
        } else {
            linesCount++;
        }
    }

    int availableHeight = CGRectGetHeight(CONENT_RECT);
    availableHeight = availableHeight - beginSourahCount * SOURAH_HEADER_HEIGHT;

    lineHeight = availableHeight / linesCount;
    if (lineHeight > MAX_LINE_HEIGHT) {
        lineHeight = MAX_LINE_HEIGHT;
    }

    if (lineHeight < MIN_LINE_HEIGHT) {
        [self decreaseFontSize];
        [self splitLines];
    }

}

- (void)decreaseFontSize {
    if (updatedFontSize == 0) {
        updatedFontSize = [self getFontSize];
    }

    updatedFontSize = updatedFontSize - 1;
    quranFont = [UIFont fontWithName:[Settings getDefaultArabicFont] size:[self getFontSize]];
}

- (NSString*)replaceVaghfs:(NSString*)aya with:(NSString*)replacement {
    aya = [aya stringByReplacingOccurrencesOfString:@"<moaneghe>" withString:replacement];
    aya = [aya stringByReplacingOccurrencesOfString:@"<sali>" withString:replacement];
    aya = [aya stringByReplacingOccurrencesOfString:@"<gholi>" withString:replacement];
    aya = [aya stringByReplacingOccurrencesOfString:@"<mamnu>" withString:replacement];
    aya = [aya stringByReplacingOccurrencesOfString:@"<jayez>" withString:replacement];
    aya = [aya stringByReplacingOccurrencesOfString:@"<motlagh>" withString:replacement];

    return aya;
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (NSMutableArray*)removeEmpties:(NSArray*)list {
    NSMutableArray* result = [[NSMutableArray alloc] init];

    for (int i = 0; i < [list count]; i++) {
        NSString* l = [list objectAtIndex:i];
        if ([l length] > 0) {
            [result addObject:l];
        }
    }

    return result;
}

#pragma mark - Drawing Methods

- (void)drawBackground:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    int w = [Utils isTablet] ? 5 : 3;
    [self drawRect:CGRectMake(LEFT_BORDER, VERTICAL_BORDER, VIEW_WIDTH - LEFT_BORDER - RIGHT_BORDER, VIEW_HEIGHT - 2 * VERTICAL_BORDER) width:w context:context];
    [self drawRect:CGRectMake(LEFT_BORDER + CADR_WIDTH, VERTICAL_BORDER + CADR_WIDTH, VIEW_WIDTH - LEFT_BORDER - RIGHT_BORDER - 2 * CADR_WIDTH, VIEW_HEIGHT - 2 * (VERTICAL_BORDER + CADR_WIDTH)) width:w context:context];

    int smallMargin = [Utils isTablet] ? 4 : 3;
    [self drawRect:CGRectMake(LEFT_BORDER + smallMargin, VERTICAL_BORDER + smallMargin, VIEW_WIDTH - LEFT_BORDER - RIGHT_BORDER - 2 * smallMargin, VIEW_HEIGHT - 2 * (VERTICAL_BORDER + smallMargin)) width:2 context:context];
    [self drawRect:CGRectMake(LEFT_BORDER + CADR_WIDTH - smallMargin, VERTICAL_BORDER + CADR_WIDTH - smallMargin, VIEW_WIDTH - LEFT_BORDER - RIGHT_BORDER - 2 * CADR_WIDTH + 2 * smallMargin, VIEW_HEIGHT - 2 * (VERTICAL_BORDER + CADR_WIDTH) + 2 * smallMargin) width:2 context:context];

    if ([Utils isTablet]) {
        [self drawRect:CGRectMake(LEFT_BORDER + (CADR_WIDTH / 2), VERTICAL_BORDER + (CADR_WIDTH / 2), VIEW_WIDTH - LEFT_BORDER - RIGHT_BORDER - CADR_WIDTH, VIEW_HEIGHT - 2 * (VERTICAL_BORDER) - CADR_WIDTH) width:14 context:context];
    }
}

- (void)drawRect:(CGRect)rectangle width:(int)width context:(CGContextRef)context {
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.0);
    CGContextSetLineWidth (context, SCALE(width));
    SET_STROCK_COLOR;

    CGContextStrokeRect(context, rectangle);
}

- (int)getBorderRight {
    int result = 0;

    if ([Utils isTablet]) {
        result = 20;
    } else if ([Utils isIPhone5Size]) {
        result = 5;
    } else if ([Utils isIPhone6Size]) {
        result = 5;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 5;
    }

    return result;
}

- (int)getVerticalMargins {
    int result = 0;

    if ([Utils isTablet]) {
        result = 20;
    } else if ([Utils isIPhone5Size]) {
        result = 5;
    } else if ([Utils isIPhone6Size]) {
        result = 5;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 5;
    }

    return result;
}

- (int)getBorderLeft {
    int result = 0;

    if ([Utils isTablet]) {
        result = 100;
    } else if ([Utils isIPhone5Size]) {
        result = 40;
    } else if ([Utils isIPhone6Size]) {
        result = 50;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 60;
    }

    return result;
}

- (int)getCadreWidth {
    int result = 0;

    if ([Utils isTablet]) {
        result = 20;
    } else if ([Utils isIPhone5Size]) {
        result = 10;
    } else if ([Utils isIPhone6Size]) {
        result = 10;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 14;
    }

    return result;
}

- (int)getLineHeight {
    int result = 1000;

//    if ([Utils isTablet]) {
//        result = 70;
//    } else if ([Utils isIPhone5Size]) {
//        result = 40;
//    } else if ([Utils isIPhone6Size]) {
//
//    } else if ([Utils isIPhone6PlusSize]) {
//        
//    }

    return result;
}

- (int)getFontSize {
    if (updatedFontSize > 0) {
        return updatedFontSize;
    }

    int result = 0;

    if ([Utils isTablet]) {
        result = 33;
    } else if ([Utils isIPhone5Size]) {
        result = 18;
    } else if ([Utils isIPhone6Size]) {
        result = 19;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 22;
    }
    
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

- (int)getAyaTopMargin {
    int result = 0;

    if ([Utils isTablet]) {
        result = 7;
    } else if ([Utils isIPhone5Size]) {
        result = 0;
    } else if ([Utils isIPhone6Size]) {
        result = 3;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 4;
    }

    return result;
}

- (int)getAyaSignDim {
    int result = 0;

    if ([Utils isTablet]) {
        result = 30;
    } else if ([Utils isIPhone5Size]) {
        result = 17;
    } else if ([Utils isIPhone6Size]) {
        result = 17;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 18;
    }

    return result;
}

- (int)getPageTopOffset {
    int result = 0;

    if ([Utils isTablet]) {
        result = 25;
    } else if ([Utils isIPhone5Size]) {
        result = 10;
    } else if ([Utils isIPhone6Size]) {
        result = 14;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 16;
    }

    return result;
}

- (CGFloat)getVerseSignFont {
    int result = 20;

    if ([Utils isTablet]) {
        result = 12;
    } else if ([Utils isIPhone5Size]) {
        result = 6.5f;
    } else if ([Utils isIPhone6Size]) {
        result = 6.5f;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 7.0f;
    }

    return result;
}

- (CGFloat)getContentMargin {
    int result = 0;

    if ([Utils isTablet]) {
        result = 20;
    } else if ([Utils isIPhone5Size]) {
        result = 7;
    } else if ([Utils isIPhone6Size]) {
        result = 7;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 10;
    }

    return result;
}

- (int)getSourahHeaderHeight {
    int result = 0;

    if ([Utils isTablet]) {
        result = 80;
    } else if ([Utils isIPhone5Size]) {
        result = 50;
    } else if ([Utils isIPhone6Size]) {
        result = 55;
    } else if ([Utils isIPhone6PlusSize]) {
        result = 60;
    }
    
    return result;
}

- (int)getSourahTitleFontSize:(BOOL)fullSize {
    int result = 0;

    if (!fullSize) {
        result = (int)([self getSourahHeaderHeight] * 0.15);
    } else {
        result = (int)([self getSourahHeaderHeight] * 0.35);
    }

    return result;
}
@end
