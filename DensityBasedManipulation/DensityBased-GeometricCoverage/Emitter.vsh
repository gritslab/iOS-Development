// Vertex Shader

static const char* EmitterVS = STRINGIFY
(
 
 // Attributes
 attribute float aX;
 attribute float aY;
 
 // Uniforms
 uniform mat4 uProjectionMatrix;
 
 uniform float uX;
 uniform float uY;
 uniform float uCorrelation;
 uniform float uStdX;
 uniform float uStdY;
 
 varying lowp vec4 DestinationColor;
 
 void main(void)
{
//    float x = cos(uK*aTheta)*sin(aTheta);
//    float y = cos(uK*aTheta)*cos(aTheta);
    float intensity = exp(-1./2./(1.-uCorrelation*uCorrelation) *( (aX-uX)*(aX-uX)/uStdX/uStdX + (aY-uY)*(aY-uY)/uStdY/uStdY) - 2.*uCorrelation*(aX-uX)*(aY-uY)/uStdX/uStdY );
/*    float intensity;
    if (((aX-uX)*(aX-uX)/uStdX/uStdX + (aY-uY)*(aY-uY)/uStdY/uStdY) < 1.0){
        intensity = 1.0;
    }
    else{
        intensity = 0.0;
    }
*/
    DestinationColor = vec4(0, intensity, 0, 1.0);
    
    gl_Position = uProjectionMatrix * vec4(aX, aY, 0.0, 1.0);
    gl_PointSize = 8.0;
}
 
 );