#import "CellWrapper.h"

@implementation CellWrapper

@synthesize cell;

- (BOOL)loadMyNibFile:(NSString*)nibName {
  // Must be in same bundle as this class
  if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] == nil) {
    NSLog(@"Error, couldn't load %@ nib file.", nibName);
    return NO;
  }
  return YES;
}

@end
