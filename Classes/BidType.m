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
static NSString *variationRegularString = @"regular";
static NSString *variationMisereString = @"misére";

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
                                  variationRegularString, variationString,
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
      variationMisereString, variationString,
      nil
      ]
                forKey:@"CM"
     ];

    [allTypes setValue:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"Open Misére", suitString,
      @"OM", suitSymbolString,
      [NSNumber numberWithInt:500], pointString,
      variationMisereString, variationString,
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

+ (NSString *)pointsStringForKey:(NSString *)key {
  NSDictionary *aBidType = [allTypes objectForKey:key];
  NSString *pts = [NSString stringWithFormat:@"%@ pts", [aBidType objectForKey:pointString]];
  
  return pts;
}

+ (NSNumber *)biddersPointsForKey:(NSString *)key AndBiddersTricksWon:(NSNumber *)tricksWon {
  NSDictionary *aBidType = [allTypes objectForKey:key];
  
  NSString *variation = [aBidType objectForKey:variationString];
    
  int bidTricks = [[aBidType objectForKey:trickString] intValue];
  int bidPoints = [[aBidType objectForKey:pointString] intValue];

  // default to giving the points
  int biddersPoints = bidPoints;

  // if regular bid and didn't win enough, or
  // misére bid and won any
  // => subtract the bid points
  if (
      ([variation isEqual:variationRegularString] && tricksWon.intValue < bidTricks) ||
      ([variation isEqual:variationMisereString]  && tricksWon.intValue > 0)
  ) {
    biddersPoints = -bidPoints;
  }
  
  // if won 10 and bid points worth less than a slam (250 pts)
  // => award a slam
  if ([variation isEqual:variationRegularString] && tricksWon.intValue == 10 && bidPoints < 250) {
    biddersPoints = 250;
  }

  return [NSNumber numberWithInt:biddersPoints];
}

+ (NSNumber *)nonBiddersPointsForKey:(NSString *)key AndBiddersTricksWon:(NSNumber *)tricksWon {
  NSDictionary *aBidType = [allTypes objectForKey:key];
  
  NSString *variation = [aBidType objectForKey:variationString];

  // default to zero points
  int nonBiddersPoints = 0;
  
  // if regular bid and bidders won less than ten
  // => award 10 points x number of tricks (won by the non-bidders)
  if ([variation isEqual:variationRegularString]) {
    nonBiddersPoints = 10 * (10 - tricksWon.intValue);
  }
  
  return [NSNumber numberWithInt:nonBiddersPoints];
}

@end
