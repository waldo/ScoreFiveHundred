#import <UIKit/UIKit.h>
#import "GameListViewController.h"

@interface ScoreFiveHundredAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic) IBOutlet UIWindow *window;
@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (readonly) NSManagedObjectModel *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end
