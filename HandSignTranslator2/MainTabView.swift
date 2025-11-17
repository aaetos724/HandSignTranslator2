//
//  MainTabView.swift
//  HandSignTranslator2
//
//  Created by Elisa Guadalupe Alejos Torres on 16/11/25.
//

import SwiftUI

@main
struct HandSignTranslator2App: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            // PESTAÑA 1: Traductor de Texto a Señas (Texto -> Imagen)
            TextToSignView()
                .tabItem {
                    Label("Text", systemImage: "text.bubble")
                }
            
            // PESTAÑA 2: Detección de Señas (Cámara -> Core ML)
            HandSignDetectionView()
                .tabItem {
                    Label("Detect", systemImage: "hand.raised.fill")
                }
        }
        .accentColor(.blue) // Color de los iconos de la pestaña seleccionada
    }
}

