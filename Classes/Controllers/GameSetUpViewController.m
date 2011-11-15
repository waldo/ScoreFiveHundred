#import "GameSetUpViewController.h"
#import "ScoreFiveHundredAppDelegate.h"

@implementation GameSetUpViewController

// MARK: static
static int tagOffset = 1000;

// MARK: synthesize
@synthesize 
  gameController,
  gameModeController,
  gameTournamentController,
  table,
  startButton,
  game,
  teamNameTextFields;

- (void) dealloc {
  [gameController release];
  [gameModeController release];
  [gameTournamentController release];
  [table release];
  [startButton release];  
  [game release];
  [teamNameTextFields release];
  
  [super dealloc];
}

- (IBAction) start:(id)sender {
  //  add name and settings to game
  NSMutableOrderedSet* names = [[[NSMutableOrderedSet alloc] initWithCapacity:[self.teamNameTextFields count]] autorelease];
  for (int i = 0; i < [self.game.setting numberOfTeams]; ++i) {
    UITextField* field = [self.teamNameTextFields objectAtIndex:i];
    NSString* name = [NSString stringWithFormat:@"Team %d", field.tag + 1 - tagOffset];
    if (field.text != nil && ![@"" isEqualToString:field.text]) {
      name = field.text;
    }
    
    [names addObject:name];
  }
  
  // associate the previously unassociated game model
  ScoreFiveHundredAppDelegate* app = (ScoreFiveHundredAppDelegate*)[[UIApplication sharedApplication] delegate];
  [app.managedObjectContext insertObject:self.game.setting];
  [app.managedObjectContext insertObject:self.game];

  [self.game setTeamsByNames:names];

  UINavigationController *navController = self.navigationController;
    
  [self.gameController initWithGame:self.game];

  [navController popViewControllerAnimated:NO];
  [navController pushViewController:self.gameController animated:YES];
}

- (void) initWithGame:(Game*)g {
  self.game = g;

  for (UITextField* field in self.teamNameTextFields) {
    field.text = @"";
  }
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];

  self.title = @"Game Settings";
  
  [self.navigationItem setRightBarButtonItem:self.startButton animated:YES];

  self.teamNameTextFields = [[NSMutableOrderedSet alloc] init];
  NSArray* teamPlaceholders = [NSArray arrayWithObjects:@"The greatest", @"The greatest tribute", @"Tribute to a tribute", @"You've gone", @"Too far", nil];

  for (int i = 0; i < 5; ++i) {
    UITextField* playerTextField = [[[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)] autorelease];
    playerTextField.adjustsFontSizeToFitWidth = YES;
    playerTextField.textColor = [UIColor blackColor];
    playerTextField.keyboardType = UIKeyboardTypeDefault;
    playerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    playerTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    playerTextField.textAlignment = UITextAlignmentLeft;
    playerTextField.tag = i + tagOffset;
    playerTextField.delegate = self;
    playerTextField.placeholder = [teamPlaceholders objectAtIndex:i];

    [self.teamNameTextFields addObject:playerTextField];
  }
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.table reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

// MARK: TextField delegate
- (BOOL) textFieldShouldReturn:(UITextField*)textField {
  // mod 2 should be mod number of teams
  int nextIndex = (textField.tag - tagOffset + 1) % [self.game.setting numberOfTeams];
  UITextField* next = [self.teamNameTextFields objectAtIndex:nextIndex];

  if (nextIndex == 0) {
    [textField endEditing:YES];
  }
  else {
    [next becomeFirstResponder];
  }

  return YES;
}

- (void) textFieldDidBeginEditing:(UITextField*)textField {
  [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(textField.tag - tagOffset) inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
	return 4;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"";
  }
  else if (section == 1) {
    return @"Team names";
  }
  else if (section == 2) {
    return @"Settings";
  }
  else {
    return @"";
  }
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  }
  else if (section == 1) {
    return [game.setting numberOfTeams];
  }
  else if (section == 2) {
    return 4;
  }
  else if (section == 3) {
    return 1;
  }
  else {
    return 0;
  }
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellTeamSetting = @"CellTeamSetting";
  static NSString* CellTeamName = @"CellTeamName";
  static NSString* CellGeneralSetting = @"CellGeneralSetting";
  static NSString* CellDoneButton = @"CellDoneButton";
  
  UITableViewCell* cellTeamSetting = [tableView dequeueReusableCellWithIdentifier:CellTeamSetting];
  UITableViewCell* cellTeamName = [tableView dequeueReusableCellWithIdentifier:CellTeamName];
  UITableViewCell* cellGeneralSetting = [tableView dequeueReusableCellWithIdentifier:CellGeneralSetting];
  UITableViewCell* cellDoneButton = [tableView dequeueReusableCellWithIdentifier:CellDoneButton];
  UITableViewCell* cell = nil;
  
  if (indexPath.section == 0) {
    cell = cellTeamSetting;
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTeamSetting] autorelease];

      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      cell.textLabel.text = @"Game mode";
    }
    cell.detailTextLabel.text = game.setting.mode;
  }
  else if (indexPath.section == 1) {
    cell = cellTeamName;
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTeamName] autorelease];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = nil;
    cell.textLabel.text = [NSString stringWithFormat:@"Name %d", indexPath.row + 1];
    cell.accessoryView = [self.teamNameTextFields objectAtIndex:indexPath.row];
  }
  else if (indexPath.section == 2) {
    cell = cellGeneralSetting;
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellGeneralSetting] autorelease];
      cell.accessoryType = UITableViewCellAccessoryNone;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UISwitch* swit = [[[UISwitch alloc] initWithFrame:CGRectMake(250, 10, 35, 30)] autorelease];
    cell.accessoryView = nil;

    switch (indexPath.row) {
      case 0:
        cell.textLabel.text = @"Tournament";
        cell.detailTextLabel.text = [self.game.setting textForCurrentTournament];        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        break;
      case 1:
        cell.textLabel.text = @"First over the line wins";
        [swit setOn:[self.game.setting.firstToCross boolValue]];
        
        [swit addTarget:self action:@selector(firstToCrossChanged:) forControlEvents:UIControlEventValueChanged];
        break;
      case 2:
        cell.textLabel.text = @"10 pts non-bidder trick";
        [swit setOn:[self.game.setting.nonBidderScoresTen boolValue]];

        [swit addTarget:self action:@selector(nonBidderScoresTenChanged:) forControlEvents:UIControlEventValueChanged];
        break;
      case 3:
        cell.textLabel.text = @"Play when no-one bids";
        [swit setOn:[self.game.setting.noOneBid boolValue]];

        [swit addTarget:self action:@selector(noOneBidChanged:) forControlEvents:UIControlEventValueChanged];
        break;
      default:
        break;
    }

    if (!indexPath.row == 0) {
      [cell addSubview:swit];
      cell.accessoryView = swit;
    }
  }
  else if (indexPath.section == 3) {
    cell = cellDoneButton;
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDoneButton] autorelease];

      UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      doneButton.frame = CGRectMake(10, 0, CGRectGetWidth(cell.contentView.bounds)-20, CGRectGetHeight(cell.contentView.bounds)+3);
      [doneButton setTitle:@"Done" forState:UIControlStateNormal];
      [doneButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
      [cell addSubview:doneButton];
    }
  }

  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  if (indexPath.section == 0) {
    [self.gameModeController initWithSetting:self.game.setting];
    [self.navigationController pushViewController:self.gameModeController animated:YES];
  }
  else if (indexPath.section == 2 && indexPath.row == 0) {
    [self.gameTournamentController initWithSetting:self.game.setting];
    [self.navigationController pushViewController:self.gameTournamentController animated:YES];
  }
}

// MARK: UISwitch actions
- (void) firstToCrossChanged:(id)control {
  self.game.setting.firstToCross = [NSNumber numberWithBool:((UISwitch*)control).on];
}

- (void) nonBidderScoresTenChanged:(id)control {
  self.game.setting.nonBidderScoresTen = [NSNumber numberWithBool:((UISwitch*)control).on];
}

- (void) noOneBidChanged:(id)control {
  self.game.setting.noOneBid = [NSNumber numberWithBool:((UISwitch*)control).on];
}


@end
