//
//  LoadViewController.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "Settings.h"
#import "LoadViewController.h"
#import "Song+Extension.h"
#import "DocumentManager.h"
#import "SequencerViewController.h"

@interface LoadViewController ()
@property (strong, nonatomic) NSArray* songs;
@end

@implementation LoadViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)finishedLoading {
    //[[self activityIndicator] stopAnimating];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [DocumentManager withDocumentDo:^(UIManagedDocument* document){
        _songs = [Song allSongs:document];
        [self performSelectorOnMainThread:@selector(finishedLoading)
                               withObject:NULL
                            waitUntilDone:YES];
    }];
}

- (void)viewDidLoad
{
    _songs = [[NSArray alloc] init];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SaveCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    int index = [indexPath row];
    Song* relevantSong = [self.songs objectAtIndex:index];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:relevantSong.modified];

    cell.textLabel.text = relevantSong.title;
    cell.detailTextLabel.text = dateString;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Preparing!");
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:NO];

    int index = [self.tableView indexPathForSelectedRow].row;
    Song *song = [self.songs objectAtIndex:index];

    [Settings setTitle:song.title];
    [Settings setBPM:[song.bpm intValue]];

    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
