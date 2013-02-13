#import "Kiwi.h"
#import "BidType.h"

SPEC_BEGIN(BidTypeSpec)

describe(@"BidType", ^{
  __block NSManagedObjectContext *_moc = nil;
  __block NSDictionary *_settings = nil;
  __block Setting *_currentSetting = nil;

  void (^checkScores) (Setting *, NSString *, int, int, int) = ^void (Setting *setting, NSString *hand, int tricksWon, int bidderExpectedPoints, int nonBidderExpectedPoints) {
    Game *g = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:_moc];
    Round *r = [NSEntityDescription insertNewObjectForEntityForName:@"Round" inManagedObjectContext:_moc];
    Team *bidder = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:_moc];
    Team *nonBidder = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:_moc];
    
    g.setting = setting;
    r.bid = hand;
    if (![hand isEqualToString:@"NB"]) {
      [r addBiddingTeamsObject:bidder];
    }
    [g addTeamsObject:bidder];
    [g addTeamsObject:nonBidder];
    [g addRoundsObject:r];
    
    int bidderTricksWon = tricksWon;
    int nonBidderTricksWon = 10 - tricksWon;
    
    int bidderResult = [BidType pointsForTeam:bidder game:g andTricksWon:bidderTricksWon];
    int nonBidderResult = [BidType pointsForTeam:nonBidder game:g andTricksWon:nonBidderTricksWon];
    
    [[theValue(bidderResult) should] equal:theValue(bidderExpectedPoints)];
    [[theValue(nonBidderResult) should] equal:theValue(nonBidderExpectedPoints)];
  };
  
  beforeAll(^{
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    [psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    _moc = [[NSManagedObjectContext alloc] init];
    _moc.persistentStoreCoordinator = psc;
    
    Setting *defaultSetting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:_moc];
    
    Setting *nonBidderScoresZeroSetting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:_moc];
    nonBidderScoresZeroSetting.nonBidderScoresTen = @NO;
    
    Setting *noOneBidSetting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:_moc];
    noOneBidSetting.noOneBid = @YES;
    
    Setting *quebecSetting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:_moc];
    quebecSetting.mode = @"Quebec mode";
    
    _settings = @{@"default": defaultSetting, @"non bidder scores zero": nonBidderScoresZeroSetting, @"no one bid": noOneBidSetting, @"quebec mode": quebecSetting};
    
  });
  
  context(@"scores on default settings", ^{
    beforeAll(^{
      _currentSetting = _settings[@"default"];
    });

    it(@"bidders lose", ^{
      checkScores(_currentSetting, @"CM", 1, -250, 0);
      checkScores(_currentSetting, @"10H", 7, -500, 30);
    });

    it(@"bidders win", ^{
      checkScores(_currentSetting, @"6S", 6, 40, 40);
      checkScores(_currentSetting, @"8NT", 9, 320, 10);
      checkScores(_currentSetting, @"OM", 0, 500, 0);
    });

    it(@"bidders slam", ^{
      // when bid lower than 250 pts
      checkScores(_currentSetting, @"7D", 10, 250, 0);

      // when bid higher than 250 pts
      checkScores(_currentSetting, @"9C", 10, 360, 0);
    });
  });
  
  context(@"no bid", ^{
    beforeAll(^{
      _currentSetting = _settings[@"no one bid"];
    });
    
    it(@"scores 10 per trick to each team", ^{
      checkScores(_currentSetting, @"NB", 7, 70, 30);
    });
  });
  
  context(@"non bidder 0 points per trick", ^{
    beforeAll(^{
      _currentSetting = _settings[@"non bidder scores zero"];
    });
    
    it(@"non bidder scores 0", ^{
      checkScores(_currentSetting, @"7D", 7, 180, 0);
    });
  });
  
  context(@"quebec mode", ^{
    beforeAll(^{
      _currentSetting = _settings[@"quebec mode"];
    });
    
    it(@"scores double for misére", ^{
      checkScores(_currentSetting, @"OM", 0, 1000, 0);
    });

    it(@"successful defending team wins bid points", ^{
      checkScores(_currentSetting, @"7NT", 6, 0, 220);
      checkScores(_currentSetting, @"CM", 1, 0, 500);
    });

    it(@"unsuccessful defending team wins zero points", ^{
      checkScores(_currentSetting, @"8S", 8, 240, 0);
    });
  });
});

SPEC_END
