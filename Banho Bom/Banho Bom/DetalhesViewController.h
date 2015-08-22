//
//  DetalhesViewController.h
//  Banho Bom
//
//  Created by Everson Trindade on 8/19/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetalhesViewController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D *coordinateMap;

@property (strong, nonatomic) IBOutlet UIImageView *imagePraia;
@property (strong, nonatomic) IBOutlet UILabel *estacaoLabel;
@property (strong, nonatomic) IBOutlet UILabel *praiaLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageOpcao;
@property (strong, nonatomic) IBOutlet UILabel *mensLabel;

- (IBAction)estaticaButton:(id)sender;
- (IBAction)tempoButton:(id)sender;
- (IBAction)informacaoButton:(id)sender;

@property (strong, nonatomic) NSString* subtitulo;

@property (nonatomic) double latitude, longitude;

@end
