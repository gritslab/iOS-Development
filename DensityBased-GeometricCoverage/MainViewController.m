//
//  MainViewController.m
//  GLParticles1
//
//  Created by GRITS on 3/14/14.
//  Copyright (c) 2014 GRITS. All rights reserved.
//

#import "MainViewController.h"
#import "EmitterTemplate.h"
#import "EmitterShader.h"

#import "communicationProtocol.h"

@interface MainViewController ()

// Properties
@property (strong) EmitterShader* emitterShader;

@end

@implementation MainViewController

GLKMatrix4 projectionMatrix;
float t = 0;
CommunicationProtocol communicator;


- (void)viewDidLoad
{
    //This is where everything starts.
    [super viewDidLoad];
    
    // Set up context
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    // Set up view
    GLKView* view = (GLKView*)self.view;
    view.context = context;
    
    // Enable OpenGL blending
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE);
    
    // Establish UDP Connection
    communicator.UDPConnect();
    
    // Create Projection Matrix
    float aspectRatio = view.frame.size.height / view.frame.size.width;
    projectionMatrix = GLKMatrix4MakeScale(1.0f, aspectRatio, 1.0f);
    
    // Load Particle System
    [self loadShader];
    [self loadParticles];
    [self loadEmitter];
}

- (void) touchHandler:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray *allTouches = [touches allObjects];
    int numTouches = (int)[allTouches count];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
//    NSLog(@"In touchesBegan numTouches: %d", numTouches);
    
    struct GaussianParameters gaussianParameters;
//    gaussianParameters.meanX =
//    gaussianParameters.meanY =
    gaussianParameters.correlation = emitter.uCorrelation;
    gaussianParameters.stdX = emitter.uStdX;
    gaussianParameters.stdY = emitter.uStdY;
    
    struct Density density[PACKET_LENGTH];

    
//    NSLog(@"Sending parameters: %f\n%f\n%f\n", gaussianParameters.correlation, gaussianParameters.stdX, gaussianParameters.stdY);
    

    for (int i = 0; i < numTouches; i++) {
        density[i].type = DensityTypeGaussian;
        density[i].parameters.gaussianParameters = gaussianParameters;
        UITouch *touch = allTouches[i];
        CGPoint touchLocation = [touch locationInView:[self view]];
        CGPoint touchLocationGLScale;
        touchLocationGLScale.x = touchLocation.x/IPAD_X_RESOLUTION*2 - 1;
        touchLocationGLScale.y = -(touchLocation.y/IPAD_Y_RESOLUTION*2 - 1);
        
        density[i].parameters.gaussianParameters.meanX = -touchLocationGLScale.x;
        density[i].parameters.gaussianParameters.meanY = -touchLocationGLScale.y;
        
        
        
        [self drawSomething: touchLocationGLScale];
    }
//    density.type = DensityTypeEnd;
//    communicator.sendDensity(density); //marks the end of this round of densities
    communicator.sendDensity(density);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

//    NSArray *allTouches = [touches allObjects];
//    UITouch *touch = allTouches[0];
    
//    NSLog(@"In touchesBegan function: phase %d", touch.phase);
    
    [self touchHandler:touches withEvent:event];

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSArray *allTouches = [touches allObjects];
    UITouch *touch = allTouches[0];
    int numTouches = (int)[allTouches count];
    
    NSLog(@"In touchesMoved function: phase %d", touch.phase);
    NSLog(@"In touchesMoved numTouches: %d", numTouches);
    
    [self touchHandler:touches withEvent:event];

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
 //   NSArray *allTouches = [touches allObjects];
//    UITouch *touch = allTouches[0];
    
 //   NSLog(@"In touchesCancelled function: phase %d", touch.phase);
    
    [self touchHandler:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSArray *allTouches = [touches allObjects];
//    UITouch *touch = allTouches[0];
//    NSLog(@"In touchesEnded function: phase %d", touch.phase);
    
//    [self touchHandler:touches withEvent:event];
}

- (void)drawSomething: (CGPoint)touchLocationGLScale
{
    
    // 2
    // Uniforms
    glUniformMatrix4fv(self.emitterShader.uProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniform1f(self.emitterShader.uX, touchLocationGLScale.x);
    glUniform1f(self.emitterShader.uY, touchLocationGLScale.y);
    glUniform1f(self.emitterShader.uCorrelation, emitter.uCorrelation);
    glUniform1f(self.emitterShader.uStdX, emitter.uStdX);
    glUniform1f(self.emitterShader.uStdY, emitter.uStdY);
    
    // 3
    // Attributes
    glEnableVertexAttribArray(self.emitterShader.aX);
    glVertexAttribPointer(self.emitterShader.aX,1,GL_FLOAT,GL_FALSE, sizeof(Particle),(void*)(offsetof(Particle, x)));
    
    glEnableVertexAttribArray(self.emitterShader.aY);
    glVertexAttribPointer(self.emitterShader.aY,1,GL_FLOAT,GL_FALSE, sizeof(Particle),(void*)(offsetof(Particle, y)));
    
    // 4
    // Draw particles
    glDrawArrays(GL_POINTS, 0, NUM_PARTICLES);
    glDisableVertexAttribArray(self.emitterShader.aX);
    glDisableVertexAttribArray(self.emitterShader.aY);
}

#pragma mark - GLKViewDelegate

/*
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Set the background color (green)
    glClearColor(0.20f, 0.0f, 0.20f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 1
    // Create Projection Matrix
    float aspectRatio = view.frame.size.height / view.frame.size.width;
    projectionMatrix = GLKMatrix4MakeScale(1.0f, aspectRatio, 1.0f);
    t += 0.1;
    // 2
    // Uniforms
    glUniformMatrix4fv(self.emitterShader.uProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniform1f(self.emitterShader.uX, emitter.uX);
    glUniform1f(self.emitterShader.uY, emitter.uY);
    glUniform1f(self.emitterShader.uCorrelation, emitter.uCorrelation);
    glUniform1f(self.emitterShader.uStdX, emitter.uStdX);
    glUniform1f(self.emitterShader.uStdY, emitter.uStdY);
    
    // 3
    // Attributes
    glEnableVertexAttribArray(self.emitterShader.aX);
    glVertexAttribPointer(self.emitterShader.aX,1,GL_FLOAT,GL_FALSE, sizeof(Particle),(void*)(offsetof(Particle, x)));
    
    glEnableVertexAttribArray(self.emitterShader.aY);
    glVertexAttribPointer(self.emitterShader.aY,1,GL_FLOAT,GL_FALSE, sizeof(Particle),(void*)(offsetof(Particle, y)));
    
    // 4
    // Draw particles
    glDrawArrays(GL_POINTS, 0, NUM_PARTICLES);
    glDisableVertexAttribArray(self.emitterShader.aX);
    glDisableVertexAttribArray(self.emitterShader.aY);
}
 */

- (void)loadParticles
{
    /*
    for(int i=0; i<NUM_PARTICLES; i++)
    {
        // Assign each particle its theta value (in radians)
        emitter.particles[i].x = -(2./NUM_PARTICLES*i - 1);
        emitter.particles[i].y = 2./NUM_PARTICLES*i - 1;
    }
    */
    for(int hor=0; hor<NUM_HORIZONTAL; hor++){
        for(int ver=0; ver<NUM_VERTICAL; ver++){
            emitter.particles[hor*NUM_VERTICAL+ver].x = 2./NUM_HORIZONTAL*hor - 1;
            emitter.particles[hor*NUM_VERTICAL+ver].y = 2./NUM_VERTICAL*ver - 1;
//            NSLog(@"(%f,%f)\n", emitter.particles[hor*NUM_VERTICAL+ver].x, emitter.particles[hor*NUM_VERTICAL+ver].y);
        }
    }
    
    // Create Vertex Buffer Object (VBO)
    GLuint particleBuffer = 0;
    glGenBuffers(1, &particleBuffer);                   // Generate particle buffer
    glBindBuffer(GL_ARRAY_BUFFER, particleBuffer);      // Bind particle buffer
    glBufferData(                                       // Fill bound buffer with particles
                 GL_ARRAY_BUFFER,                       // Buffer target
                 sizeof(emitter.particles),             // Buffer data size
                 emitter.particles,                     // Buffer data pointer
                 GL_STATIC_DRAW);                       // Usage - Data never changes; used for drawing
}

- (void)loadEmitter
{
    emitter.uX = 0.;
    emitter.uY = 0.;
    emitter.uCorrelation = 0.0;
    emitter.uStdX = 0.25;
    emitter.uStdY = 0.25;
}

#pragma mark - Load Shader

- (void)loadShader
{
    self.emitterShader = [[EmitterShader alloc] init];
    [self.emitterShader loadShader];
    glUseProgram(self.emitterShader.program);
}

@end
