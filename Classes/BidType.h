//
//  BidType.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 29/11/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidType : NSObject {

}

+ (NSString *)bidDescription:(NSString *)key;
+ (NSArray *)orderedKeys;
+ (NSDictionary *)allTypes;
+ (NSString *)anyFormattedString:(NSString *)key;

@end
