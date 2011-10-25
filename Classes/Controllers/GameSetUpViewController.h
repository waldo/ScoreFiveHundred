//
//  GameSetUpViewController.h
//
//  Created by Ben Walsham on 2011-10-24.
//  Copyright 2011 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class ScoreFiveHundredAppDelegate;

@interface GameSetUpViewController : UIViewController {
  IBOutlet UITableView* roundsTableView;
  IBOutlet UIBarButtonItem* editButton;
  IBOutlet UITextField* teamOneName;
  IBOutlet UITextField* teamTwoName;
  IBOutlet UIButton* teamOneBid;
  IBOutlet UIButton* teamTwoBid;
  IBOutlet UIButton* congratulations;
  IBOutlet UILabel* dividerBottom;
  IBOutlet UILabel* dividerTop;
  
  NSMutableDictionary* game;
  NSString* gameKey;
  NSMutableArray* rounds;
  NSNumber* slotTeamOne;
  NSNumber* slotTeamTwo;
  NSString* curNameTeamOne;
  NSString* curNameTeamTwo;
  NSNumber* winningSlot;
  NSDate* lastPlayed;
  BOOL newGame;
  BOOL newRound;
}

@property (nonatomic, retain) IBOutlet UITableView* roundsTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* editButton;
@property (nonatomic, retain) IBOutlet UITextField* teamOneName;
@property (nonatomic, retain) IBOutlet UITextField* teamTwoName;
@property (nonatomic, retain) IBOutlet UIButton* teamOneBid;
@property (nonatomic, retain) IBOutlet UIButton* teamTwoBid;
@property (nonatomic, retain) IBOutlet UIButton* congratulations;
@property (nonatomic, retain) IBOutlet UILabel* dividerBottom;
@property (nonatomic, retain) IBOutlet UILabel* dividerTop;

@property (nonatomic, retain) NSMutableDictionary* game;
@property (nonatomic, retain) NSString* gameKey;
@property (nonatomic, retain) NSMutableArray* rounds;
@property (nonatomic, retain) NSNumber* slotTeamOne;
@property (nonatomic, retain) NSNumber* slotTeamTwo;
@property (nonatomic, retain) NSString* curNameTeamOne;
@property (nonatomic, retain) NSString* curNameTeamTwo;
@property (nonatomic, retain) NSNumber* winningSlot;
@property (nonatomic, retain) NSDate* lastPlayed;
@property (nonatomic, getter=isNewGame) BOOL newGame;
@property (nonatomic, getter=isNewRound) BOOL newRound;


- (IBAction) edit:(id)sender;
- (IBAction) bid:(id)sender;
- (IBAction) rematch:(id)sender;

- (void) openGame:(NSDictionary*)gameToOpen key:(NSString*)key isNewGame:(BOOL)isNewGame;
- (void) rematchOfGame:(NSDictionary*)gameForRematch newKey:(NSString*)newKey;
- (void) updateRoundWithTeam:(NSString*)team hand:(NSString*)hand tricksWon:(NSNumber*)tricksWon;
- (NSInteger) scoreForSlot:(NSInteger)slot;

@end