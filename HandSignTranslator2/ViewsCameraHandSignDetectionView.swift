//
//  Views:Camera:HandSignDetectionView.swift
//  HandSignTranslator2
//
//  Created by Elisa Guadalupe Alejos Torres on 16/11/25.
//

import SwiftUI


struct HandSignDetectionView: View {
    @StateObject private var cameraManager = CameraManager()
    
    var body: some View {
        ZStack {
            
            if !cameraManager.permissionDenied {
                CameraPreview(session: cameraManager.session)
                    .ignoresSafeArea()
            } else {
                
                Color.black.ignoresSafeArea()
            }
            
            
            VStack {
                Spacer()
                
                
                VStack(spacing: 10) {
                    Text("Detected Letter:")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(cameraManager.detectedLetter)
                        .font(.system(size: 100, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 150, height: 150)
                        .background(
                            Circle()
                                .fill(Color.blue.opacity(0.8))
                        )
                    
                    Text("Confidence: \(Int(cameraManager.confidence * 100))%")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.6))
                )
                .padding(.bottom, 50)
            }
            
            
            if cameraManager.permissionDenied {
                DeniedCameraAccessView()
            } else if !cameraManager.isRunning {
                
                VStack {
                    Text("Starting Camera...")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.top, 50)
                    Spacer()
                }
            }
        }
        .onAppear {
            cameraManager.checkPermissions()
        }
        .onDisappear {
            cameraManager.stopSession()
        }
    }
}
