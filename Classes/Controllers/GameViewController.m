#import "GameViewController.h"
#import "Game.h"
#import "Round.h"


@interface GameViewController ()

@property IBOutlet UIBarButtonItem *addBarButton;
@property IBOutlet UIBarButtonItem *rematchBarButton;
@property ScoreMiniViewController *scoreSummary;
@property Game *game;

- (IBAction)rematch:(id)sender;
- (NSString *)nonBlankFirst:(NSString *)first otherwiseSecond:(NSString *)second;
- (void)refresh;
- (void)gameComplete;

@end

@implementation GameViewController

#pragma mark Public

- (void)initWithGame:(Game *)g {
  self.game = g;
}

#pragma mark Private

- (IBAction)rematch:(id)sender {
  [_delegate rematchForGame:_game fromController:self];
}

- (NSString *)nonBlankFirst:(NSString *)first otherwiseSecond:(NSString *)second {
  if (first == nil || [@"" isEqual:first]) {
    return second;
  }
  
  return first;
}

- (void)refresh {
  [self.scoreSummary initWithGame:_game];

  [self.tableView reloadData];
  [self.tableView scrollsToTop];
  [self gameComplete];
}

- (void)gameComplete {
  [self.navigationItem setRightBarButtonItem:self.addBarButton animated:NO];

  if (self.game.isComplete.boolValue) {
    NSString *winningTeamNames = [self.game teamNames:self.game.winningTeams];
    [self.navigationItem setRightBarButtonItem:self.rematchBarButton animated:NO];

    if ([[NSDate date] timeIntervalSinceDate:self.game.lastPlayed] < 2) {
      NSString *msg = [NSString stringWithFormat:@"%@ win!", winningTeamNames];
      UIAlertView *rematchAlert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Rematch", nil];
      [rematchAlert show];
    }
  }
}

#pragma mark Round delegate

- (void)cancelRoundForGame:(Game *)g fromController:(UIViewController *)controller {
  [g undoRound];

  [self.navigationController popViewControllerAnimated:YES];
}

- (void)applyRoundForGame:(Game *)g fromController:(UIViewController *)controller {
  [self.navigationController popToViewController:self animated:YES];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ScoreSummary"]) {
    self.scoreSummary = segue.destinationViewController;
    [_scoreSummary initWithGame:_game];
  }
  else if ([segue.identifier rangeOfString:@"NewRound"].location == 0) {
    [self setEditing:NO animated:NO];
    HighestBiddingTeamViewController *controller = segue.destinationViewController;
    [controller initWithGame:_game];
    controller.delegate = self;
  }
}

#pragma mark View

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

#pragma mark Alertview delegate

- (void)alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger)index {
  if (index == 1) {
    [self rematch:@"alertView"];
  }
}

#pragma mark Tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    return nil;
  }
  else {
    return @"Rounds";
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return _game.rounds.count;
  }
  else {
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;

  if (indexPath.section == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"Round"];

    [((CellScoringRound *)cell) setStyleForRound:[_game.rounds reversedOrderedSet][indexPath.row]];
  }
  else {
    if (self.game.isComplete.boolValue) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"Rematch"];
      NSString *winningTeamNames = [self.game teamNames:self.game.winningTeams];
      UIButton *rematchButton = cell.contentView.subviews.firstObject;
      rematchButton.titleLabel.text = [NSString stringWithFormat:@"%@ win! Rematch?", winningTeamNames];
    }
    else {
      cell = [tableView dequeueReusableCellWithIdentifier:@"NewRound"];
    }
  }

  return cell;
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  return nil;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
  BOOL canEdit = NO;

  if (self.game.rounds.count - 1 == indexPath.row) {
    canEdit = YES;
  }
  return canEdit;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.game removeObjectFromRoundsAtIndex:0];
    [self.game save];

    [self refresh];
  }
}

@end
