#import <Foundation/Foundation.h>

@interface CellWrapper : NSObject {
  UITableViewCell* cell;
}

@property (nonatomic, retain) IBOutlet UITableViewCell* cell;

- (BOOL)loadMyNibFile:(NSString*)nibName;

@end
