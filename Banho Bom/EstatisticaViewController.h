//
//  EstatisticaViewController.h
//  Banho Bom
//
//  Created by Everson Trindade on 8/22/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstatisticaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSMutableArray *historico;
@property(strong, nonatomic) NSMutableDictionary *dataStored;

@property(strong, nonatomic)  NSString *tempNome2;

@end
