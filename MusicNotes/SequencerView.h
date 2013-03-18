//
//  SequencerView.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SequencerView : UIScrollView
@property (nonatomic) bool rewinding;

- (void)receiveTap:(CGPoint)location;
- (void)loadData:(NSMutableArray*)data;

- (bool)playing;

- (void)rewind:(int)dir;
- (void)finishRewinding;
- (void)play;
- (void)reset;
- (void)save;
- (void)clear;
@end
