//
//  DetalhesViewController.m
//  Banho Bom
//
//  Created by Everson Trindade on 8/19/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import "DetalhesViewController.h"
#import "ClimaViewController.h"
#import "EstatisticaViewController.h"

@interface DetalhesViewController ()

@end

@implementation DetalhesViewController

@synthesize coordinateMap;
@synthesize imagePraia, imageOpcao;
@synthesize praiaLabel, mensLabel;
@synthesize title, subtitulo;
@synthesize latitude, longitude, nomePraia, descricaoPraia, idEstacao, statusEstacao;
@synthesize descricao, dataStored;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    latitude = coordinateMap->latitude;
    longitude= coordinateMap->longitude;
    
    //self.praiaLabel.text = title;
    
    self.praiaLabel.text = title;
    
    descricao = [[NSMutableArray alloc] init];
    dataStored = [[NSMutableDictionary alloc] init];
    
    [self status];
    
    
}

-(void)status{

    if ([subtitulo isEqualToString:@"Praia Própria para Banho"]) {
        self.mensLabel.text = @"Água Boa";
        imageOpcao.image = [UIImage imageNamed:@"positive.jpg"];
    } else {
        self.mensLabel.text = @"Água Não Boa";
        imageOpcao.image = [UIImage imageNamed:@"negative.jpg"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tempoButton:(id)sender {
    CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    ClimaViewController *climaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ClimaViewController"];
    climaVC.coordinateMap = &(coodinate);
    climaVC.title = title;
    
    [self presentViewController:climaVC animated:YES completion:nil];
    
}

- (IBAction)informacaoButton:(id)sender {
    
    // Prepare the link that is going to be used on the GET request
    NSURL * url = [[NSURL alloc] initWithString:@"http://env-4818724.jelasticlw.com.br/banhobom3/rest/cliente/coletasMobile"];
    
    // Prepare the request object
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    
    // Prepare the variables for the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    // Construct a Array around the Data from the response
    NSArray* object = [NSJSONSerialization
                       JSONObjectWithData:urlData
                       options:0
                       error:&error];
    
    
    // Iterate through the object and print desired results
    for (int i=0; i < [object count]; i++) {
        
        NSString *no = [NSString stringWithFormat:@"%@", [object[i] objectForKey:@"nome"], nil];
        NSString *desc = [NSString stringWithFormat:@"%@", [object[i] objectForKey:@"descricao"], nil];
        
        [dataStored setObject:no forKey:@"nome"];
        [dataStored setObject:desc forKey:@"descricao"];
        
        [descricao addObject:[dataStored copy]];
    }
    //turn off the network indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    
    for (NSDictionary *row in descricao) {
        if ([row objectForKey:@"nome"] == nomePraia) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nomePraia
                                                            message:@"Alguma Coisa sobre a Praia"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK!",nil];
            [alert show];
        }
    }
    
}

- (IBAction)historicoButton:(id)sender {
    EstatisticaViewController *estatisticaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EstatisticaViewController"];
    estatisticaViewController.title = title;
    [self presentViewController:estatisticaViewController animated:YES completion:nil];
}
@end
