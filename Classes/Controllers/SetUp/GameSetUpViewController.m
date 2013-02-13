#import "GameSetUpViewController.h"


@implementation GameSetUpViewController

// MARK: static
static int tagOffset = 1000;

- (void)initWithGame:(Game *)g mostRecentSettings:(Setting *)recent {
  self.game = g;
  if (recent != nil) {
    [_game.setting setToMatch:recent];
  }
}

- (void)reloadElements {
  [_firstToCross setOn:_game.setting.firstToCross.boolValue];
  [_nonBidderScoresTen setOn:_game.setting.nonBidderScoresTen.boolValue];
  [_noOneBid setOn:_game.setting.noOneBid.boolValue];

  [self.tableView reloadData];
}

- (IBAction)start:(id)sender {
  // add name and settings to game
  NSMutableOrderedSet* names = [[NSMutableOrderedSet alloc] initWithCapacity:[_teamFields count]];
  for (UITextField *field in _teamFields) {
    NSString *name = field.placeholder;
    if (field.text != nil && ![field.text isEqualToString:@""]) {
      name = field.text;
    }

    [names addObject:name];
  }

  [_game setTeamsByNames:names];
  [_delegate applySettingsForGame:_game fromController:self];
}

- (IBAction)cancel:(id)sender {
  [_delegate cancelSettingsForGame:_game fromController:self];
}

- (IBAction)firstToCrossChanged:(id)sender {
  _game.setting.firstToCross = @(((UISwitch *)sender).on);
}

- (IBAction)nonBidderScoresTenChanged:(id)sender {
  _game.setting.nonBidderScoresTen = @(((UISwitch *)sender).on);
}

- (IBAction)noOneBidChanged:(id)sender {
  _game.setting.noOneBid = @(((UISwitch *)sender).on);
}

// MARK: Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"GameMode"]) {
    GameModeViewController *controller = segue.destinationViewController;
    [controller initWithSetting:_game.setting];
  }
  else if ([segue.identifier isEqualToString:@"Tournament"]) {
    GameTournamentViewController *controller = segue.destinationViewController;
    [controller initWithSetting:_game.setting];
  }
}

// MARK: View
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self reloadElements];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

// MARK: TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
  int nextIndex = (textField.tag - tagOffset + 1) % [self.game.setting numberOfTeams];
  UITextField* next = _teamFields[nextIndex];

  if (nextIndex == 0) {
    [textField endEditing:YES];
  }
  else {
    [next becomeFirstResponder];
  }

  return YES;
}

// MARK: tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 2) {
    if ([self.game.setting.mode isEqualToString:@"Quebec mode"]) {
      return 1;
    }
  }

  return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

  if ([cell.reuseIdentifier isEqualToString:@"GameMode"]) {
    cell.detailTextLabel.text = _game.setting.mode;
  }
  else if ([cell.reuseIdentifier isEqualToString:@"Tournament"]) {
    cell.detailTextLabel.text = [_game.setting textForCurrentTournament];
  }

  return cell;
}

@end
