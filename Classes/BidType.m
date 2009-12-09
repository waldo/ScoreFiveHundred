//
//  BidType.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 29/11/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import "BidType.h"


@implementation BidType

static NSMutableDictionary *allTypes;
static NSArray *orderedKeys;

static NSString *trickString = @"tricks";
static NSString *suitString = @"suit";
static NSString *suitSymbolString = @"suitSymbol";
static NSString *suitColourString = @"suitColour";
static NSString *pointString = @"points";
static NSString *variationString = @"variation";

+ (void)initialize {
  if (!allTypes) {
    NSArray *tricks = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt: 6],
                       [NSNumber numberWithInt: 7],
                       [NSNumber numberWithInt: 8],
                       [NSNumber numberWithInt: 9],
                       [NSNumber numberWithInt: 10],
                       nil
                       ];
    
    NSArray *suits = [NSArray arrayWithObjects:
                      [NSArray arrayWithObjects:@"Spades", @"S", @"♠", @"black", nil],
                      [NSArray arrayWithObjects:@"Clubs", @"C", @"♣", @"black", nil],
                      [NSArray arrayWithObjects:@"Diamonds", @"D", @"♦", @"red", nil],
                      [NSArray arrayWithObjects:@"Hearts", @"H", @"♥", @"red", nil],
                      [NSArray arrayWithObjects:@"No Trumps", @"NT", @"NT", @"none", nil],
                      nil
                      ];
    
    int i = 0;
    
    allTypes = [[NSMutableDictionary alloc] init];
    
    for (NSNumber *aTrick in tricks) {
      for (NSArray *aSuit in suits) {
        NSString *key = [NSString stringWithFormat:
                         @"%@%@",
                         aTrick,
                         [aSuit objectAtIndex:1]
                         ];
        NSDictionary *aBidType = [NSDictionary dictionaryWithObjectsAndKeys:
                                  aTrick, trickString,
                                  [aSuit objectAtIndex:0], suitString,
                                  [aSuit objectAtIndex:2], suitSymbolString,
                                  [aSuit objectAtIndex:3], suitColourString,
                                  [NSNumber numberWithInt:(40 + (i * 20))], pointString,
                                  @"None", variationString,
                                  nil
                                  ];
        
        [allTypes setValue:aBidType forKey:key];
        ++i;
      }
    }
    
    [allTypes setValue:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"Closed Misére", suitString,
      @"CM", suitSymbolString,
      [NSNumber numberWithInt:250], pointString,
      nil
      ]
                forKey:@"CM"
     ];

    [allTypes setValue:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"Open Misére", suitString,
      @"OM", suitSymbolString,
      [NSNumber numberWithInt:500], pointString,
      nil
      ]
                forKey:@"OM"
     ];    
    NSLog(@"%@, count: %d", allTypes, [allTypes count]);
    
    orderedKeys = [NSArray arrayWithObjects:
                   @"6S",
                   @"6C",
                   @"6D",
                   @"6H",
                   @"6NT",
                   @"7S",
                   @"7C",
                   @"7D",
                   @"7H",
                   @"7NT",
                   @"CM",
                   @"8S",
                   @"8C",
                   @"8D",
                   @"8H",
                   @"8NT",
                   @"9S",
                   @"9C",
                   @"9D",
                   @"9H",
                   @"9NT",
                   @"10S",
                   @"10C",
                   @"10D",
                   @"10H",
                   @"OM",
                   @"10NT",
                   nil
                   ];
  }
}

+ (NSArray *)orderedKeys {
  return orderedKeys;
}

+ (NSDictionary *)allTypes {
  return allTypes;
}

+ (NSString *)suitColourForKey:(NSString *)key {
  NSDictionary *aBidType = [allTypes objectForKey:key];
  NSString *suitColour = [NSString stringWithFormat:@"%@", [aBidType objectForKey:suitColourString]];
  
  return suitColour;
}

+ (NSString *)tricksAndSymbolForKey:(NSString *)key {
  NSDictionary *aBidType = [allTypes objectForKey:key];
  NSString *tricksAndSymbol = [NSString stringWithFormat:@"%@%@", [aBidType objectForKey:trickString], [aBidType objectForKey:suitSymbolString]];
  
  if (key == @"CM" || key == @"OM") {
    tricksAndSymbol = key;
  }
  
  return tricksAndSymbol;
}

+ (NSString *)descriptionForKey:(NSString *)key {
  NSDictionary *aBidType = [allTypes objectForKey:key];
  NSString *desc = [NSString stringWithFormat:@"%@", [aBidType objectForKey:suitString]];
  
  return desc;
}

+ (NSString *)pointsForKey:(NSString *)key {
  NSDictionary *aBidType = [allTypes objectForKey:key];
  NSString *pts = [NSString stringWithFormat:@"%@ pts", [aBidType objectForKey:pointString]];
  
  return pts;
}

@end
