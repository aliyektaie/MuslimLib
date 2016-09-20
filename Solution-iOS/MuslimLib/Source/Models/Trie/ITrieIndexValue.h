//
//  ITrieIndexValue.h
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#ifndef TipBasedApp_ITrieIndexValue_h
#define TipBasedApp_ITrieIndexValue_h

#import "ByteArray.h"

@protocol ITrieIndexValue <NSObject>

- (void)load:(ByteArray*)array;

@end

#endif
