//
//  BidTestCase.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 11/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import "BidTypeTest.h"


@implementation BidTypeTest

@synthesize errorOut;

- (void) setUp {
  self.errorOut = @"%@. %@, %@ tricks. Expected %@ pts. Got %@ pts.";
}

- (void) tearDown {
}


- (void) checkForHand:(NSString*)hand withTricksWon:(int)tricks bidderPoints:(int)bidderExpectedPoints andNonBidderPoints:(int)nonBidderExpectedPoints {
  NSNumber* tricksWon = [NSNumber numberWithInt:tricks];
  NSNumber* bidderPoints = [NSNumber numberWithInt:bidderExpectedPoints];
  NSNumber* nonBidderPoints = [NSNumber numberWithInt:nonBidderExpectedPoints];
  
  NSNumber* bidderResult = [BidType biddersPointsForHand:hand AndBiddersTricksWon:tricksWon];
  NSNumber* nonBidderResult = [BidType nonBiddersPointsForHand:hand AndBiddersTricksWon:tricksWon];
  
  STAssertTrue(
               [bidderPoints isEqual:bidderResult],
               [NSString stringWithFormat:self.errorOut, @"bidder", hand, tricksWon, bidderPoints, bidderResult]
               );
  STAssertTrue(
               [nonBidderPoints isEqual:nonBidderResult],
               [NSString stringWithFormat:self.errorOut, @"non-bidder", hand, tricksWon, nonBidderPoints, nonBidderResult]
               );
}

- (void) testBiddersLose {
  [self checkForHand:@"CM" withTricksWon:10 bidderPoints:-250 andNonBidderPoints:0];
  [self checkForHand:@"10H" withTricksWon:7 bidderPoints:-500 andNonBidderPoints:30];
}

- (void) testBiddersWin {
  [self checkForHand:@"6S" withTricksWon:6 bidderPoints:40 andNonBidderPoints:40];
  [self checkForHand:@"8NT" withTricksWon:9 bidderPoints:320 andNonBidderPoints:10];
  [self checkForHand:@"OM" withTricksWon:0 bidderPoints:500 andNonBidderPoints:0];
}

- (void) testBiddersSlam {
  // when bid lower than 250 pts
  [self checkForHand:@"7D" withTricksWon:10 bidderPoints:250 andNonBidderPoints:0];

  // when bid higher than 250 pts
  [self checkForHand:@"9C" withTricksWon:10 bidderPoints:360 andNonBidderPoints:0];
}

@end
