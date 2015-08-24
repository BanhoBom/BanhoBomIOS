//
//  EstatisticaViewController.m
//  Banho Bom
//
//  Created by Everson Trindade on 8/22/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import "EstatisticaViewController.h"

@interface EstatisticaViewController ()

@end

@implementation EstatisticaViewController

@synthesize historico, dataStored, title, tempNome2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    historico = [[NSMutableArray alloc] init];
    dataStored = [[NSMutableDictionary alloc] init];
    
    NSString *tempNome = [NSString stringWithFormat:@" %@", title];
    NSArray *parts = [tempNome componentsSeparatedByString:@" "];
    tempNome2 = [NSString stringWithFormat:@"%@",[parts objectAtIndex:1]];
    
    [self carregarJson];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *coletas = [self.historico objectAtIndex:indexPath.row];
    //NSString *codEstacao = [coletas valueForKey:@"cod"];
    
    //if (codEstacao == tempNome2) {

    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    //NSString *temp = [coletas valueForKey:@"cod"];

    [cell.textLabel setText:title];
    [cell.detailTextLabel setText:[coletas valueForKey:@"dat"]];
    NSString *comp = [coletas valueForKey: @"sta"];
        
    if ([comp isEqualToString:@"1"]) {
        UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [accessoryView setImage:[UIImage imageNamed:@"positive.jpg"]];
        [cell setAccessoryView:accessoryView];
            //cell.imageView.image = [UIImage imageNamed:@"positive.jpg"];
    }else{
        UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [accessoryView setImage:[UIImage imageNamed:@"negative.jpg"]];
        [cell setAccessoryView:accessoryView];
        //cell.imageView.image = [UIImage imageNamed:@"negative.jpg"];
    }
    
    
    
    return cell;

    //cell.textLabel.text = [NSString stringWithFormat:@"%@",];
    //NSLog(@"--------");
    //cell.imageView.image = [UIImage imageNamed:@"estatistica.png"];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historico.count;
}

-(void)carregarJson{
    // Prepare the link that is going to be used on the GET request
    NSURL * url = [[NSURL alloc] initWithString:@"http://env-4818724.jelasticlw.com.br/bb-producao/rest/cliente/coletasMobile"];
    
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
        
        NSString *codEstacao = [NSString stringWithFormat:@"%@", [object[i] objectForKey:@"codigoEstacao"], nil];
        //NSLog(@"Codigo Estacao>: %@", codEstacao);
        
        NSString *data = [NSString stringWithFormat:@"%@", [object[i] objectForKey:@"data"], nil];
        //NSLog(@"Data Coleta: %@", data);
        
        NSString *status = [NSString stringWithFormat:@"%@", [object[i] objectForKey:@"status"], nil];
        //NSLog(@"Status: %@", status);
        
        if ([codEstacao isEqual:tempNome2]) {
            [dataStored setObject:codEstacao forKey:@"cod"];
            [dataStored setObject:data forKey:@"dat"];
            [dataStored setObject:status forKey:@"sta"];
            
            [historico addObject:[dataStored copy]];
        }
        
    }
    //turn off the network indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}



@end
