//
//  ScanViewController.swift
//  SWiP2
//
//  Created by Mathieu Harribey on 08/11/2017.
//  Copyright © 2017 Mathieu Harribey. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var bloc1: UIView!
    @IBOutlet weak var bloc2: UIView!
    @IBOutlet weak var bloc3: UIView!
    @IBOutlet weak var bloc4: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var result = ""
    
    var nbArticles = 0
    var total = 0.0
    var articleList = ""
    var articlePrice = ""
    var totalSpend = UserDefaults.standard.object(forKey: "total") as? Double ?? 0.0
    var array: [[String: String]] = []
    
    var infos: [String: String] = [:]
    
    var date: String = ""
    var shop: String = ""
    
    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417,
                              AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.layer.cornerRadius = 20
        infoLabel.clipsToBounds = true
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: header)
            view.bringSubview(toFront: bloc1)
            view.bringSubview(toFront: bloc2)
            view.bringSubview(toFront: bloc3)
            view.bringSubview(toFront: bloc4)
            view.bringSubview(toFront: infoLabel)

            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                
                //insert seb algo here
                if result == "" {
                    if let data = metadataObj.stringValue?.data(using: .utf8) {
                        if let jsonDataArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let infos = jsonDataArray!["infos"] as? [String: String] {
                                result += "Le \(infos["date"]!), à \(infos["shop"]!)"
                                shop = "\(infos["shop"]!)"
                                date = "\(infos["date"]!)"
                            }
                            if let articles = jsonDataArray!["articles"] as? [String: String] {
                                for article in articles {
                                    nbArticles += 1
                                    if let value = Double(article.value) {
                                        total += value
                                        
                                        UserDefaults.standard.set(totalSpend, forKey: "total")

                                        articlePrice += "\(value) € \n"
                                    }
                                    articleList += "\(article.key) \n"
                                }
                                
                                if (UserDefaults.standard.object(forKey: "total") != nil) {
                                    totalSpend += total
                                } else {
                                    totalSpend = total
                                }
                                
                                result += ", vous avez acheté \(nbArticles) articles pour un montant total de \(total) €"
                            }
                        }
                    }
                }
                
                
                let alert = UIAlertController(title: "Nouvel ajout", message: result, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler:
                    { (nil) in
                        self.result = ""
                        self.nbArticles = 0
                        self.total = 0
                        
                }))
                alert.addAction(UIAlertAction(title: "Confirmer", style: .default, handler:
                    { (nil) in
                    
                    if (self.defaults.object(forKey: "Result") != nil) {
                        self.array = self.defaults.object(forKey: "Result") as? [[String: String]] ?? [[String: String]]()
                    }
                    
                    self.infos = ["date": self.date, "shop": self.shop, "total": (self.total.description), "articleList": self.articleList, "articlePrice": self.articlePrice, "articleCount": (self.nbArticles.description)]
                    
                    
                        
                    
                    self.array.append(self.infos)
                    self.defaults.set(self.array, forKey: "Result")
  
                    UserDefaults.standard.set(self.totalSpend, forKey: "total")
                        
                    self.result = ""
                    self.date = ""
                    self.shop = ""
                    self.nbArticles = 0
                    self.total = 0
                }))
                
                present(alert, animated: true, completion: nil)
                
            }
        }
    }

}
