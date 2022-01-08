import UIKit
import AVFoundation
import RealityKit

class ARViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate {
    var session = AVCaptureSession()
    var videoPreview: AVCaptureVideoPreviewLayer?
    var arView:ARView! = nil
    let captureOutput = AVCaptureMetadataOutput()
    var list = [String]()
    let radius =  -90 * Float.pi / 180.0
    let radius2 =  180 * Float.pi / 180.0
    var input:AVCaptureInput!
    var RequestId:String!
    @IBOutlet weak var WaterButton: UIBarButtonItem!
    @IBOutlet weak var RefreshButton: UIBarButtonItem!
    let view1 = UIView();
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        WaterButton.isEnabled = false;
        RefreshButton.isEnabled = false;
        self.navigationController?.navigationBar.isHidden = false

        qrScanner()
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.isHidden = false

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
      
        let measuretitle2 = MeshResource.generateText( "humidade: \(Request.Humidade) Humidade Ideal: \(Request.HumidadeIdeal) ", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.08), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
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
      
        
        
        let measuretitle3 = MeshResource.generateText( "Luminosidade: \(Request.Luminosidade) Luminosidade Ideal: \(Request.LuminosidadeIdeal) ", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.08), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
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
        
        
        
        //measureTitle4
      
        
        
        let measuretitle4 = MeshResource.generateText( "Humidade do solo : \(Request.HumidadeSolo) Humidade do solo ideal : \(Request.HumidadeSoloIdeal) ", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.08), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
        let measuretitle4Material = SimpleMaterial(color: .black, isMetallic: false)
        let measuretitle4Entity = ModelEntity(mesh: measuretitle4, materials: [measuretitle4Material])
        
      
        measuretitle4Entity.transform.rotation *= simd_quatf(angle: radius , axis: SIMD3(x: 1, y: 0, z: 0))
        let measuretitle4Anchor = AnchorEntity(world: SIMD3(x: -1, y: -1.4, z: 0))
        measuretitle4Anchor.addChild(measuretitle4Entity)
        arView.scene.addAnchor(measuretitle4Anchor)
        
        
        //measure4
        let measure40mark = SimpleMaterial(color: .black,roughness: 0, isMetallic: false)
        let Mark40 = MeshResource.generatePlane(width: 0.01 , depth: 0.1, cornerRadius:0.005)
        let measure40Entety = ModelEntity(mesh: Mark40 , materials: [measure40mark])
        
        let measurebar4 = SimpleMaterial(color: .lightGray,roughness:0, isMetallic: false)
        let measurebar4Plane = MeshResource.generatePlane(width: 2 , depth: 0.1, cornerRadius:0.005)
        let measurebar4Entety = ModelEntity(mesh: measurebar4Plane , materials: [measurebar4])
        
        let measure4Material:SimpleMaterial!
        var humidadeSolo:Float!
        
        if(Request.HumidadeSolo<0){
            humidadeSolo = Request.HumidadeSolo * -1
            measure4Material = SimpleMaterial(color: .red,roughness: 0, isMetallic: false)
        }else{
            humidadeSolo = Request.HumidadeSolo
             measure4Material = SimpleMaterial(color: .green,roughness: 0, isMetallic: false)
        }
        let measure4 = MeshResource.generatePlane(width: humidadeSolo/1000.0 , depth: 0.1, cornerRadius:0.005)
        let measure4Ideal = MeshResource.generatePlane(width: 0.01 , depth: 0.1, cornerRadius:0.005)
        let measure4IdealMaterial = SimpleMaterial(color: .red,roughness: 0, isMetallic: false)
        let measure4IdealEntety = ModelEntity(mesh: measure4Ideal, materials: [measure4IdealMaterial])
        let measure4Entity = ModelEntity(mesh: measure4, materials: [measure4Material])
        
        
        
        let measure4Anchor0Mark = AnchorEntity(world: SIMD3(x: 0, y: -1.37, z: 0.1))
        let measure4barMark = AnchorEntity(world: SIMD3(x: 0, y: -1.39, z: 0.1))
        let measure4IdealAnchor = AnchorEntity(world: SIMD3(x: (Request.HumidadeSoloIdeal)/1000, y: -1.37, z: 0.1))
        let measure4Anchor = AnchorEntity(world: SIMD3(x: 0 + (humidadeSolo)/2000.0, y: -1.38, z: 0.1))
        measure4Anchor.addChild(measure4Entity)
        measure4Anchor0Mark.addChild(measure40Entety)
        measure4barMark.addChild(measurebar4Entety)
        measure4IdealAnchor.addChild(measure4IdealEntety)
        arView.scene.addAnchor(measure4Anchor)
        arView.scene.addAnchor(measure4Anchor0Mark)
        arView.scene.addAnchor(measure4barMark)
        arView.scene.addAnchor(measure4IdealAnchor)
        
        
        
        
        
        
        //logo
        var myLogo = SimpleMaterial()
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
               // Download contents of imageURL as Data.  Use a URLSession if you want to do this asynchronously.
        let data = try! Data(contentsOf:URL(string: url + "/img/logo.c231748f.png")!)
               
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
        let board = MeshResource.generatePlane(width: 2.1, depth: 2.1, cornerRadius:0.1)
        let simpleMaterial = SimpleMaterial(color: .white,roughness: 0, isMetallic: false)
        
        let boardEntity = ModelEntity(mesh: board, materials: [simpleMaterial])
            
        let boardAnchor = AnchorEntity(world: SIMD3(x: 0, y: -1.4, z: -0.8))
        

        boardAnchor.addChild(boardEntity)
        
      
        arView.scene.addAnchor(boardAnchor)
       
        WaterButton.isEnabled = true
        RefreshButton.isEnabled = true
        RefreshButton.target = self
        RefreshButton.action = #selector(stop)
        WaterButton.target = self
        WaterButton.action = #selector(Post)
        RequestId = Request.Id
        view.addSubview(arView)

        //view.sendSubviewToBack(arView)
        
       
        
    }
    
    
    
    
    private func Get(QrText:String){
        guard let ConUrl = URL(string: url + "/api/GetBox/box/singleId/"+QrText) else { return}
        let defaults = UserDefaults.standard
        print(QrText)
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + defaults.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
   
        print(request)
        let task = URLSession.shared.dataTask(with: request) { data,_,error in guard let data = data , error == nil else {
                return
            }
        
            do{
                let response = try JSONDecoder().decode(Plant.self, from: data)
              
                print(response)
                if response.Id != nil{
                    DispatchQueue.main.async {
                        
                        
                        print(response)
                        self.session.stopRunning()
                        self.view.willRemoveSubview(self.view1)
                        self.makeAr(Request: response)
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        
                        self.showToast(controller: self , message: "box não encontrada", seconds: 2.0)
                    }
                    
                }
                
                
            }catch{
                print(error)
                DispatchQueue.main.async {
                    
                    self.showToast(controller: self , message: "box não encontrada", seconds: 2.0)
                }
            }
        }
        task.resume()
        
    }
    
    
    
    
    @objc private func Post(){
       
        guard let ConUrl = URL(string: url + "/api/openWaterValve") else { return}
        let defaults = UserDefaults.standard
        
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + defaults.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable]=[
            "id": RequestId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data,_,error in guard let data = data , error == nil else {
                return
            }
        
            do{
                let responsePostRequest = try JSONDecoder().decode(responseWater.self, from: data)
                
                
                if responsePostRequest.status{
                   
                    DispatchQueue.main.async {
                        self.showToast(controller: self , message: " planta ira ser  regada", seconds: 2.0)
                    }
                    
                }else{
                    
                    DispatchQueue.main.async {
                        self.showToast(controller: self , message: "erro a planta não foi regada", seconds: 2.0)
                     }
                }
            }catch{
                print(error)
            }
        }
        task.resume()
        
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
    @objc func stop(sender: UIButton!) {
        view.willRemoveSubview(arView)
        RefreshButton.isEnabled = false
        WaterButton.isEnabled = true
        
            arView?.removeFromSuperview()
            arView = nil
        session.removeInput(input)
        session.removeOutput(captureOutput)
        session.stopRunning()
        list.removeAll()
        viewDidLoad()
       
        }
    
  
    
    
    struct responseWater:Codable {
        let status:Bool
        
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
        let HumidadeSolo: Float
        let HumidadeSoloIdeal: Float
    }
    
    struct response:Codable {
        let status:String
        let message:String!;
        let list:Plant?;
        
    }
    
}
