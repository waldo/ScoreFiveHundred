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
static NSArray *orderedHands;

static NSString *ssTrick = @"tricks";
static NSString *ssSuit = @"suit";
static NSString *ssSuitSymbol = @"suitSymbol";
static NSString *ssSuitColour = @"suitColour";
static NSString *ssPoints = @"points";
static NSString *ssVariation = @"variation";
static NSString *ssVariationRegular = @"regular";
static NSString *ssVariationMisere = @"misére";

+ (void) initialize {
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
        NSString *hand = [NSString stringWithFormat:
                         @"%@%@",
                         aTrick,
                         [aSuit objectAtIndex:1]
                         ];
        NSDictionary *aBidType = [NSDictionary dictionaryWithObjectsAndKeys:
                                  aTrick, ssTrick,
                                  [aSuit objectAtIndex:0], ssSuit,
                                  [aSuit objectAtIndex:2], ssSuitSymbol,
                                  [aSuit objectAtIndex:3], ssSuitColour,
                                  [NSNumber numberWithInt:(40 + (i * 20))], ssPoints,
                                  ssVariationRegular, ssVariation,
                                  nil
                                  ];
        
        [allTypes setValue:aBidType forKey:hand];
        ++i;
      }
    }
    
    [allTypes setValue:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"Closed Misére", ssSuit,
      @"CM", ssSuitSymbol,
      [NSNumber numberWithInt:250], ssPoints,
      ssVariationMisere, ssVariation,
      nil
      ]
                forKey:@"CM"
     ];

    [allTypes setValue:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"Open Misére", ssSuit,
      @"OM", ssSuitSymbol,
      [NSNumber numberWithInt:500], ssPoints,
      ssVariationMisere, ssVariation,
      nil
      ]
                forKey:@"OM"
     ];    
    
    orderedHands = [[NSArray alloc] initWithObjects:
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

+ (NSArray *)orderedHands {
  return orderedHands;
}

+ (NSDictionary *)allTypes {
  return allTypes;
}

+ (NSString *)suitColourForHand:(NSString *)hand {
  NSDictionary *aBidType = [allTypes objectForKey:hand];
  NSString *suitColour = [NSString stringWithFormat:@"%@", [aBidType objectForKey:ssSuitColour]];
  
  return suitColour;
}

+ (NSString *)tricksAndSymbolForHand:(NSString *)hand {
  NSDictionary *aBidType = [allTypes objectForKey:hand];
  NSString *tricksAndSymbol = [NSString stringWithFormat:@"%@%@", [aBidType objectForKey:ssTrick], [aBidType objectForKey:ssSuitSymbol]];
  
  if ([@"CM" isEqual:hand] || [@"OM" isEqual:hand]) {
    tricksAndSymbol = hand;
  }
  
  return tricksAndSymbol;
}

+ (NSString*) tricksAndDescriptionForHand:(NSString*)hand {
  NSDictionary *aBidType = [allTypes objectForKey:hand];
  NSString *desc = [NSString stringWithFormat:@"%@ %@", [aBidType objectForKey:ssTrick], [aBidType objectForKey:ssSuit]];

  if ([@"CM" isEqual:hand] || [@"OM" isEqual:hand]) {
    desc = [NSString stringWithFormat:@"%@", [aBidType objectForKey:ssSuit]];
  }  
  
  return desc;  
}

+ (NSString *)descriptionForHand:(NSString *)hand {
  NSDictionary *aBidType = [allTypes objectForKey:hand];
  NSString *desc = [NSString stringWithFormat:@"%@", [aBidType objectForKey:ssSuit]];
  
  return desc;
}

+ (NSString *)pointsStringForHand:(NSString *)hand {
  NSDictionary *aBidType = [allTypes objectForKey:hand];
  NSString *pts = [NSString stringWithFormat:@"%@ pts", [aBidType objectForKey:ssPoints]];
  
  return pts;
}

+ (NSNumber *)biddersPointsForHand:(NSString *)hand AndBiddersTricksWon:(NSNumber *)tricksWon {
  NSDictionary *aBidType = [allTypes objectForKey:hand];
  
  NSString *variation = [aBidType objectForKey:ssVariation];
  int bidPoints = [[aBidType objectForKey:ssPoints] intValue];

  // default to giving the points
  int biddersPoints = bidPoints;

  if (![BidType bidderWonHand:hand WithTricksWon:tricksWon]) {
    biddersPoints = -bidPoints;
  }
  
  // if won 10 and bid points worth less than a slam (250 pts)
  // => award a slam
  if ([variation isEqual:ssVariationRegular] && tricksWon.intValue == 10 && bidPoints < 250) {
    biddersPoints = 250;
  }

  return [NSNumber numberWithInt:biddersPoints];
}

+ (NSNumber *)nonBiddersPointsForHand:(NSString *)hand AndBiddersTricksWon:(NSNumber *)tricksWon {
  NSDictionary *aBidType = [allTypes objectForKey:hand];
  
  NSString *variation = [aBidType objectForKey:ssVariation];

  // default to zero points
  int nonBiddersPoints = 0;
  
  // if regular bid and bidders won less than ten
  // => award 10 points x number of tricks (won by the non-bidders)
  if ([variation isEqual:ssVariationRegular]) {
    nonBiddersPoints = 10 * (10 - tricksWon.intValue);
  }
  
  return [NSNumber numberWithInt:nonBiddersPoints];
}

+ (BOOL) bidderWonHand:(NSString *)hand WithTricksWon:(NSNumber *)tricksWon {
  NSDictionary *aBidType = [allTypes objectForKey:hand];
  
  NSString *variation = [aBidType objectForKey:ssVariation];
  int bidTricks = [[aBidType objectForKey:ssTrick] intValue];
  
  // if regular bid and didn't win enough, or misére bid and won any
  // => loss
  if (
      ([variation isEqual:ssVariationRegular] && tricksWon.intValue < bidTricks) ||
      ([variation isEqual:ssVariationMisere]  && tricksWon.intValue > 0)
      ) {
    return NO;
  }
  else {
    return YES;
  }
}

@end
