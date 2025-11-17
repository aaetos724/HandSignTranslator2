//
//  Views:Translation:SequentialSignView.swift
//  HandSignTranslator2
//
//  Created by Elisa Guadalupe Alejos Torres on 16/11/25.
//
import SwiftUI


struct SequentialSignView: View {
    @ObservedObject var translator: SignLanguageTranslator
    @State private var displayedCharacter: String?
    @State private var opacity: Double = 1.0
    @State private var previousIndex: Int = -1
    

    private let fadeDuration: Double = 0.5
    private let changeDelay: Double = 0.2
    
    var body: some View {
        ZStack {
            if let character = displayedCharacter {
                SignImageView(character: character)
                    .opacity(opacity)
                    .transition(.opacity)
            }
            
            else if !translator.translatedSigns.isEmpty,
                    !translator.isAnimating,
                    translator.currentSignIndex == translator.translatedSigns.count - 1,
                    let lastCharacter = translator.translatedSigns.last {
                SignImageView(character: lastCharacter)
                    .opacity(1.0)
            }
        }
        .onChange(of: translator.currentSignIndex) { oldValue, newValue in
            handleIndexChange(newValue)
        }
        .onAppear {
            if translator.currentSignIndex >= 0,
               translator.currentSignIndex < translator.translatedSigns.count {
                
                let character = translator.translatedSigns[translator.currentSignIndex]
                displayedCharacter = character
                opacity = 1.0
                previousIndex = translator.currentSignIndex
            }
        }
    }
    
    private func handleIndexChange(_ newIndex: Int) {
        
        
        guard newIndex >= 0 else {
            withAnimation(.easeInOut(duration: fadeDuration)) { opacity = 0.0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration) {
                displayedCharacter = nil
                previousIndex = -1
            }
            return
        }
        
        
        guard newIndex < translator.translatedSigns.count else {
            
            previousIndex = -1
            return
        }
        
        
        let newCharacter = translator.translatedSigns[newIndex]

        if previousIndex != newIndex {
            
            withAnimation(.easeInOut(duration: fadeDuration)) {
                opacity = 0.0
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration + changeDelay) {
                
                self.displayedCharacter = newCharacter
                self.previousIndex = newIndex
                
                
                withAnimation(.easeInOut(duration: fadeDuration)) {
                    self.opacity = 1.0
                }
            }
        }
    }
}
