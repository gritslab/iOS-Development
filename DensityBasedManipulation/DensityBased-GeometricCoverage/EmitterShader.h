//
//  EmitterShader.h
//  GLParticles1
//
//  Created by GRITS on 3/14/14.
//  Copyright (c) 2014 GRITS. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface EmitterShader : NSObject

// Program Handle
@property (readwrite) GLint program;

// Attribute Handles
@property (readwrite) GLint aX;
@property (readwrite) GLint aY;

// Uniform Handles
@property (readwrite) GLint uProjectionMatrix;

//Uniform Gaussian parameters
@property (readwrite) GLint uX;
@property (readwrite) GLint uY;

@property (readwrite) GLint uCorrelation;

@property (readwrite) GLint uStdX;
@property (readwrite) GLint uStdY;

// Methods
- (void)loadShader;

@end
