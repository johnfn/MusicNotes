//
//  Settings.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
+ (int)getBPM;
+ (void)setBPM:(int)newValue;

+ (NSString*)getTitle;
+ (void)setTitle:(NSString*)title;
@end
