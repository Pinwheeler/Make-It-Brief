//
//  EditViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/19/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPopulator.h"
#import "DataManager.h"
#import "ChiroMaticAppDelegate.h"

@interface EditViewController : UIViewController <DataPopulator,UITextFieldDelegate>

@property (weak, nonatomic) id <DataManager> delegate;
@property (weak, nonatomic) id specialReturnValue;

- (void) populate:(id)text withObjectDataItem:(id)item assumingDataIsNonNil:(BOOL) assumption;
- (void) populateFieldsWithDataOfObject:(id)object;
- (void) textFieldDidEndEditing:(UITextField *)textField;
- (void) saveData;
- (void) viewWillDisappear:(BOOL)animated;
- (void) clearTextfieldsAssociatedWithEntityType:(Class)type;

@end
