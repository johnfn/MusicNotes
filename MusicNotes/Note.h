//
//  Note.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic) int frequency;
@property (nonatomic) bool willPlay;
@property (nonatomic) bool playingNow;
@property (nonatomic) int column;

+ (NSArray*)validPitches;
- (NSString*)description;

@end
