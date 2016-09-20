//
//  IValueFactory.h
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#ifndef TipBasedApp_IValueFactory_h
#define TipBasedApp_IValueFactory_h

#import "ITrieIndexValue.h"

@protocol IValueFactory <NSObject>

- (id<ITrieIndexValue>)createNew;

@end


#endif
