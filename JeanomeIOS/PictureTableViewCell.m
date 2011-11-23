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

@synthesize tableViewInsideCell, data;

- (void)dealloc {
    [data release];
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
    return 4;
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
    
    // Configure the cell...
//    cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bluebluehappyface" ofType:@"png"]];
    
    // cell.textLabel.text = @"^_^";
    
    
    UIImage *closetItemImage = [UIImage imageNamed:@"babybluehappyface"];

    NSLog(@"PictureTableViewCell.m:64  closetItemImage size: %@", NSStringFromCGSize(closetItemImage.size));
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:closetItemImage];
    iv.image = closetItemImage;
    
    // picture will be on its side, so rotate it up
    iv.transform = CGAffineTransformMakeRotation(degreesToRadians(90));   
        
    [cell.contentView addSubview:iv];
    
    [iv release];
    
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


@end
