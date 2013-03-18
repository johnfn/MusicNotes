//
//  Song+Extension.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "Song.h"
#import "Sequence.h"

@interface Song (Extension)

+ (NSArray*)allSongsWithName:(UIManagedDocument*)document name:(NSString*)name;
+ (void)saveSequence:(UIManagedDocument*)document seq:(Sequence*)sequence;
+ (NSArray*)allSongs:(UIManagedDocument*)document;

- (NSMutableArray*)toNoteData;

@end
