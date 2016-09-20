//
//  ContentFileValueFactory.h
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IValueFactory.h"
#import "ContentFile.h"

@interface ContentFileValueFactory : NSObject <IValueFactory>

- (id<ITrieIndexValue>)createNew;

@end
