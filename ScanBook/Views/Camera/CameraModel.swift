//
//  CameraModel.swift
//  SUExamples
//
//  Created by 김학철 on 10/12/23.
//

import SwiftUI
import AVFoundation
import Combine
import CoreImage

class CameraModel: NSObject, ObservableObject {
    private var cancelBag = Set<AnyCancellable>()
    @Published var image: CGImage?
    @Published var cameraPermissionAlert = false
    @Published private var permissionGranted = false
    private let caputureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    
    override init() {
        super.init()
        $permissionGranted
            .receive(on: RunLoop.main)
            .map { val -> Bool in
                if val {
                    self.setUp()
                }
                return val
            }
            .assign(to: \.cameraPermissionAlert, on: self)
            .store(in: &cancelBag)
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.permissionGranted = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    self.permissionGranted = true
                }
            }
        case .denied:
            self.permissionGranted = false
        default:
            return
        }
    }
    
    func bestDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing capture devices.")}
        
        return devices.first(where: { device in device.position == position })!
    }
    func setUp() {
        sessionQueue.async { [unowned self] in
            self.setUpCaptureSession()
            self.caputureSession.startRunning()
        }
    }
    func setUpCaptureSession() {
        guard permissionGranted else { return }
        
        do {
            let output = AVCaptureVideoDataOutput()
            let device = self.bestDevice(position: .back)
            let input = try AVCaptureDeviceInput(device: device)
            
            guard caputureSession.canAddInput(input) else { return }
            caputureSession.addInput(input)
            
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferDelegate"))
            caputureSession.addOutput(output)
            
            if (output.connection(with: .video)?.isVideoRotationAngleSupported) != nil {
                output.connection(with: .video)?.videoRotationAngle = 90
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFrameSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        DispatchQueue.main.async {
            self.image = cgImage
        }
    }
    private func imageFrameSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciimage = CIImage(cvImageBuffer: buffer)
        guard let cgimage = context.createCGImage(ciimage, from: ciimage.extent) else { return nil }
        return cgimage
    }
}
