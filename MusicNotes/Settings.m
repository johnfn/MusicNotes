//
//  Settings.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "Settings.h"

@interface Settings()
@property (nonatomic) int BPM;
@property (nonatomic, strong) NSString* title;
@end

@implementation Settings

+ (Settings*)getSingleton {
    static Settings* settingsSingleton;

    if (!settingsSingleton) {
        settingsSingleton = [[Settings alloc] init];
        settingsSingleton.BPM = 120;
        settingsSingleton.title = @"New Song";
    }

    return settingsSingleton;
}

+ (int)getBPM {
    return [Settings getSingleton].BPM;
}

+ (void)setBPM:(int)newValue {
    [Settings getSingleton].BPM = newValue;
}

+ (NSString*)getTitle {
    return [Settings getSingleton].title;
}

+ (void)setTitle:(NSString *)title {
    [Settings getSingleton].title = title;
}

@end
