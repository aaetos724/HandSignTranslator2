//
//  Services:CameraManager.swift
//  HandSignTranslator2
//
//  Created by Elisa Guadalupe Alejos Torres on 16/11/25.
//

import SwiftUI
import AVFoundation
import Vision
import CoreML
import Combine


class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var detectedLetter = "?"
    @Published var confidence: Float = 0.0
    
    @Published var isRunning = false
    @Published var permissionDenied = false
    
    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()

    private let sessionQueue = DispatchQueue(label: "sessionQueue", qos: .userInitiated, attributes: .concurrent)
    
    private let model: HandPoseClassifier_2
    
    private lazy var handPoseRequest: VNDetectHumanHandPoseRequest = {
        let req = VNDetectHumanHandPoseRequest()
        req.maximumHandCount = 1
        return req
    }()
    
    override init() {
        do {
            let config = MLModelConfiguration()
            self.model = try HandPoseClassifier_2(configuration: config)
        } catch {
            fatalError("No se pudo inicializar el modelo Core ML (HandPoseClassifier_2): \(error)")
        }
        
        super.init()
        setupCamera()
    }
    
    // MARK: - Permisos y Sesión
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.startSession()
                    } else {
                        self?.permissionDenied = true
                    }
                }
            }
        case .denied, .restricted:
            DispatchQueue.main.async { [weak self] in
                self?.permissionDenied = true
            }
        @unknown default:
            break
        }
    }
    
    private func setupCamera() {
        
        session.beginConfiguration()
        
        session.sessionPreset = .vga640x480
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            session.commitConfiguration()
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        if let connection = videoOutput.connection(with: .video), connection.isVideoMirroringSupported {
            connection.automaticallyAdjustsVideoMirroring = false
            connection.isVideoMirrored = true
        }

        session.commitConfiguration()
    }
    
    func startSession() {
        guard !session.isRunning, !permissionDenied else { return }
        
        sessionQueue.async { [weak self] in
            self?.session.startRunning()
            DispatchQueue.main.async { self?.isRunning = true }
        }
    }
    
    func stopSession() {
        guard session.isRunning else { return }
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
            DispatchQueue.main.async { self?.isRunning = false }
        }
    }
    
    // MARK: - Procesamiento de Video
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
       
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try handler.perform([handPoseRequest])
        } catch {
            print("Error en Vision Request: \(error)")
            return
        }
        
        guard let observations = handPoseRequest.results, let firstHand = observations.first else {
            
            DispatchQueue.main.async { [weak self] in
                self?.detectedLetter = "?"
                self?.confidence = 0.0
            }
            return
        }
        
        
        guard let inputArray = try? createInputArray(from: firstHand) else { return }
        
        
        do {
            let input = HandPoseClassifier_2Input(poses: inputArray)
            let out = try model.prediction(input: input)
            
            let label = out.label
            let prob = out.labelProbabilities[label] ?? 0.0
            
            
            DispatchQueue.main.async { [weak self] in
                self?.detectedLetter = label
                self?.confidence = Float(prob)
            }
        } catch {
            print("Error en predicción de Core ML: \(error)")
        }
    }
    
    
    private func createInputArray(from observation: VNHumanHandPoseObservation) throws -> MLMultiArray {
        let orderedJoints: [VNHumanHandPoseObservation.JointName] = [
            .wrist, .thumbCMC, .thumbMP, .thumbIP, .thumbTip,
            .indexMCP, .indexPIP, .indexDIP, .indexTip,
            .middleMCP, .middlePIP, .middleDIP, .middleTip,
            .ringMCP, .ringPIP, .ringDIP, .ringTip,
            .littleMCP, .littlePIP, .littleDIP, .littleTip
        ]
        
        let allPoints = try observation.recognizedPoints(.all)
        
        guard let inputArray = try? MLMultiArray(shape: [1, 3, 21] as [NSNumber], dataType: .float32) else {
            fatalError("Error al inicializar MLMultiArray")
        }
        
        
        inputArray.withUnsafeMutableBytes { rawBuffer, _ in
            let ptr = rawBuffer.bindMemory(to: Float.self).baseAddress!
            let strideCoord = 21
            let t = 0
            
            for (j, joint) in orderedJoints.enumerated() {
                if let p = allPoints[joint] {
                   
                    ptr[t * 63 + 0 * strideCoord + j] = Float(p.location.x) // X
                    ptr[t * 63 + 1 * strideCoord + j] = Float(p.location.y) // Y
                    ptr[t * 63 + 2 * strideCoord + j] = Float(p.confidence) // Confianza (C)
                } else {
                    
                    ptr[t * 63 + 0 * strideCoord + j] = 0
                    ptr[t * 63 + 1 * strideCoord + j] = 0
                    ptr[t * 63 + 2 * strideCoord + j] = 0
                }
            }
        }
        return inputArray
    }
}
