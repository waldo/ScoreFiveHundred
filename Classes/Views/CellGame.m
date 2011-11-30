#import "CellGame.h"

@implementation CellGame

@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize pointsTeamOne;
@synthesize pointsTeamTwo;
@synthesize symbolResultTeamOne;
@synthesize symbolResultTeamTwo;
@synthesize dateLastPlayed;

- (void) dealloc {
  [nameTeamOne release];
  [nameTeamTwo release];
  [pointsTeamOne release];
  [pointsTeamTwo release];
  [symbolResultTeamOne release];
  [symbolResultTeamTwo release];
  [dateLastPlayed release];

  [super dealloc];
}

// MARK: UITableViewCell functions
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
