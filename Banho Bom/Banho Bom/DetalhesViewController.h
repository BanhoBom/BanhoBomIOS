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
@property (strong, nonatomic) IBOutlet UILabel *praiaLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageOpcao;
@property (strong, nonatomic) IBOutlet UILabel *mensLabel;

- (IBAction)tempoButton:(id)sender;
- (IBAction)informacaoButton:(id)sender;
- (IBAction)historicoButton:(id)sender;

@property (nonatomic) double latitude, longitude;
@property (strong, nonatomic) NSString* nomePraia;
@property (strong, nonatomic) NSString* descricaoPraia;
@property (strong, nonatomic) NSString* statusEstacao;
@property (strong, nonatomic) NSString* idEstacao;


@property (strong, nonatomic) NSString* subtitulo; // Nao Precisa

@property(strong, nonatomic) NSMutableArray *descricao;
@property(strong, nonatomic) NSMutableDictionary *dataStored;



@end
