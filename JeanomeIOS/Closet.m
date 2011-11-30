//
//  Closet.m
//  JeanomeIOS
//
//  Created by David Lam on 11/16/11.
//  Copyright (c) 2011 Home. All rights reserved.
//
//
//  See jeanome/api/views.py:17 closet()
//

#import "Closet.h"

@implementation Closet
    
@synthesize closetInfo;

-(id)initWithJSON:(NSString *)json
{    
    // NSLog(@"Closet.m:20   initWithJSON(): %@", json);
    
    self.closetInfo = [json JSONValue];
    return self;
}

-(NSString *)__defaultWith:(NSString *)aDefault ifThisIsNull:(id)val
{
    if(val == NULL)
        return aDefault;
    else
        return val;
}

-(NSString *)getName
{
    return [self.closetInfo objectForKey:@"name"];
}

-(NSString *)getSquarePhoto
{
    return [self.closetInfo objectForKey:@"square_photo"];
}

-(NSString *)getFollowers
{
//    NSLog(@"Closet.m:46  getFollowers(): %@", [self.closetInfo objectForKey:@"followers"]);
  
    return [self __defaultWith:@"0" ifThisIsNull:[self.closetInfo objectForKey:@"followers"]];
    
//    return [self.closetInfo objectForKey:@"followers"];
}

-(NSString *)getFollowing
{
    return [self __defaultWith:@"0" ifThisIsNull:[self.closetInfo objectForKey:@"following"]];
}

-(NSString *)getStatus
{
    return [self __defaultWith:@"None" ifThisIsNull:[self.closetInfo objectForKey:@"status"]];
}

-(NSDecimalNumber *)getPoints
{
    //NSLog(@"Closet.m:34  getPoints(): %@", [self.closetInfo objectForKey:@"points"]);
    
    // return [self.closetInfo objectForKey:@"points"];
    
    //  if "points" is a string...
    //return [NSDecimalNumber decimalNumberWithString:[self __defaultWith:@"0" ifThisIsNull:[self.closetInfo objectForKey:@"points"]]];

    NSDecimalNumber *points = [self.closetInfo objectForKey:@"points"];    
    if(points == NULL)
        return 0;
    else
        return points;
}

-(NSDecimalNumber *)getItemCount
{
    NSDecimalNumber *itemCount = [self.closetInfo objectForKey:@"itemcount"];
    if(itemCount == NULL)
        return 0;
    else
        return itemCount;
}

-(NSDictionary *)getItems
{
    NSDictionary *items = [self.closetInfo objectForKey:@"items"];
    
    if(items == NULL)    
        return [NSDictionary dictionary];
    else
        return items;
}

/*
    Similar to getItems, but returns an array of ClosetItem objects so that 
    PictureTablewViewCell can load cached images in ClosetItem's image property
 */ 
-(NSArray *)getClosetItems
{
    NSDictionary *items = [self getItems];
    NSArray *itemIds = [items allKeys];
    
    NSMutableArray *closetItems = [[NSMutableArray alloc] init];

    for(NSString* itemId in itemIds) {
        NSDictionary *imageDict = [items objectForKey:itemId];
        ClosetItem *closetItem = [[ClosetItem alloc] initWithImageDict:imageDict andId:itemId];
        [closetItems addObject:closetItem];
        [closetItem release];
    }
    
    return [NSArray arrayWithArray:closetItems];
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Closet.m:108   cellForRowAtIndexPath()");
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Pic #%u", indexPath.row];
    
    return cell;
}


@end
