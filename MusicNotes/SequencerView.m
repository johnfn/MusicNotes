//
//  SequencerView.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "SequencerView.h"

@implementation SequencerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    int notesWide = 10;
    int notesHigh = 13;
    
    CGFloat noteWidth = width / notesWide;
    CGFloat noteHeight = height / notesHigh;
    
    for (int i = 0; i < width; i += noteWidth) {
        for (int j = 0; j < height; j += noteHeight) {
            CGRect dest = CGRectMake(i, j, noteWidth, noteHeight);
            
            [self drawNote:rect dest:dest];
        }
    }
}

- (void)drawNote:(CGRect)rect dest:(CGRect)dest {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextAddRect(context, dest);
    CGContextStrokePath(context);
    CGContextFillPath(context);
}

@end
