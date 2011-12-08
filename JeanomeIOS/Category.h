//
//  Category.h
//  JeanomeIOS
//
//  Created by david lam on 12/7/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject <UITableViewDataSource, UITableViewDelegate> {
    
    NSIndexPath *selectedIndexPath;    
    NSString *selectedCategory;
}

@property(nonatomic, retain) NSString *selectedCategory;

@end
