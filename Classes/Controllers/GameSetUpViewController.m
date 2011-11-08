#import "GameSetUpViewController.h"
#import "ScoreFiveHundredAppDelegate.h"

@implementation GameSetUpViewController

// MARK: static
static int tagOffset = 1000;

// MARK: synthesize
@synthesize gameController,
            table,
            startButton,
            game,
            teamNameTextFields;

- (void) dealloc {
  [gameController release];
  [table release];
  [startButton release];  
  [game release];
  [teamNameTextFields release];
  
  [super dealloc];
}

- (IBAction) start:(id)sender {
  //  add name and settings to game
  NSMutableOrderedSet* names = [[[NSMutableOrderedSet alloc] initWithCapacity:[self.teamNameTextFields count]] autorelease];
  for (UITextField* field in self.teamNameTextFields) {
    NSString* name = [NSString stringWithFormat:@"Team %d", field.tag + 1 - tagOffset];
    if (field.text != nil && ![@"" isEqualToString:field.text]) {
      name = field.text;
    }

    [names addObject:name];
  }
  
  // associate the previously unassociated game model
  ScoreFiveHundredAppDelegate* app = (ScoreFiveHundredAppDelegate*)[[UIApplication sharedApplication] delegate];
  [app.managedObjectContext insertObject:self.game];

  [self.game setTeamsByNames:names];

  UINavigationController *navController = self.navigationController;
    
  [self.gameController initWithGame:self.game];

  [navController popViewControllerAnimated:NO];
  [navController pushViewController:self.gameController animated:YES];
}

- (void) initWithGame:(Game*)g {
  self.game = g;
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];

  self.title = @"Game Settings";
  
  [self.navigationItem setRightBarButtonItem:self.startButton animated:YES];

  self.teamNameTextFields = [[NSMutableOrderedSet alloc] init];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  for (UITextField* field in self.teamNameTextFields) {
    field.text = @"";
  }
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
  int nextIndex = (textField.tag - tagOffset + 1) % 2;
  UITextField* next = [self.teamNameTextFields objectAtIndex:nextIndex];

  if (nextIndex == 0) {
    [textField endEditing:YES];
  }
  else {
    [next becomeFirstResponder];
  }

  return YES;
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
  // If paid 4, 2 otherwise.
  int sections = 4;

	return sections;
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
    return 2;
  }
  else if (section == 2) {
    return 5;
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
      cell.textLabel.text = @"Number of teams";
      cell.detailTextLabel.text = @"2";
    }
  }
  else if (indexPath.section == 1) {
    cell = cellTeamName;
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTeamName] autorelease];

      UITextField* playerTextField = [[[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)] autorelease];
      playerTextField.adjustsFontSizeToFitWidth = YES;
      playerTextField.textColor = [UIColor blackColor];
      if (indexPath.row == 0) {
        playerTextField.placeholder = @"The greatest";
      }
      else {
        playerTextField.placeholder = @"The greatest tribute";
      }
      playerTextField.keyboardType = UIKeyboardTypeDefault;
      playerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
      playerTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
      playerTextField.textAlignment = UITextAlignmentLeft;
      playerTextField.tag = indexPath.row + tagOffset;
      playerTextField.delegate = self;
      
      [cell addSubview:playerTextField];
      
      [self.teamNameTextFields addObject:playerTextField];
      
      cell.textLabel.text = [NSString stringWithFormat:@"Name %d", indexPath.row + 1];
    }
  }
  else if (indexPath.section == 2) {
    cell = cellGeneralSetting;
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellGeneralSetting] autorelease];

      cell.accessoryType = UITableViewCellAccessoryNone;
      cell.textLabel.text = @"Hi, lots.";
      cell.detailTextLabel.text = @"and lots...";
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
      [cell bringSubviewToFront:doneButton];
    }
  }


  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  // if it's row 0 section 0 show the team size page.
//  [self.gameController openWithGame:[self gameForIndexPath:indexPath]];
//  [self.navigationController pushViewController:self.gameController animated:YES];
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
  BOOL canEdit = YES;
  
  return canEdit;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
  return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
}


@end
