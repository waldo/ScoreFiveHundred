//
//  ScoreFiveHundredAppDelegate.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 26/11/2009.
//  Copyright MeltingWaldo 2009. All rights reserved.
//

#import "ScoreFiveHundredAppDelegate.h"

@implementation ScoreFiveHundredAppDelegate
// MARK: static
static NSString *ssStoreGames         = @"five hundred games";
//static NSString *ssStoreRounds        = @"rounds";
static NSString *ssStoreNameTeamOne   = @"team one name";
static NSString *ssStoreNameTeamTwo   = @"team two name";
static NSString *ssStoreScoreTeamOne  = @"team one score";
static NSString *ssStoreScoreTeamTwo  = @"team two score";
static NSString *ssStoreWinningSlot   = @"winning slot";
static NSString *ssStoreLastPlayed    = @"last played";

// MARK: synthesize
@synthesize window;

@synthesize navigationController;

@synthesize gameListController;
@synthesize cellWrapper;
@synthesize gameListTableView;

@synthesize gameController;

@synthesize biddingController;

@synthesize currentBidIsWithTeamSlot;
@synthesize gameKeys;
@synthesize gameList;


+ (NSString *) uniqueId {
  CFUUIDRef uniqueId = CFUUIDCreate(NULL);
  NSString *sUniqueId = (NSString *)CFUUIDCreateString(NULL, uniqueId); // convert to string
  CFRelease(uniqueId);
  
  return [sUniqueId autorelease];
}

- (IBAction) newGame {
  [self viewGameForKey:[ScoreFiveHundredAppDelegate uniqueId] AndIsNewGame:YES];
}

- (IBAction) teamOneBid {
  [self teamBid:0];
}

- (IBAction) teamTwoBid {
  [self teamBid:1];
}

- (IBAction) cancelScore {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) saveScore {
  // work out what was clicked
  NSNumber *tricksWon = [self.biddingController tricksWon];
  NSString *hand = [self.biddingController hand];

  // update round gameController
  [self.gameController updateRound:NO ForTeamSlot:self.currentBidIsWithTeamSlot ForHand:hand AndTricksWon:tricksWon];
  
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewGameForKey:(NSString*)key AndIsNewGame:(BOOL)newGame {
  [self.gameController openGameForKey:key AndIsNewGame:newGame];
  [self.navigationController pushViewController:self.gameController animated:YES];
}  

- (void) teamBid:(int)teamSlot {
  self.currentBidIsWithTeamSlot = [NSNumber numberWithInt:teamSlot];
  self.biddingController.title = [NSString stringWithFormat:@"%@ Bid", [self.gameController teamNameForSlot:self.currentBidIsWithTeamSlot]];
  [self.navigationController pushViewController:self.biddingController animated:YES];
}

- (void) applicationDidFinishLaunching:(UIApplication *)application {

  [self.window addSubview:[self.navigationController view]];
  [self.window makeKeyAndVisible];
}

// TODO: split game list into own custom view controller
- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  if ([self.gameListController isEqual:viewController]) {
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    self.gameList = [NSMutableDictionary dictionaryWithDictionary:[store dictionaryForKey:ssStoreGames]];
    self.gameKeys = [NSMutableArray arrayWithArray:[self.gameList allKeys]];  
    
    [self.gameListTableView reloadData];
  }
}

//
// UITableView delegate methods
//

// TODO: split game list into own custom view controller
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.gameListTableView isEqual:tableView]) {
    [self viewGameForKey:[self.gameKeys objectAtIndex:indexPath.row] AndIsNewGame:NO];
  }
}

// TODO: split game list into own custom view controller
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  int count = 0;
  
  if ([self.gameListTableView isEqual:tableView]) {
    count = [self.gameKeys count];
  }
  
  return count;
}

// TODO: split game list into own custom view controller
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //if ([self.gameListTableView isEqual:tableView]) {
  static NSString *CellIdentifier = @"CellGame";
  
  CellGame *cellGame = (CellGame *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellGame == nil) {
    [self.cellWrapper loadMyNibFile:CellIdentifier];
    cellGame = (CellGame *)self.cellWrapper.cell;
  }
  
  NSDictionary *game = [self.gameList valueForKey:[self.gameKeys objectAtIndex:indexPath.row]];
  
  cellGame.nameTeamOne.text = [game valueForKey:ssStoreNameTeamOne];
  cellGame.nameTeamTwo.text = [game valueForKey:ssStoreNameTeamTwo];
  cellGame.pointsTeamOne.text = [[game valueForKey:ssStoreScoreTeamOne] stringValue];
  cellGame.pointsTeamTwo.text = [[game valueForKey:ssStoreScoreTeamTwo] stringValue];

  // show icon for winning team
  NSNumber* winningSlot = [game valueForKey:ssStoreWinningSlot];
  if (winningSlot == nil) {
    cellGame.symbolResultTeamOne.hidden = YES;
    cellGame.symbolResultTeamTwo.hidden = YES;
  }
  else if (0 == [winningSlot intValue]) {
    cellGame.symbolResultTeamOne.hidden = NO;
  }
  else if (1 == [winningSlot intValue]) {
    cellGame.symbolResultTeamTwo.hidden = NO;
  }

  cellGame.dateLastPlayed.text = [game valueForKey:ssStoreLastPlayed];
  
  return cellGame;
}

- (void) dealloc {
  [window release];
  [navigationController release];
  [gameListController release];
  [cellWrapper release];
  [gameController release];
  [biddingController release];

  [super dealloc];
}
@end