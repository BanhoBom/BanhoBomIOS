//
//  Database.h
//  Banho Bom
//
//  Created by Everson Trindade on 8/18/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Database : UIViewController

@property (nonatomic) sqlite3 *myDatabase;
@property (strong, nonatomic) NSString *statusOfAddingToDB;
@property (strong, nonatomic) NSString *databasePath;
- (void) createDataBase;
- (void) saveData:(NSString*)nome addLat:(NSString*)latitude addLong:(NSString*)longitude addBaln:(NSString*)balneabilidade addCodPraia:(NSString*)codPraia;
//- (void) deleteData;
-(NSMutableArray*) findData;

@end
