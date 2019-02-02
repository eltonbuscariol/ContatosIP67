//
//  Contato.h
//  ContatosIP67
//
//  Created by ios8043 on 05/01/19.
//  Copyright © 2019 Caelum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface Contato : NSManagedObject <MKAnnotation>

@property (strong) NSString *nome;
@property (strong) NSString *telefone;
@property (strong) NSString *endereco;
@property (strong) NSString *site;
@property (strong) UIImage *foto;
@property (strong) NSNumber *latitude;
@property (strong) NSNumber *longitude;

@end
