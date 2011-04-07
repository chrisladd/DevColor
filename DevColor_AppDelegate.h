//
//  DevColor_AppDelegate.h
//  DevColor
//
//  Created by Christopher Ladd on 1/25/11.
//  Copyright WalkSoft 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DevColor_AppDelegate : NSObject 
{
    NSWindow *window;
    IBOutlet NSPanel *panel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;

@end
