#import "GameTournamentViewController.h"

@implementation GameTournamentViewController

// MARK: synthesize
@synthesize table;
@synthesize setting;
@synthesize tournamentOptions;

- (void) dealloc {
  [table release];
  [setting release];
  [tournamentOptions release];

  [super dealloc];
}


- (void) initWithSetting:(Setting*)s {
  self.setting = s;
  
  self.tournamentOptions = [NSOrderedSet orderedSetWithObjects:
                            [NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],
                            [NSNumber numberWithInt:2],
                            [NSNumber numberWithInt:3],
                            [NSNumber numberWithInt:4],
                            [NSNumber numberWithInt:5],
                            [NSNumber numberWithInt:6],
                            [NSNumber numberWithInt:7],
                            [NSNumber numberWithInt:8],
                            [NSNumber numberWithInt:9],
                            [NSNumber numberWithInt:10],
                            [NSNumber numberWithInt:15],
                            [NSNumber numberWithInt:20],
                            nil];
}


// MARK: view
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"# Rounds";
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {
	return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {  
  return nil;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.tournamentOptions count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellTournament = @"CellTournament";
  
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellTournament];
  
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTournament] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }

  cell.textLabel.text = [self.setting textForTournament:[[self.tournamentOptions objectAtIndex:indexPath.row] intValue]];
  
  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  self.setting.tournament = [self.tournamentOptions objectAtIndex:indexPath.row];

  [self.navigationController popViewControllerAnimated:YES];
}

@end
