//
//  ViewController.swift
//  ARDrawing
//
//  Created by Houssam on 2/10/21.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var drawButton: UIButton!

    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        print("rendering")
        guard let pointView = sceneView.pointOfView else {return}
        let transform = pointView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33) // m31 = ( row3 column1 )
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        
        let currentPositionOfCamera = orientation + location
        
        DispatchQueue.main.async {
            if(self.drawButton.isHighlighted) {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }else{
                // let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                // pointer.position = currentPositionOfCamera
                
            }
        }
        
        
    }
    
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.y, left.y + right.y, left.z + right.z)
}

