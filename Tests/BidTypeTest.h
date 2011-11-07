#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "BidType.h"

@interface BidTypeTest : SenTestCase {
  NSString* errorOut;
}

@property (nonatomic, retain) NSString* errorOut;

- (void) checkForHand:(NSString*)hand withTricksWon:(int)tricks bidderPoints:(int)bidderExpectedPoints andNonBidderPoints:(int)nonBidderExpectedPoints;

@end
