//
//  Category.m
//  JeanomeIOS
//
//  Created by david lam on 12/7/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "Category.h"

#define ALL_CATEGORIES [NSArray arrayWithObjects: @"Shoes", @"Bags", @"Makeup", @"Jeans", @"Dresses", @"Tops", @"Skirts", @"Bottoms", @"Gadgets", nil]


@implementation Category

@synthesize selectedCategory;

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [ALL_CATEGORIES objectAtIndex:indexPath.row];
    
    if(indexPath.row > 2) {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@"  (coming soon)"];
        [cell setUserInteractionEnabled:NO];
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ALL_CATEGORIES count];
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedCategory = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    // see ClosetItemDetailsViewController.m:827
    [NSThread sleepForTimeInterval:0.5]; // slight pause, so modal view dosent suddenly dissappear    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CATEGORY_SELECTED object:self];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // XXX  12/8/2011  This works to select the default cell, but selecting a row after 
    //                 will cause two rows to be selected.  However, any selection after
    //                 that will revert behavior to normal.
    
    /*
    if(selectedCategory == cell.textLabel.text)
        cell.selected = YES;
    else 
        cell.selected = NO;
     */
}


@end
