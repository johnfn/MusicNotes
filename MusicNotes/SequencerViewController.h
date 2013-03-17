//
//  SequencerViewController.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song+Extension.h"

@interface SequencerViewController : UIViewController
@property (strong, nonatomic) NSMutableArray* noteData;
@property (strong, nonatomic) Song* loadedSong;
@end
