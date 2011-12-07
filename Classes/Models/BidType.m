#import "BidType.h"

@interface BidType()

+ (NSInteger) biddersPointsForGame:(Game*)g andTricksWon:(NSUInteger)tricksWon;
+ (NSInteger) nonBiddersPointsForGame:(Game*)g andTricksWon:(NSUInteger)tricksWon;

@end

@implementation BidType

static NSMutableDictionary* allTypes;
static NSArray* orderedHands;

static NSString* ssTrick = @"tricks";
static NSString* ssSuit = @"suit";
static NSString* ssSuitSymbol = @"suitSymbol";
static NSString* ssSuitColour = @"suitColour";
static NSString* ssPoints = @"points";
static NSString* ssVariation = @"variation";
static NSString* ssVariationRegular = @"regular";
static NSString* ssVariationMisere = @"misére";
static NSString* ssVariationNoBid = @"no bid";
static NSString* ssModeQuebec = @"Quebec mode";

+ (void) initialize {
  if (!allTypes) {
    NSArray* tricks = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt: 6],
                       [NSNumber numberWithInt: 7],
                       [NSNumber numberWithInt: 8],
                       [NSNumber numberWithInt: 9],
                       [NSNumber numberWithInt: 10],
                       nil
                       ];
    
    NSArray* suits = [NSArray arrayWithObjects:
                      [NSArray arrayWithObjects:@"Spades", @"S", @"♠", @"black", nil],
                      [NSArray arrayWithObjects:@"Clubs", @"C", @"♣", @"black", nil],
                      [NSArray arrayWithObjects:@"Diamonds", @"D", @"♦", @"red", nil],
                      [NSArray arrayWithObjects:@"Hearts", @"H", @"♥", @"red", nil],
                      [NSArray arrayWithObjects:@"No Trumps", @"NT", @"NT", @"none", nil],
                      nil
                      ];
    
    int i = 0;
    
    allTypes = [[NSMutableDictionary alloc] init];
    
    for (NSNumber* aTrick in tricks) {
      for (NSArray* aSuit in suits) {
        NSString* hand = [NSString stringWithFormat:
                         @"%@%@",
                         aTrick,
                         [aSuit objectAtIndex:1]
                         ];
        NSDictionary* aBidType = [NSDictionary dictionaryWithObjectsAndKeys:
                                  aTrick, ssTrick,
                                  [aSuit objectAtIndex:0], ssSuit,
                                  [aSuit objectAtIndex:2], ssSuitSymbol,
                                  [aSuit objectAtIndex:3], ssSuitColour,
                                  [NSNumber numberWithInt:(40 + (i*  20))], ssPoints,
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

    [allTypes setValue:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"No Bid", ssSuit,
      @"NB", ssSuitSymbol,
      [NSNumber numberWithInt:0], ssPoints,
      ssVariationNoBid, ssVariation,
      nil
      ]
                forKey:@"NB"
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

+ (NSArray*) orderedHands {
  return orderedHands;
}

+ (NSDictionary*) allTypes {
  return allTypes;
}

+ (NSString*) suitColourForHand:(NSString*)hand {
  NSDictionary* aBidType = [allTypes objectForKey:hand];
  NSString* suitColour = [NSString stringWithFormat:@"%@", [aBidType objectForKey:ssSuitColour]];
  
  return suitColour;
}

+ (NSNumber*) tricksForHand:(NSString*)hand {
  NSDictionary* aBidType = [allTypes objectForKey:hand];
  
  return [aBidType objectForKey:ssTrick];
}

+ (NSString*) tricksAndSymbolForHand:(NSString*)hand {
  NSDictionary* aBidType = [allTypes objectForKey:hand];
  NSString* tricksAndSymbol = [NSString stringWithFormat:@"%@%@", [aBidType objectForKey:ssTrick], [aBidType objectForKey:ssSuitSymbol]];
  
  if (![[BidType variation:hand] isEqualToString:ssVariationRegular]) {
    tricksAndSymbol = hand;
  }
  
  return tricksAndSymbol;
}

+ (NSString*) tricksAndDescriptionForHand:(NSString*)hand {
  NSDictionary* aBidType = [allTypes objectForKey:hand];
  NSString* desc = [NSString stringWithFormat:@"%@ %@", [aBidType objectForKey:ssTrick], [aBidType objectForKey:ssSuit]];

  if (![[BidType variation:hand] isEqualToString:ssVariationRegular]) {
    desc = [NSString stringWithFormat:@"%@", [aBidType objectForKey:ssSuit]];
  }  
  
  return desc;  
}

+ (NSString*) descriptionForHand:(NSString*)hand {
  NSDictionary* aBidType = [allTypes objectForKey:hand];
  NSString* desc = [NSString stringWithFormat:@"%@", [aBidType objectForKey:ssSuit]];
  
  return desc;
}

+ (NSString*) pointsStringForHand:(NSString*)hand withGame:(Game*)g {
  NSDictionary* aBidType = [allTypes objectForKey:hand];
  NSString* pts = [NSString stringWithFormat:@"%@ pts", [aBidType objectForKey:ssPoints]];
  
  if ([g.setting.mode isEqualToString:ssModeQuebec] && [[aBidType objectForKey:ssVariation] isEqualToString:ssVariationMisere]) {
    pts = [NSString stringWithFormat:@"%d pts", [[aBidType objectForKey:ssPoints] intValue] * 2];
  }

  return pts;
}

+ (NSInteger) pointsForTeam:(Team*)t game:(Game*)g andTricksWon:(NSUInteger)tricksWon {
  Round* r = [g.rounds firstObject];
  if ([r.biddingTeams containsObject:t]) {
    return [BidType biddersPointsForGame:g andTricksWon:tricksWon];
  }

  return [BidType nonBiddersPointsForGame:g andTricksWon:tricksWon];
}

+ (NSInteger) biddersPointsForGame:(Game*)g andTricksWon:(NSUInteger)tricksWon {
  Round* r = [g.rounds firstObject];
  NSDictionary* aBidType = [allTypes objectForKey:r.bid];
  
  NSString* variation = [aBidType objectForKey:ssVariation];
  int bidPoints = [[aBidType objectForKey:ssPoints] intValue];

  // default to giving the points
  int biddersPoints = bidPoints;

  if (![BidType bidderWonHand:r.bid withTricksWon:tricksWon]) {
    biddersPoints = -bidPoints;
    if ([g.setting.mode isEqualToString:ssModeQuebec]) {
      biddersPoints = 0;
    }
  }
  else {
    if ([g.setting.mode isEqualToString:ssModeQuebec] && [variation isEqualToString:ssVariationMisere]) {
      biddersPoints *= 2;
    }
  }
  
  // if won 10 and bid points worth less than a slam (250 pts)
  // => award a slam
  if ([variation isEqual:ssVariationRegular] && tricksWon == 10 && bidPoints < 250) {
    biddersPoints = 250;
  }

  return biddersPoints;
}

+ (NSInteger) nonBiddersPointsForGame:(Game*)g andTricksWon:(NSUInteger)tricksWon {
  Round* r = [g.rounds firstObject];
  NSDictionary* aBidType = [allTypes objectForKey:r.bid];
  
  NSString* variation = [aBidType objectForKey:ssVariation];
  int bidPoints = [[aBidType objectForKey:ssPoints] intValue];
  int bidderPoints = [BidType biddersPointsForGame:g andTricksWon:10 - tricksWon];

  // default to zero points
  int nonBiddersPoints = 0;
  
  if ([g.setting.mode isEqualToString:ssModeQuebec]) {
    if (bidderPoints == 0) {
      nonBiddersPoints = bidPoints;
    }
    if ([variation isEqualToString:ssVariationMisere]) {
      nonBiddersPoints *= 2;
    }
  }
  // if regular bid and bidders won less than ten
  // => award 10 points x number of tricks (won by the non-bidders)
  else if (![variation isEqual:ssVariationMisere] && [g.setting.nonBidderScoresTen boolValue]) {
    nonBiddersPoints = 10 * tricksWon;
  }
  
  return nonBiddersPoints;
}

+ (BOOL) bidderWonHand:(NSString*)hand withTricksWon:(NSUInteger)tricksWon {
  NSDictionary* aBidType = [allTypes objectForKey:hand];
  
  NSString* variation = [aBidType objectForKey:ssVariation];
  int bidTricks = [[aBidType objectForKey:ssTrick] intValue];
  
  // if regular bid and didn't win enough, or misére bid and won any
  // => loss
  if (
      ([variation isEqual:ssVariationRegular] && tricksWon < bidTricks) ||
      ([variation isEqual:ssVariationMisere]  && tricksWon > 0)
      ) {
    return NO;
  }
  else {
    return YES;
  }
}

+ (NSString*) variation:(NSString*)hand {
  NSString* variation = nil;
  
  if ([@"CM" isEqual:hand] || [@"OM" isEqual:hand]) {
    variation = ssVariationMisere;
  }
  else if ([@"NB" isEqualToString:hand]) {
    variation = ssVariationNoBid;
  }
  else {
    variation = ssVariationRegular;
  }

  return variation;
}

@end
