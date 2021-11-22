//
//  cameraViewController.swift
//  Projeto
//
//  Created by Diogo Pinto on 20/11/2021.
//

import UIKit
import AVFoundation

class cameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    let session = AVCaptureSession()
    var videoPreview: AVCaptureVideoPreviewLayer?
    var QRcodeView: UIView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else{
            print("camera nao encontrada")
            return
        }
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            session.addInput(input)
            
            let captureOutput = AVCaptureMetadataOutput()
            
            session.addOutput(captureOutput)
            
            
            captureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreview = AVCaptureVideoPreviewLayer(session: session)
            videoPreview?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreview?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreview!)
            
            session.startRunning()
        }catch{
            print(error)
            return
        }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
