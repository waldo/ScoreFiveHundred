#import "BidType.h"


@interface BidType ()

+ (NSInteger)biddersPointsForGame:(Game *)g andTricksWon:(NSUInteger)tricksWon;
+ (NSInteger)nonBiddersPointsForGame:(Game *)g team:(Team *)team andTricksWon:(NSUInteger)tricksWon;

@end

@implementation BidType

#pragma mark Static

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
static NSString *ssVariationNoBid = @"no bid";
static NSString *ssModeQuebec = @"Quebec mode";

#pragma mark Public

+ (void)initialize {
  if (!allTypes) {
    NSArray *tricks = @[@6,
                       @7,
                       @8,
                       @9,
                       @10];
    
    NSArray *suits = @[@[@"Spades", @"S", @"♠", @"black"],
                      @[@"Clubs", @"C", @"♣", @"black"],
                      @[@"Diamonds", @"D", @"♦", @"red"],
                      @[@"Hearts", @"H", @"♥", @"red"],
                      @[@"No Trumps", @"NT", @"NT", @"none"]];
    
    int i = 0;
    
    allTypes = [[NSMutableDictionary alloc] init];
    
    for (NSNumber *aTrick in tricks) {
      for (NSArray *aSuit in suits) {
        NSString *hand = [NSString stringWithFormat:
                         @"%@%@",
                         aTrick,
                         aSuit[1]
                         ];
        NSDictionary *aBidType = @{ssTrick: aTrick,
                                  ssSuit: aSuit[0],
                                  ssSuitSymbol: aSuit[2],
                                  ssSuitColour: aSuit[3],
                                  ssPoints: @(40 + (i * 20)),
                                  ssVariation: ssVariationRegular};
        
        [allTypes setValue:aBidType forKey:hand];
        ++i;
      }
    }
    
    [allTypes setValue:
     @{ssSuit: @"Closed Misére",
      ssSuitSymbol: @"CM",
      ssPoints: @250,
      ssVariation: ssVariationMisere}
                forKey:@"CM"
     ];

    [allTypes setValue:
     @{ssSuit: @"Open Misére",
      ssSuitSymbol: @"OM",
      ssPoints: @500,
      ssVariation: ssVariationMisere}
                forKey:@"OM"
     ];    

    [allTypes setValue:
     @{ssSuit: @"No Bid",
      ssSuitSymbol: @"NB",
      ssPoints: @0,
      ssVariation: ssVariationNoBid}
                forKey:@"NB"
     ];    
    
    orderedHands = @[@"6S",
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
                   @"10NT"];
  }
}

+ (NSArray *)orderedHands {
  return orderedHands;
}

+ (NSDictionary *)allTypes {
  return allTypes;
}

+ (NSString *)suitColourForHand:(NSString *)hand {
  NSDictionary *aBidType = allTypes[hand];
  NSString *suitColour = [NSString stringWithFormat:@"%@", aBidType[ssSuitColour]];
  
  return suitColour;
}

+ (NSNumber *)tricksForHand:(NSString *)hand {
  NSDictionary *aBidType = allTypes[hand];
  
  return aBidType[ssTrick];
}

+ (NSString *)tricksAndSymbolForHand:(NSString *)hand {
  NSDictionary *aBidType = allTypes[hand];
  NSString *tricksAndSymbol = [NSString stringWithFormat:@"%@%@", aBidType[ssTrick], aBidType[ssSuitSymbol]];
  
  if (![[BidType variation:hand] isEqualToString:ssVariationRegular]) {
    tricksAndSymbol = hand;
  }
  
  return tricksAndSymbol;
}

+ (NSString *)tricksAndDescriptionForHand:(NSString *)hand {
  NSDictionary *aBidType = allTypes[hand];
  NSString *desc = [NSString stringWithFormat:@"%@ %@", aBidType[ssTrick], aBidType[ssSuit]];

  if (![[BidType variation:hand] isEqualToString:ssVariationRegular]) {
    desc = [NSString stringWithFormat:@"%@", aBidType[ssSuit]];
  }  
  
  return desc;  
}

+ (NSString *)descriptionForHand:(NSString*)hand {
  NSDictionary *aBidType = allTypes[hand];
  NSString *desc = [NSString stringWithFormat:@"%@", aBidType[ssSuit]];
  
  return desc;
}

+ (NSString *)pointsStringForHand:(NSString *)hand withGame:(Game *)g {
  NSDictionary *aBidType = allTypes[hand];
  NSString *pts = [NSString stringWithFormat:@"%@ pts", aBidType[ssPoints]];
  
  if ([g.setting.mode isEqualToString:ssModeQuebec] && [aBidType[ssVariation] isEqualToString:ssVariationMisere]) {
    pts = [NSString stringWithFormat:@"%d pts", [aBidType[ssPoints] intValue] * 2];
  }

  return pts;
}

+ (NSInteger)pointsForTeam:(Team *)t game:(Game *)g andTricksWon:(NSUInteger)tricksWon {
  Round *r = [g.rounds firstObject];
  if ([r.biddingTeams containsObject:t]) {
    return [BidType biddersPointsForGame:g andTricksWon:tricksWon];
  }

  return [BidType nonBiddersPointsForGame:g team:t andTricksWon:tricksWon];
}

+ (NSInteger)biddersPointsForGame:(Game *)g andTricksWon:(NSUInteger)tricksWon {
  Round *r = [g.rounds firstObject];
  NSDictionary *aBidType = allTypes[r.bid];
  
  NSString *variation = aBidType[ssVariation];
  int bidPoints = [aBidType[ssPoints] intValue];

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

+ (NSInteger)nonBiddersPointsForGame:(Game *)g team:(Team *)team andTricksWon:(NSUInteger)tricksWon {
  Round *r = [g.rounds firstObject];
  NSDictionary *aBidType = allTypes[r.bid];
  
  NSString *variation = aBidType[ssVariation];
  int bidPoints = [aBidType[ssPoints] intValue];
  long bidderPoints = [BidType biddersPointsForGame:g andTricksWon:10 - tricksWon];

  // default to zero points
  long nonBiddersPoints = 0;
  
  if ([g.setting.mode isEqualToString:ssModeQuebec]) {
    if (bidderPoints == 0) {
      nonBiddersPoints = bidPoints;
    }
    if ([variation isEqualToString:ssVariationMisere]) {
      nonBiddersPoints *= 2;
    }
  }
  // if regular bid and bidders won less than ten => award 10 points x number of tricks (won by the non-bidders)
  else if ([variation isEqualToString:ssVariationNoBid] || (![variation isEqualToString:ssVariationMisere] && g.setting.nonBidderScoresTen.boolValue && (!g.setting.onlySuccessfulDefendersScore.boolValue || (g.setting.onlySuccessfulDefendersScore.boolValue && ![BidType bidderWonHand:r.bid withTricksWon:10 - tricksWon])))) {
    nonBiddersPoints = 10 * tricksWon;
  }

  // cap defenders score
  if (![variation isEqualToString:ssVariationNoBid] && g.setting.capDefendersScore.boolValue && ([g scoreForTeam:team].intValue + nonBiddersPoints > g.setting.capDefendersScore.intValue)) {
    nonBiddersPoints = g.setting.capDefendersScore.intValue - [g scoreForTeam:team].intValue;
    if (nonBiddersPoints < 0) {
      nonBiddersPoints = 0;
    }
  }
  
  return nonBiddersPoints;
}

+ (BOOL)bidderWonHand:(NSString *)hand withTricksWon:(NSUInteger)tricksWon {
  NSDictionary *aBidType = allTypes[hand];
  
  NSString *variation = aBidType[ssVariation];
  int bidTricks = [aBidType[ssTrick] intValue];
  
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

+ (NSString *)variation:(NSString *)hand {
  NSString *variation = nil;
  
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
