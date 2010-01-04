//
//  GameViewController.m
//
//  Created by Ben Walsham on 23/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import "GameViewController.h"
#import "ScoreFiveHundredAppDelegate.h"

@interface GameViewController()

- (NSString*) nonBlankFirst:(NSString*)first OtherwiseSecond:(NSString*)second;
- (void) gameComplete;
- (void) undoGameComplete;
- (void) checkForGameOver;

@end


@implementation GameViewController

// MARK: static
static NSString *ssStoreRounds        = @"rounds";
static NSString *ssStoreNameTeamOne   = @"team one name";
static NSString *ssStoreNameTeamTwo   = @"team two name";
static NSString *ssStoreScoreTeamOne  = @"team one score";
static NSString *ssStoreScoreTeamTwo  = @"team two score";
static NSString *ssStoreWinningSlot   = @"winning slot";
static NSString *ssStoreLastPlayed    = @"last played";

static NSString *ssBidTeamOne             = @"team one bid";
static NSString *ssBidTeamTwo             = @"team two bid";
static NSString *ssBidAchievedTeamOne     = @"team one bid achieved";
static NSString *ssBidAchievedTeamTwo     = @"team two bid achieved";
static NSString *ssTricksWonTeamOne       = @"team one tricks won";
static NSString *ssTricksWonTeamTwo       = @"team two tricks won";
static NSString *ssPointsForRoundTeamOne  = @"team one points for round";
static NSString *ssPointsForRoundTeamTwo  = @"team two points for round";
static NSString *ssSubTotalTeamOne        = @"team one sub total";
static NSString *ssSubTotalTeamTwo        = @"team two sub total";

static int siMaximumTricks = 10;
static int siWinningScore = 500;
static int siLosingScore = -500;

// MARK: synthesize
@synthesize roundsTableView;
@synthesize cellWrapper;
@synthesize editButton;
@synthesize teamOneName;
@synthesize teamTwoName;
@synthesize teamOneBid;
@synthesize teamTwoBid;
@synthesize teamOneResult;
@synthesize teamTwoResult;

@synthesize game;
@synthesize gameKey;
@synthesize rounds;
@synthesize slotTeamOne;
@synthesize slotTeamTwo;
@synthesize oldNameTeamOne;
@synthesize oldNameTeamTwo;
@synthesize curNameTeamOne;
@synthesize curNameTeamTwo;
@synthesize winningSlot;
@synthesize lastPlayed;
@synthesize newGame;
@synthesize currentBiddingTeamSlot;

- (void) dealloc {  
  [roundsTableView release];
  [cellWrapper release];
  [editButton release];
  [teamOneName release];
  [teamTwoName release];
  [teamOneBid release];
  [teamTwoBid release];
  [teamOneResult release];
  [teamOneResult release];
  
  [rounds release];
  [slotTeamOne release];
  [slotTeamTwo release];
  [oldNameTeamOne release];
  [oldNameTeamTwo release];
  [curNameTeamOne release];
  [curNameTeamTwo release];
  [winningSlot release];
  
  [super dealloc];
}

- (IBAction) edit:(id)sender {
  [self setEditing:!self.editing animated:YES];
}

- (IBAction) bid:(id)sender {
  NSString* teamName = nil;

  if ([self.teamOneBid isEqual:sender]) {
    self.currentBiddingTeamSlot = self.slotTeamOne;
    teamName = [self nonBlankFirst:self.curNameTeamOne OtherwiseSecond:self.teamOneName.placeholder];
  }
  else if ([self.teamTwoBid isEqual:sender]) {
    self.currentBiddingTeamSlot = self.slotTeamTwo;
    teamName = [self nonBlankFirst:self.curNameTeamTwo OtherwiseSecond:self.teamTwoName.placeholder];
  }

  ScoreFiveHundredAppDelegate *app = (ScoreFiveHundredAppDelegate*)[[UIApplication sharedApplication] delegate];

  [app bidForTeamName:teamName];
}

- (void) cancelEdit {
  self.teamOneName.text = self.oldNameTeamOne;
  self.teamTwoName.text = self.oldNameTeamTwo;
  [self setEditing:NO animated:YES];
}

- (void) openGame:(NSDictionary*)gameToOpen WithKey:(NSString *)key AndIsNewGame:(BOOL)isNewGame {
  self.newGame = isNewGame;
  self.slotTeamOne = [NSNumber numberWithInt:0];
  self.slotTeamTwo = [NSNumber numberWithInt:1];

  self.gameKey = key;
  self.game = [NSMutableDictionary dictionaryWithDictionary:gameToOpen];
  self.rounds = [NSMutableArray arrayWithArray:[self.game objectForKey:ssStoreRounds]];
  self.curNameTeamOne = [self.game valueForKey:ssStoreNameTeamOne];
  self.curNameTeamTwo = [self.game valueForKey:ssStoreNameTeamTwo];
  self.winningSlot = [self.game valueForKey:ssStoreWinningSlot];
  self.lastPlayed = [self.game valueForKey:ssStoreLastPlayed];

  NSLog(@"self.gameKey: %@", self.gameKey);
  NSLog(@"self.game: %@", self.game);
}

- (void) updateRoundWithHand:(NSString*)hand AndTricksWon:(NSNumber*)tricksWon {
  // create a new round
  NSNumber *bidderPoints = [BidType biddersPointsForHand:hand AndBiddersTricksWon:tricksWon];
  NSNumber *nonBidderPoints = [BidType nonBiddersPointsForHand:hand AndBiddersTricksWon:tricksWon];

  NSString *teamOneBidAttempted = nil;
  NSString *teamTwoBidAttempted = nil;
  NSNumber *teamOneBidAchieved = nil;
  NSNumber *teamTwoBidAchieved = nil;
  int teamOneTricksWon = 0;
  int teamTwoTricksWon = 0;
  int teamOnePointsForRound = 0;
  int teamTwoPointsForRound = 0;
  int teamOneScore = 0;
  int teamTwoScore = 0;
  
  if ([self.slotTeamOne isEqual:self.currentBiddingTeamSlot]) {
    teamOneBidAttempted = hand;
    teamOneBidAchieved = [NSNumber numberWithBool:[BidType bidderWonHand:hand WithTricksWon:tricksWon]];
    teamOneTricksWon = [tricksWon intValue];
    teamTwoTricksWon = siMaximumTricks - [tricksWon intValue];
    
    teamOnePointsForRound += [bidderPoints intValue];
    teamTwoPointsForRound += [nonBidderPoints intValue];
  }
  else {
    teamTwoBidAttempted = hand;
    teamTwoBidAchieved = [NSNumber numberWithBool:[BidType bidderWonHand:hand WithTricksWon:tricksWon]];
    teamTwoTricksWon = [tricksWon intValue];
    teamOneTricksWon = siMaximumTricks - [tricksWon intValue];

    teamOnePointsForRound += [nonBidderPoints intValue];
    teamTwoPointsForRound += [bidderPoints intValue];
  }

  if ([self.rounds count] > 0) {
    // previous round's sub-total and current round's points
    teamOneScore = [[[self.rounds objectAtIndex:0] valueForKey:ssSubTotalTeamOne] intValue];
    teamTwoScore = [[[self.rounds objectAtIndex:0] valueForKey:ssSubTotalTeamTwo] intValue];
  }
  
  teamOneScore += teamOnePointsForRound;
  teamTwoScore += teamTwoPointsForRound;
  
  
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  
  [dict setValue:teamOneBidAttempted forKey:ssBidTeamOne];
  [dict setValue:teamTwoBidAttempted forKey:ssBidTeamTwo];
  [dict setValue:teamOneBidAchieved forKey:ssBidAchievedTeamOne];
  [dict setValue:teamTwoBidAchieved forKey:ssBidAchievedTeamTwo];
  [dict setValue:[NSNumber numberWithInt:teamOneTricksWon] forKey:ssTricksWonTeamOne];
  [dict setValue:[NSNumber numberWithInt:teamTwoTricksWon] forKey:ssTricksWonTeamTwo];
  [dict setValue:[NSNumber numberWithInt:teamOnePointsForRound] forKey:ssPointsForRoundTeamOne];
  [dict setValue:[NSNumber numberWithInt:teamTwoPointsForRound] forKey:ssPointsForRoundTeamTwo];
  [dict setValue:[NSNumber numberWithInt:teamOneScore] forKey:ssSubTotalTeamOne];
  [dict setValue:[NSNumber numberWithInt:teamTwoScore] forKey:ssSubTotalTeamTwo];
  
  [self.rounds insertObject:dict atIndex:0];
  
  [self.roundsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
  
  [self checkForGameOver];

  [dict release];
  
  NSLog(@"%@", self.rounds);
}

// MARK: Hidden functions
- (NSString*) nonBlankFirst:(NSString*)first OtherwiseSecond:(NSString*)second {
  if (first == nil || [@"" isEqual:first]) {
    return second;
  }
  
  return first;
}

- (void) gameComplete {
  self.teamOneBid.hidden = NO;
  self.teamTwoBid.hidden = NO;
  self.teamOneResult.hidden = YES;
  self.teamTwoResult.hidden = YES;
  
  if (self.winningSlot) {
    self.teamOneBid.hidden = YES;
    self.teamTwoBid.hidden = YES;
    
    if ([self.winningSlot isEqual:self.slotTeamOne]) {
      self.teamOneResult.hidden = NO;
    }
    else {
      self.teamTwoResult.hidden = NO;
    }
  }
}

- (void) undoGameComplete {
  self.winningSlot = nil;
}

- (void) checkForGameOver {
  if ([self.rounds count] > 0) {
    NSDictionary *r = [self.rounds objectAtIndex:0];
    
    BOOL teamOneBidAchieved = [[r valueForKey:ssBidAchievedTeamOne] boolValue];
    BOOL teamTwoBidAchieved = [[r valueForKey:ssBidAchievedTeamTwo] boolValue];
    int teamOneScore        = [[r valueForKey:ssSubTotalTeamOne] intValue];
    int teamTwoScore        = [[r valueForKey:ssSubTotalTeamTwo] intValue];
    
    if ((teamOneBidAchieved && teamOneScore >= siWinningScore) || (teamTwoScore <= siLosingScore)) {
      self.winningSlot = slotTeamOne;
    }
    else if ((teamTwoBidAchieved && teamTwoScore >= siWinningScore) || (teamOneScore <= siLosingScore)) {
      self.winningSlot = self.slotTeamTwo;
    }
  }
  
  [self gameComplete];
}

// MARK: View
- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.teamOneName.text = self.curNameTeamOne;
  self.teamTwoName.text = self.curNameTeamTwo;
  
  [self checkForGameOver];
  [self.roundsTableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (self.isNewGame) {
    // if edit gets called before the view is loaded then the placeholder text position gets screwed up
    [self edit:self];
    self.newGame = NO;
  }  
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  NSNumber* teamOneScore = [NSNumber numberWithInt:0];
  NSNumber* teamTwoScore = [NSNumber numberWithInt:0];

  if ([self.rounds count] > 0) {
    teamOneScore = [[self.rounds objectAtIndex:0] valueForKey:ssSubTotalTeamOne];
    teamTwoScore = [[self.rounds objectAtIndex:0] valueForKey:ssSubTotalTeamTwo];
  }
  
  [self.game setValue:self.rounds forKey:ssStoreRounds];
  [self.game setValue:self.teamOneName.text forKey:ssStoreNameTeamOne];
  [self.game setValue:self.teamTwoName.text forKey:ssStoreNameTeamTwo];
  [self.game setValue:teamOneScore forKey:ssStoreScoreTeamOne];
  [self.game setValue:teamTwoScore forKey:ssStoreScoreTeamTwo];
  [self.game setValue:self.winningSlot forKey:ssStoreWinningSlot];
  [self.game setValue:self.lastPlayed forKey:ssStoreLastPlayed];
  
  ScoreFiveHundredAppDelegate* app = (ScoreFiveHundredAppDelegate*)[[UIApplication sharedApplication] delegate];
  
  [app saveGame:self.game ForKey:self.gameKey];
  
  NSLog(@"self.game: %@", self.game);
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];

  [self.roundsTableView setEditing:editing animated:animated];
  
  int growTextFieldsBy = 44;
  double growTextFieldDuration = 0.1;
  
  CGRect rectOne = self.teamOneName.frame;
  CGRect rectTwo = self.teamTwoName.frame;
  if (self.editing) {
    self.editButton.title = @"Done";
    self.teamOneName.enabled = YES;
    self.teamTwoName.enabled = YES;
    self.teamOneBid.hidden = YES;
    self.teamTwoBid.hidden = YES;
    self.teamOneResult.hidden = YES;
    self.teamTwoResult.hidden = YES;
    
    self.teamOneName.borderStyle = UITextBorderStyleRoundedRect;
    self.teamTwoName.borderStyle = UITextBorderStyleRoundedRect;

    rectOne.origin.x -= growTextFieldsBy;
    rectOne.size.width += growTextFieldsBy;
    rectTwo.size.width += growTextFieldsBy;

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit)] autorelease];
    
    self.oldNameTeamOne = self.teamOneName.text;
    self.oldNameTeamTwo = self.teamTwoName.text;
    
    [self.teamOneName becomeFirstResponder];
  }
  else {
    editButton.title = @"Edit";
    self.teamOneName.enabled = NO;
    self.teamTwoName.enabled = NO;
    [self checkForGameOver];
    self.teamOneName.borderStyle = UITextBorderStyleNone;
    self.teamTwoName.borderStyle = UITextBorderStyleNone;
    
    self.curNameTeamOne = self.teamOneName.text;
    self.curNameTeamTwo = self.teamTwoName.text;

    rectOne.size.width -= growTextFieldsBy;
    rectOne.origin.x += growTextFieldsBy;
    rectTwo.size.width -= growTextFieldsBy;
    self.navigationItem.leftBarButtonItem = nil;
  }

  [UIView beginAnimations:@"Resize on edit" context:nil];
  [UIView setAnimationDuration:growTextFieldDuration];
  self.teamOneName.frame = rectOne;
  self.teamTwoName.frame = rectTwo;
  [UIView commitAnimations];
}

// MARK: TextField delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
  if ([self.teamOneName isEqual:textField]) {
    [self.teamTwoName becomeFirstResponder];
  }
  else {
    [self.teamOneName becomeFirstResponder];
    [self setEditing:NO animated:YES];
  }
  
  return YES;
}

// MARK: UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.rounds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CellScoringRound";
  
  CellScoringRound *cellScoringRound = (CellScoringRound *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellScoringRound == nil) {
    [cellWrapper loadMyNibFile:CellIdentifier];
    cellScoringRound = (CellScoringRound *)cellWrapper.cell;
  }
  
  NSDictionary *r = [self.rounds objectAtIndex:indexPath.row];

  NSString *teamOneBidAttempted = [r valueForKey:ssBidTeamOne];
  NSString *teamTwoBidAttempted = [r valueForKey:ssBidTeamTwo];
  BOOL teamOneBidAchieved  = [[r valueForKey:ssBidAchievedTeamOne] boolValue];
  BOOL teamTwoBidAchieved  = [[r valueForKey:ssBidAchievedTeamTwo] boolValue];
  
  [cellScoringRound setStyleForTeamOneBidAttempted:teamOneBidAttempted AndTeamOneBidAchieved:teamOneBidAchieved WithTeamTwoBidAttempted:teamTwoBidAttempted AndTeamTwoBidAchieved:teamTwoBidAchieved];

  // set round summary text for each team
  [cellScoringRound descriptionForTeamSlot:self.slotTeamOne FromTricksWon:[r valueForKey:ssTricksWonTeamOne] AndPoints:[r valueForKey:ssPointsForRoundTeamOne]];
  [cellScoringRound descriptionForTeamSlot:self.slotTeamTwo FromTricksWon:[r valueForKey:ssTricksWonTeamTwo] AndPoints:[r valueForKey:ssPointsForRoundTeamTwo]];

  cellScoringRound.pointsTeamOneLabel.text = [[r valueForKey:ssSubTotalTeamOne] stringValue];
  cellScoringRound.pointsTeamTwoLabel.text = [[r valueForKey:ssSubTotalTeamTwo] stringValue];

  return cellScoringRound;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // never selectable
  return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  BOOL canEdit = NO;

  if (0 == indexPath.row) {
    canEdit = YES;
  }
  return canEdit;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.rounds removeObjectAtIndex:indexPath.row];
    [self undoGameComplete];

    // reload table view
    [self.roundsTableView reloadData];
  }
}

@end
