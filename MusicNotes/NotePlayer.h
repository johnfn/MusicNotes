//
//  NotePlayer.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/16/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotePlayer : NSObject
+ (void)playFrequency:(double)frequency;
+ (void)stopFrequency:(double)frequency;
+ (double)frequency:(int)semitonesFromC;
+ (int)semitonesFromC:(double)frequency;
@end
