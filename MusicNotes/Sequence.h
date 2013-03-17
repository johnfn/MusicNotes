//
//  Sequence.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sequence : NSObject
@property (nonatomic) int numColumns;

- (UIColor*)getNoteColor:(int)x y:(int)y;
- (void)clickOnNote:(int)x y:(int)y;
- (void)turnOnNote:(int)x y:(int)y;
@end
