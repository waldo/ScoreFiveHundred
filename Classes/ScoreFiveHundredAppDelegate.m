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
@synthesize gameListTableView;

@synthesize gameController;

@synthesize roundController;
@synthesize bidSelectionTableView;
@synthesize cellWrapper;
@synthesize tricksWonSegmentedControl;

@synthesize bidTypeHands;
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
  NSNumber *tricksWon = [NSNumber numberWithLong:self.tricksWonSegmentedControl.selectedSegmentIndex];
  NSString *hand = [self.bidTypeHands objectAtIndex:[[self.bidSelectionTableView indexPathForSelectedRow] row]];

  // update round gameController
  [self.gameController updateRound:(BOOL)NO ForTeamSlot:self.currentBidIsWithTeamSlot ForHand:hand AndTricksWon:tricksWon];
  
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewGameForKey:(NSString*)key AndIsNewGame:(BOOL)newGame {
  [self.gameController openGameForKey:key AndIsNewGame:newGame];
  [self.navigationController pushViewController:self.gameController animated:YES];
}  

- (void) teamBid:(int)teamSlot {
  self.currentBidIsWithTeamSlot = [NSNumber numberWithInt:teamSlot];
  self.roundController.title = [NSString stringWithFormat:@"%@ Bid", [self.gameController teamNameForSlot:self.currentBidIsWithTeamSlot]];
  [self.bidSelectionTableView deselectRowAtIndexPath:[self.bidSelectionTableView indexPathForSelectedRow] animated:NO];
  [self.tricksWonSegmentedControl setSelectedSegmentIndex:5];
  [self.navigationController pushViewController:self.roundController animated:YES];
}

- (void) applicationDidFinishLaunching:(UIApplication *)application {
  self.bidTypeHands = [BidType orderedHands];

  [self.window addSubview:[self.navigationController view]];
  [self.window makeKeyAndVisible];
}

// TODO: split game list and bids into own custom view controllers
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

// TODO: split game list and bids into own custom view controllers
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.gameListTableView isEqual:tableView]) {
    [self viewGameForKey:[self.gameKeys objectAtIndex:indexPath.row] AndIsNewGame:NO];
  }
}

// TODO: split game list and bids into own custom view controllers
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  int count = 0;
  
  if ([self.gameListTableView isEqual:tableView]) {
    count = [self.gameKeys count];
  }
  else if ([self.bidSelectionTableView isEqual:tableView]) {
    count = [self.bidTypeHands count];
  }
  
  return count;
}

// TODO: split game list and bids into own custom view controllers
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.gameListTableView isEqual:tableView]) {
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
  else { //if ([self.bidSelectionTableView isEqual:tableView]) {
    static NSString *CellIdentifier = @"CellBidType";
    
    CellBidType *cellBidType = (CellBidType *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cellBidType == nil) {
      [self.cellWrapper loadMyNibFile:CellIdentifier];
      cellBidType = (CellBidType *)self.cellWrapper.cell;
    }
    
    NSString *key = [self.bidTypeHands objectAtIndex:indexPath.row];
    
    cellBidType.symbolLabel.text = [BidType tricksAndSymbolForHand:key];

    if ([[BidType suitColourForHand:key] isEqual:@"red" ]) {
      cellBidType.symbolLabel.textColor = [UIColor redColor];
      cellBidType.symbolLabel.highlightedTextColor = [UIColor redColor];
    }
    else if ([[BidType suitColourForHand:key] isEqual:@"black" ]) {
      cellBidType.symbolLabel.textColor = [UIColor blackColor];
      cellBidType.symbolLabel.highlightedTextColor = [UIColor blackColor];
    }
    
    cellBidType.descriptionLabel.text = [BidType descriptionForHand:key];
    cellBidType.pointsLabel.text = [BidType pointsStringForHand:key];

    return cellBidType;
  }
}

- (void) dealloc {
  [window release];
  [navigationController release];
  [gameListController release];
  [gameController release];
  [roundController release];
  [bidSelectionTableView release];
  [cellWrapper release];
  [tricksWonSegmentedControl release];
  [bidTypeHands release];

  [super dealloc];
}
@end