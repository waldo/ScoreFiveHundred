#import "GameModeViewController.h"

@interface GameModeViewController()
  - (NSUInteger) indexFromIndexPath:(NSIndexPath*)path;
@end

@implementation GameModeViewController

// MARK: synthesize
@synthesize table,
            setting;

- (void) dealloc {
  [table release];
  [setting release];
  
  [super dealloc];
}

- (void) initWithSetting:(Setting *)s {
  self.setting = s;
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];

  self.title = @"Game Mode";
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [table selectRowAtIndexPath:[self.setting indexPathOfCurrentMode] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
  int sections = 2;

	return sections;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"Select number of teams / players";
  }
  else if (section == 1) {
    return @"French Canadian or Quebec mode - score to 1000 points and instead of the subtracting the bid from the bidding team's score (if they don't reach it) the bid amount is added to the non bidding team's score.";
  }

  return @"";
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  }
  
  return 1;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellGameMode = @"CellGameMode";
  
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellGameMode];

  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellGameMode] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;

    int ix = [self indexFromIndexPath:indexPath];
    
    cell.textLabel.text = [[self.setting.modeOptions objectAtIndex:ix] objectForKey:@"text"];
    cell.detailTextLabel.text = [[self.setting.modeOptions objectAtIndex:ix] objectForKey:@"detail"];
  }

  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  int ix = [self indexFromIndexPath:indexPath];
  self.setting.mode = [[self.setting.modeOptions objectAtIndex:ix] objectForKey:@"text"];
  [self.setting consistentForMode];

  [self.navigationController popViewControllerAnimated:YES];
}

// MARK: hidden
- (NSUInteger) indexFromIndexPath:(NSIndexPath*)path {
  return path.section * 1 + path.row;
}

@end
