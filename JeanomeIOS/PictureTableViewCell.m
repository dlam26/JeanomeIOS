//
//  PictureTableViewCell.m
//  JeanomeIOS
//
//  Created by david lam on 11/22/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "PictureTableViewCell.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@implementation PictureTableViewCell

@synthesize tableViewInsideCell, items, itemcount;

- (void)dealloc {
    [items release];
    [tableViewInsideCell release];
    [super dealloc];
}


#pragma mark - Table view data source

/* 
    This should always be one.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

/*
    TODO  Return the number of photos in this category.
 */ 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [itemcount integerValue];
}

/*
    Get the photo from Jeanome and put it in the cell!
 */ 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

//    NSLog(@"PictureTableViewCell.m:52   cellForRowAtIndexPath()  %u", indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // 11/25/2011  This is weird but without this the cell frame isn't always the same size!
    //             Default view width is 320.  Default height is 1100.  106.66 is 320 / 3.0!
    // 
    
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 106.666, 106.66);
    
    UIImage *closetItemImage;
    
    // Original - just show blue happy faces :D 
    //closetItemImage = [UIImage imageNamed:@"babybluehappyface"];

    // Fetch images from Jeanome/facebook to show
    NSArray *keys = [items allKeys];

    if (indexPath.row < [keys count]) {
        
        NSString *currKey = [keys objectAtIndex:indexPath.row];
        NSDictionary *imageDict = [items objectForKey:currKey];
        
        NSURL *imageURL = [NSURL URLWithString:[imageDict objectForKey:@"image"]];
        
        NSLog(@"PictureTableViewCell.m:70  downloading from imageURL: %@   cell.frame: %@   itemcount: %@", imageURL, NSStringFromCGRect(cell.frame), itemcount); 
        
        closetItemImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        
        // DOSENT WORK
        //  UIImageView *iv = [[UIImageView alloc] initWithFrame:cell.frame]; 
        //iv.image = closetItemImage;        

        UIImageView *iv = [[UIImageView alloc] initWithImage:closetItemImage];
        
        iv.frame = cell.frame;
        
        // picture will be on its side, so rotate it up
        iv.transform = CGAffineTransformMakeRotation(degreesToRadians(90));     
        iv.contentMode = UIViewContentModeScaleToFill;
        
        [cell.contentView addSubview:iv];
        [iv release];
    }

        
    return cell;
}

#pragma mark - Table view delegate


/* 
    This is the 'width' of each photo cell
 
    Total width of screen is 320.  Each photo is 110x110
 
    See ClosetViewController.m:206 in 
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


#pragma mark =

/*
 Loads a UIImageView into cell.
 
 Use threads with this function!
 
 */
- (void) _loadClosetImage:intoCell:(UITableViewCell *)cell
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    [pool release];
}


@end
