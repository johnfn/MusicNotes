//
//  NotePlayer.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/16/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "NotePlayer.h"
#import "ToneGeneratorViewController.h"

@interface NotePlayer()
@property NSMutableDictionary* frequenciesToNotes;
@end

@implementation NotePlayer

+ (NSMutableDictionary*)frequencyToNoteDictionary {
    static NSMutableDictionary* freqDict;
    
    if (!freqDict) {
        freqDict = [[NSMutableDictionary alloc] init];
    }
    
    return freqDict;
}

+ (void)playFrequency:(double)frequency {
    NSMutableDictionary* dict = [NotePlayer frequencyToNoteDictionary];
    ToneGeneratorViewController* tg = [dict objectForKey:[NSNumber numberWithDouble:frequency]];
    if (!tg) {
        tg = [[ToneGeneratorViewController alloc] init];
        [tg setup:frequency];
        [dict setObject:tg forKey:[NSNumber numberWithDouble:frequency]];
    }
    
    [tg togglePlay];
}

+ (void)stopFrequency:(double)frequency {
    NSMutableDictionary* dict = [NotePlayer frequencyToNoteDictionary];
    ToneGeneratorViewController* tg = [dict objectForKey:[NSNumber numberWithDouble:frequency]];
    [tg stop];
}

+ (double)frequency:(int)semitonesFromC {
    double power = (semitonesFromC + 3)/12.0;
    double result = 220 * pow(2, power);
    
    return result;
}

@end
