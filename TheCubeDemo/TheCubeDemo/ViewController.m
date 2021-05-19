//
//  ViewController.m
//  TheCubeDemo
//
//  Created by KONG on 2021/3/18.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController () <SCNSceneRendererDelegate>

@property (nonatomic, strong) SCNScene *scene;
@property (nonatomic, strong) SCNView *sceneView;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSTimeInterval interVal;

@property (nonatomic, strong) NSMutableArray *geometriesArr;
@property (nonatomic, strong)NSArray *colorArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpScene];
    [self setUpSceneView];
    [self setUpLight];
    [self setUpCamera];
    
}

#pragma mark -
#pragma mark --- * Some * ---
- (void)spawnGeometries{
    
    SCNGeometry *geometry = self.geometriesArr[arc4random_uniform((int)self.geometriesArr.count)];
    geometry.firstMaterial.diffuse.contents = self.colorArr[arc4random_uniform((int)self.colorArr.count)];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:nil];
    [self.scene.rootNode addChildNode:node];
    
    // 参数一：推力方向 参数二：推力翻滚效果 参数三：是否推力
    CGFloat x_dis = ((int)(arc4random() % 50) - 30) / 10;
    
    [node.physicsBody applyForce:SCNVector3Make(x_dis, 15, x_dis) atPosition:SCNVector3Make(0.1, 0.1, 0.1) impulse:YES];
}

- (void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time{
    if (time - self.lastTime >= self.interVal) {
        [self spawnGeometries];
        self.lastTime = time;
        [self cleanUp];
    }
}

#pragma mark -
#pragma mark --- * Single * ---
// 添加场景
- (void)setUpScene{
    self.scene = [SCNScene scene];
    self.scene.background.contents = [UIColor colorWithRed:255/255.0 green:182/255.0 blue:183/255.0 alpha:0.7];
    self.interVal = 0.4;
}
// 添加场景view
- (void)setUpSceneView{
    self.sceneView = [[SCNView alloc] initWithFrame:self.view.bounds];
    self.sceneView.scene = self.scene;
    self.sceneView.delegate = self;
    self.sceneView.showsStatistics = YES;
//    self.sceneView.allowsCameraControl = YES;
    [self.view addSubview:self.sceneView];
}

// 添加光源
- (void)setUpLight{
    SCNNode *lightNode = [[SCNNode alloc] init];
    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeOmni;
    light.color = [UIColor whiteColor];
    light.intensity = 1800;
//    light.castsShadow = true;
    lightNode.light = light;
    lightNode.position = SCNVector3Make(10, 10, 10);
    [self.scene.rootNode addChildNode:lightNode];
}

// 添加视角
- (void)setUpCamera{
    //添加视角
    SCNNode *cameraNode = [SCNNode node];
    SCNCamera *camera = [SCNCamera camera];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 5, 10);
    [self.scene.rootNode addChildNode:cameraNode];
}

- (void)cleanUp{
    for (SCNNode *node in self.scene.rootNode.childNodes) {
        if (node.presentationNode.position.y <= -15) {
            [node removeFromParentNode];
        }
    }
}

#pragma mark -
#pragma mark --- * Lazy * ---
- (NSArray *)colorArr{
    if (!_colorArr) {
        _colorArr = [NSArray arrayWithObjects:
                     [UIColor systemRedColor],
                     [UIColor systemBlueColor],
                     [UIColor systemPurpleColor],
                     [UIColor systemPinkColor],
                     [UIColor systemGreenColor],
                     [UIColor systemOrangeColor],
                     [UIColor systemYellowColor],nil];
    }
    return _colorArr;
}

- (NSMutableArray *)geometriesArr{
    if (!_geometriesArr) {
        
        _geometriesArr = [NSMutableArray array];
        // 球
        SCNSphere *ball1 = [SCNSphere sphereWithRadius:0.5];
        SCNSphere *ball2 = [SCNSphere sphereWithRadius:0.8];
        // 正方体
        SCNBox *box1 = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0];
        // 长方体
        SCNBox *box2 = [SCNBox boxWithWidth:0.5 height:1 length:0.5 chamferRadius:0];
        // 圆锥
        SCNCone *cone1 = [SCNCone coneWithTopRadius:0.3 bottomRadius:0.7 height:1.2];
        SCNCone *cone2 = [SCNCone coneWithTopRadius:0.6 bottomRadius:0.8 height:0.9];
        // 金字塔
        SCNPyramid *pyramid1 = [SCNPyramid pyramidWithWidth:1 height:1.2 length:0.7];
        SCNPyramid *pyramid2 = [SCNPyramid pyramidWithWidth:0.6 height:1.2 length:1];
        // 圆柱体
        SCNCylinder *cylinder = [SCNCylinder cylinderWithRadius:0.6 height:1];
        // 药丸
        SCNCapsule *capsule = [SCNCapsule capsuleWithCapRadius:0.2 height:1.1];
        // 管子
        SCNTube *tube1 = [SCNTube tubeWithInnerRadius:0.3 outerRadius:0.6 height:1];
        SCNTube *tube2 = [SCNTube tubeWithInnerRadius:0.5 outerRadius:1 height:1.3];
        // 面包圈
        SCNTorus *torus = [SCNTorus torusWithRingRadius:0.6 pipeRadius:0.2];
        
        [_geometriesArr addObjectsFromArray:@[ball1, ball2, box1, box2, cone1, cone2, pyramid1, pyramid2, cylinder, capsule, tube1, tube2, torus]];
    }
    return _geometriesArr;
}

@end
