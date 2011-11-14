//
//  SettingsViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 11/12/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate> {
    
    IBOutlet UITextField *jeanomeURLTextField;
    NSUserDefaults *defaults;
}

-(IBAction)saveSettings:(id)sender;

@end
