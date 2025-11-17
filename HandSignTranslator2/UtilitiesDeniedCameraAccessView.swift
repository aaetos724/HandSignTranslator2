//
//  Utilities:DeniedCameraAccessView.swift
//  HandSignTranslator2
//
//  Created by Elisa Guadalupe Alejos Torres on 16/11/25.
//

import SwiftUI


struct DeniedCameraAccessView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: "video.slash.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("Camera Access Denied")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Please go to Settings > Privacy & Security > Camera to allow access for this app.")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
               
                Button("Open Settings") {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(40)
            .background(Color.red.opacity(0.8))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}
