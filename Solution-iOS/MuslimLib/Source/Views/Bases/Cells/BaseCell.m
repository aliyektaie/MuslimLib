//
//  BaseCell.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

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

- (instancetype)initWithReuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {

}
@end
