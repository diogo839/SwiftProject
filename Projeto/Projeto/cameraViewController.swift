//
//  cameraViewController.swift
//  Projeto
//
//  Created by Diogo Pinto on 20/11/2021.
//

import UIKit
import AVFoundation
import RealityKit

class cameraViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate {
    var session = AVCaptureSession()
    var videoPreview: AVCaptureVideoPreviewLayer?
    var arView:ARView! = nil
    var refreshButton:UIButton! = nil
    var stopButton:UIButton! = nil
    var waterButton:UIButton! = nil
    let captureOutput = AVCaptureMetadataOutput()
    var list = [String]()
    let radius =  -90 * Float.pi / 180.0
    let radius2 =  180 * Float.pi / 180.0
    var input:AVCaptureInput!
    
    let view1 = UIView();
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let rect2 = CGRect(x: 10, y: 20, width: 30, height: 30)
         stopButton = UIButton(frame: rect2)
               stopButton.setBackgroundImage(UIImage(named: "arrow back"), for: .normal)
                   //stopButton.addTarget(self, action: #selector(stop), for: .touchUpInside)
        qrScanner()
            view.addSubview(stopButton)
       
  
    }
    
   
    
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
private func qrScanner(){
    guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else{
        print("camera nao encontrada")
        return
    }
    
    do{
      input = try AVCaptureDeviceInput(device: captureDevice)
        
        session.addInput(input)
        
      
        
        session.addOutput(captureOutput)
       
        captureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        videoPreview = AVCaptureVideoPreviewLayer(session: session)
        videoPreview?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreview?.frame = view.layer.bounds
        view1.layer.addSublayer(videoPreview!)
        
        view.addSubview(view1)
        session.startRunning()
    }catch{
       
        return
    }
}
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    
    }
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
       
        if(metadataObjects.count == 0){
            return
        }
        
        let metadataobj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataobj.type == AVMetadataObject.ObjectType.qr {
            if metadataobj.stringValue != nil{
               // showToast(controller: self, message : metadataobj.stringValue ?? "erro", seconds: 2.0)
                
                
                if !list.contains(metadataobj.stringValue!){
                    
                     
                    list.append(metadataobj.stringValue!)
                    
                    print(list)
                       Get(QrText: metadataobj.stringValue!)
                   
                    
                }else{
                    return
                }
                
            }
        }
        
        
        
    }

    
    
    func makeAr(Request:Plant){
      
         arView = ARView(frame:view.frame)
        
        
        
       //titulo do canteiro
        let Title1 = MeshResource.generateText("Nome:", extrusionDepth: 0.01, font: .systemFont(ofSize: 0.09), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
        let Title1Material = SimpleMaterial(color: .black, isMetallic: false)
        let Title1Entity = ModelEntity(mesh: Title1, materials: [Title1Material])
        
       
        Title1Entity.transform.rotation *= simd_quatf(angle: radius , axis: SIMD3(x: 1, y: 0, z: 0))
        let title1Anchor = AnchorEntity(world: SIMD3(x: -0.4, y: -1.4, z: -1.4))
        title1Anchor.addChild(Title1Entity)
        arView.scene.addAnchor(title1Anchor)
        
        
        //nome do canteiro
        let name1 = MeshResource.generateText((Request.Nome ?? "nulo") , extrusionDepth: 0.001, font: UIFont.systemFont(ofSize:0.08), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
        let name1Material = SimpleMaterial(color: .black, isMetallic: false)
        let name1Entity = ModelEntity(mesh: name1, materials: [name1Material])
        
      
        name1Entity.transform.rotation *= simd_quatf(angle: radius , axis: SIMD3(x: 1, y: 0, z: 0))
        let name1Anchor = AnchorEntity(world: SIMD3(x: -0.4, y: -1.4, z: -1.3))
        name1Anchor.addChild(name1Entity)
        arView.scene.addAnchor(name1Anchor)
        
        
        // titulo tipo
        let Title2 = MeshResource.generateText("Tipo:", extrusionDepth: 0.01, font: .systemFont(ofSize: 0.09), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
        let Title2Material = SimpleMaterial(color: .black, isMetallic: false)
        let Title2Entity = ModelEntity(mesh: Title2, materials: [Title2Material])
        
       
        Title2Entity.transform.rotation *= simd_quatf(angle: radius , axis: SIMD3(x: 1, y: 0, z: 0))
        let title2Anchor = AnchorEntity(world: SIMD3(x: -0.4, y: -1.4, z: -1.2))
        title2Anchor.addChild(Title2Entity)
        arView.scene.addAnchor(title2Anchor)
        
        
        //tipo
        let name2 = MeshResource.generateText((Request.Tipo ?? "nulo") ?? "nulo", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.08), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
        let name2Material = SimpleMaterial(color: .black, isMetallic: false)
        let name2Entity = ModelEntity(mesh: name2, materials: [name2Material])
        
      
        name2Entity.transform.rotation *= simd_quatf(angle: radius , axis: SIMD3(x: 1, y: 0, z: 0))
        let name2Anchor = AnchorEntity(world: SIMD3(x: -0.4, y: -1.4, z: -1.1))
        name2Anchor.addChild(name2Entity)
        arView.scene.addAnchor(name2Anchor)
        
        
        
        //measureTitle1
      
        let measuretitle1 = MeshResource.generateText( "Temperatura: \(Request.Temperatura) Temperatura Ideal \(Request.TemperaturaIdeal) ", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.08), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
        let measuretitle1Material = SimpleMaterial(color: .black, isMetallic: false)
        let measuretitle1Entity = ModelEntity(mesh: measuretitle1, materials: [measuretitle1Material])
        
      
        measuretitle1Entity.transform.rotation *= simd_quatf(angle: radius , axis: SIMD3(x: 1, y: 0, z: 0))
        let measuretitle1Anchor = AnchorEntity(world: SIMD3(x: -1, y: -1.4, z: -0.9))
        measuretitle1Anchor.addChild(measuretitle1Entity)
        arView.scene.addAnchor(measuretitle1Anchor)
        
        
        //measure1
        
        let measure0mark = SimpleMaterial(color: .black,roughness: 0, isMetallic: false)
        let Mark0 = MeshResource.generatePlane(width: 0.01 , depth: 0.1, cornerRadius:0.005)
        let measure0Entety = ModelEntity(mesh: Mark0 , materials: [measure0mark])
        
        let measurebar = SimpleMaterial(color: .lightGray,roughness:0, isMetallic: false)
        let measurebarPlane = MeshResource.generatePlane(width: 2 , depth: 0.1, cornerRadius:0.005)
        let measurebarEntety = ModelEntity(mesh: measurebarPlane , materials: [measurebar])
        let measure1Material:SimpleMaterial!
        var temp:Float!
        if(Request.Temperatura<0){
            temp = Request.Temperatura * -1
            measure1Material = SimpleMaterial(color: .red,roughness: 0, isMetallic: false)
        }else{
            temp = Request.Temperatura
             measure1Material = SimpleMaterial(color: .green,roughness: 0, isMetallic: false)
        }
        let measure1 = MeshResource.generatePlane(width: temp/100.0 , depth: 0.1, cornerRadius:0.005)
        let measure1Ideal = MeshResource.generatePlane(width: 0.01 , depth: 0.1, cornerRadius:0.005)
        let measure1IdealMaterial = SimpleMaterial(color: .red,roughness: 0, isMetallic: false)
        let measure1IdealEntety = ModelEntity(mesh: measure1Ideal, materials: [measure1IdealMaterial])
        let measure1IdealAnchor = AnchorEntity(world: SIMD3(x: (Request.TemperaturaIdeal)/100, y: -1.37, z: -0.8))
        
        
        let measure1Anchor0Mark = AnchorEntity(world: SIMD3(x: 0, y: -1.37, z: -0.8))
        let measure1barMark = AnchorEntity(world: SIMD3(x: 0, y: -1.39, z: -0.8))
        let measure1Entity = ModelEntity(mesh: measure1, materials: [measure1Material])
        let measure1Anchor = AnchorEntity(world: SIMD3(x: 0 + (temp)/200.0, y: -1.38, z: -0.8))
        measure1Anchor.addChild(measure1Entity)
        measure1Anchor0Mark.addChild(measure0Entety)
        measure1barMark.addChild(measurebarEntety)
        measure1IdealAnchor.addChild(measure1IdealEntety)
        arView.scene.addAnchor(measure1Anchor)
        arView.scene.addAnchor(measure1Anchor0Mark)
        arView.scene.addAnchor(measure1barMark)
        arView.scene.addAnchor(measure1IdealAnchor)
        
        //measureTitle2
      
        let measuretitle2 = MeshResource.generateText( "humidade: \(Request.Humidade) humidade Ideal: \(Request.HumidadeIdeal) ", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.08), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
        let measuretitle2Material = SimpleMaterial(color: .black, isMetallic: false)
        let measuretitle2Entity = ModelEntity(mesh: measuretitle2, materials: [measuretitle2Material])
        
      
        measuretitle2Entity.transform.rotation *= simd_quatf(angle: radius , axis: SIMD3(x: 1, y: 0, z: 0))
        let measuretitle2Anchor = AnchorEntity(world: SIMD3(x: -1, y: -1.4, z: -0.6))
        measuretitle2Anchor.addChild(measuretitle2Entity)
        arView.scene.addAnchor(measuretitle2Anchor)
        
        
        //measure2
        
        let measure20mark = SimpleMaterial(color: .black,roughness: 0, isMetallic: false)
        let Mark20 = MeshResource.generatePlane(width: 0.01 , depth: 0.1, cornerRadius:0.005)
        let measure20Entety = ModelEntity(mesh: Mark20 , materials: [measure20mark])
        
        let measurebar2 = SimpleMaterial(color: .lightGray,roughness:0, isMetallic: false)
        let measurebar2Plane = MeshResource.generatePlane(width: 2 , depth: 0.1, cornerRadius:0.005)
        let measurebar2Entety = ModelEntity(mesh: measurebar2Plane , materials: [measurebar2])
        
        let measure2Material:SimpleMaterial!
        var humidade:Float!
        
        if(Request.Humidade<0){
            humidade = Request.Humidade * -1
            measure2Material = SimpleMaterial(color: .red,roughness: 0, isMetallic: false)
        }else{
            humidade = Request.Humidade
             measure2Material = SimpleMaterial(color: .green,roughness: 0, isMetallic: false)
        }
        let measure2 = MeshResource.generatePlane(width: humidade/100.0 , depth: 0.1, cornerRadius:0.005)
        let measure2Ideal = MeshResource.generatePlane(width: 0.01 , depth: 0.1, cornerRadius:0.005)
        let measure2IdealMaterial = SimpleMaterial(color: .red,roughness: 0, isMetallic: false)
        let measure2IdealEntety = ModelEntity(mesh: measure2Ideal, materials: [measure2IdealMaterial])
        let measure2Entity = ModelEntity(mesh: measure2, materials: [measure2Material])
        
        
        
        let measure2Anchor0Mark = AnchorEntity(world: SIMD3(x: 0, y: -1.37, z: -0.5))
        let measure2barMark = AnchorEntity(world: SIMD3(x: 0, y: -1.39, z: -0.5))
        let measure2IdealAnchor = AnchorEntity(world: SIMD3(x: (Request.HumidadeIdeal)/100, y: -1.37, z: -0.5))
        let measure2Anchor = AnchorEntity(world: SIMD3(x: 0 + (humidade)/200.0, y: -1.38, z: -0.5))
        measure2Anchor.addChild(measure2Entity)
        measure2Anchor0Mark.addChild(measure20Entety)
        measure2barMark.addChild(measurebar2Entety)
        measure2IdealAnchor.addChild(measure2IdealEntety)
        arView.scene.addAnchor(measure2Anchor)
        arView.scene.addAnchor(measure2Anchor0Mark)
        arView.scene.addAnchor(measure2barMark)
        arView.scene.addAnchor(measure2IdealAnchor)
        
        
        
        //measureTitle3
      
        
        
        let measuretitle3 = MeshResource.generateText( "luminosidade: \(Request.Luminosidade) luminosidade Ideal: \(Request.LuminosidadeIdeal) ", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.08), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
        let measuretitle3Material = SimpleMaterial(color: .black, isMetallic: false)
        let measuretitle3Entity = ModelEntity(mesh: measuretitle3, materials: [measuretitle3Material])
        
      
        measuretitle3Entity.transform.rotation *= simd_quatf(angle: radius , axis: SIMD3(x: 1, y: 0, z: 0))
        let measuretitle3Anchor = AnchorEntity(world: SIMD3(x: -1, y: -1.4, z: -0.3))
        measuretitle3Anchor.addChild(measuretitle3Entity)
        arView.scene.addAnchor(measuretitle3Anchor)
        
        
        //measure3
        let measure30mark = SimpleMaterial(color: .black,roughness: 0, isMetallic: false)
        let Mark30 = MeshResource.generatePlane(width: 0.01 , depth: 0.1, cornerRadius:0.005)
        let measure30Entety = ModelEntity(mesh: Mark30 , materials: [measure30mark])
        
        let measurebar3 = SimpleMaterial(color: .lightGray,roughness:0, isMetallic: false)
        let measurebar3Plane = MeshResource.generatePlane(width: 2 , depth: 0.1, cornerRadius:0.005)
        let measurebar3Entety = ModelEntity(mesh: measurebar3Plane , materials: [measurebar3])
        
        let measure3Material:SimpleMaterial!
        var luminosidade:Float!
        
        if(Request.Luminosidade<0){
            luminosidade = Request.Luminosidade * -1
            measure3Material = SimpleMaterial(color: .red,roughness: 0, isMetallic: false)
        }else{
            luminosidade = Request.Luminosidade
             measure3Material = SimpleMaterial(color: .green,roughness: 0, isMetallic: false)
        }
        let measure3 = MeshResource.generatePlane(width: luminosidade/1000.0 , depth: 0.1, cornerRadius:0.005)
        let measure3Ideal = MeshResource.generatePlane(width: 0.01 , depth: 0.1, cornerRadius:0.005)
        let measure3IdealMaterial = SimpleMaterial(color: .red,roughness: 0, isMetallic: false)
        let measure3IdealEntety = ModelEntity(mesh: measure3Ideal, materials: [measure3IdealMaterial])
        let measure3Entity = ModelEntity(mesh: measure3, materials: [measure3Material])
        
        
        
        let measure3Anchor0Mark = AnchorEntity(world: SIMD3(x: 0, y: -1.37, z: -0.2))
        let measure3barMark = AnchorEntity(world: SIMD3(x: 0, y: -1.39, z: -0.2))
        let measure3IdealAnchor = AnchorEntity(world: SIMD3(x: (Request.LuminosidadeIdeal)/1000, y: -1.37, z: -0.2))
        let measure3Anchor = AnchorEntity(world: SIMD3(x: 0 + (luminosidade)/2000.0, y: -1.38, z: -0.2))
        measure3Anchor.addChild(measure3Entity)
        measure3Anchor0Mark.addChild(measure30Entety)
        measure3barMark.addChild(measurebar3Entety)
        measure3IdealAnchor.addChild(measure3IdealEntety)
        arView.scene.addAnchor(measure3Anchor)
        arView.scene.addAnchor(measure3Anchor0Mark)
        arView.scene.addAnchor(measure3barMark)
        arView.scene.addAnchor(measure3IdealAnchor)
        
        //logo
        var myLogo = SimpleMaterial()
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
               // Download contents of imageURL as Data.  Use a URLSession if you want to do this asynchronously.
        let data = try! Data(contentsOf:URL(string:"http://46.101.236.202/img/logo.c231748f.png")!)
               
               // Write the image Data to the file URL.
               try! data.write(to: fileURL)
               let texture = try! TextureResource.load(contentsOf: fileURL)
        myLogo.baseColor = MaterialColorParameter.texture(texture)
        let myMesh: MeshResource = .generatePlane(width: 0.5, depth: 0.5, cornerRadius: 0.05)
        let component = ModelEntity(mesh: myMesh, materials: [myLogo])
        let imageAnchor = AnchorEntity(world: SIMD3(x: -0.7, y: -1.39, z: -1.25))
        imageAnchor.addChild(component)
        
      
        arView.scene.addAnchor(imageAnchor)
        
        // placa
        let board = MeshResource.generatePlane(width: 2.1, depth: 1.5, cornerRadius:0.1)
        let simpleMaterial = SimpleMaterial(color: .white,roughness: 0, isMetallic: false)
        
        let boardEntity = ModelEntity(mesh: board, materials: [simpleMaterial])
            
        let boardAnchor = AnchorEntity(world: SIMD3(x: 0, y: -1.4, z: -0.8))
        boardAnchor.addChild(boardEntity)
        
      
        arView.scene.addAnchor(boardAnchor)
        let rect2 = CGRect(x: 10, y: 20, width: 30, height: 30)
         stopButton = UIButton(frame: rect2)
               stopButton.setBackgroundImage(UIImage(named: "arrow back"), for: .normal)
        
        let rect = CGRect(x: view.frame.size.width - 50, y: 20, width: 30, height: 30)
         refreshButton = UIButton(frame: rect)
        refreshButton.setBackgroundImage(UIImage(named: "reresh"), for: .normal)
        
        //view.frame.size.width - 56 arrowshape.turn.up.backward.fill
               refreshButton.addTarget(self, action: #selector(stop), for: .touchUpInside)

        let rect3 = CGRect(x: 120, y: view.frame.size.height - 20, width: 30, height: 30)
         waterButton = UIButton(frame: rect3)
               waterButton.setBackgroundImage(UIImage(named: "arrow back"), for: .normal)
        
        
        view.addSubview(arView)
        
        view.addSubview(stopButton)
        view.addSubview(refreshButton)
        view.addSubview(waterButton)
        //view.sendSubviewToBack(arView)
        
       
        
    }
    
    
    
    
    private func Get(QrText:String){
        guard let ConUrl = URL(string: url + "/api/GetSingleBox/"+QrText) else { return}
        
        print(QrText)
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
   
        
        let task = URLSession.shared.dataTask(with: request) { data,_,error in guard let data = data , error == nil else {
                return
            }
        
            do{

                let response1 = try JSONDecoder().decode(response.self, from: data)
              
                if response1.status == "sucess"{
                    DispatchQueue.main.async {
                        
                        
                        print(response1)
                        self.session.stopRunning()
                        self.view.willRemoveSubview(self.view1)
                        self.makeAr(Request: response1.data)           
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        
                    }
                    
                }
                
                
            }catch{
                print(error)
            }
        }
        task.resume()
        
    }
    @objc func stop(sender: UIButton!) {
        view.willRemoveSubview(arView)
   
        
        view.willRemoveSubview(stopButton)
        view.willRemoveSubview(refreshButton)
        
            arView?.removeFromSuperview()
            arView = nil
        session.removeInput(input)
        session.removeOutput(captureOutput)
        session.stopRunning()
        list.removeAll()
        viewDidLoad()
       
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
    
        }
  
    
    struct Plant:Codable {

        let Rega: Bool!
        let flagAlt: Bool!
        let Id: String!
        let Nome: String!
        let Tipo:String!
        let Temperatura: Float
        let Humidade: Float
        let Luminosidade: Float
        let TemperaturaIdeal: Float
        let LuminosidadeIdeal: Float
        let HumidadeIdeal: Float
    }
    
    struct response:Codable {
        let status:String
        let message:String!;
        let data:Plant;
        
    }
    
}
