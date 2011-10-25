//
//  CellWrapper.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 09/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CellWrapper : NSObject {
  UITableViewCell* cell;
}

@property (nonatomic, retain) IBOutlet UITableViewCell* cell;

- (BOOL)loadMyNibFile:(NSString*)nibName;

@end
