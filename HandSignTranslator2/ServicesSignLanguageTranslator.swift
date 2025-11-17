//
//  Services:SignLanguageTranslator.swift
//  HandSignTranslator2
//
//  Created by Elisa Guadalupe Alejos Torres on 16/11/25.
//

import Foundation
import SwiftUI
import Combine


class SignLanguageTranslator: ObservableObject {
    @Published var translatedSigns: [String] = []
    @Published var currentSignIndex: Int = -1
    @Published var isAnimating: Bool = false
    
   
    private var animationTask: DispatchWorkItem?
    
    
    func translate(_ text: String) {
        stopAnimation()
        let uppercaseText = text.uppercased()
        
        let characters = uppercaseText.filter { character in
            character.isLetter || (character.isNumber && character != "0")
        }
        
        translatedSigns = characters.map { String($0) }
        currentSignIndex = -1
        
        if !translatedSigns.isEmpty {
            startSequentialAnimation()
        }
    }
    
    
    private func startSequentialAnimation() {
        isAnimating = true
        currentSignIndex = -1
        
        
        let firstTask = DispatchWorkItem { [weak self] in
            guard let self = self, !self.translatedSigns.isEmpty else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                 self.currentSignIndex = 0
                 self.continueAnimation()
            }
        }
        animationTask = firstTask
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: firstTask)
    }
    
    
    private func continueAnimation() {
        guard currentSignIndex < translatedSigns.count - 1 else {
           
            isAnimating = false
            return
        }
        
        
        let nextTask = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.currentSignIndex += 1
            self.continueAnimation()
        }
        animationTask = nextTask
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: nextTask)
    }
    
    
    func stopAnimation() {
        animationTask?.cancel()
        animationTask = nil
        isAnimating = false
        currentSignIndex = -1 
    }
    
   
    func clear() {
        stopAnimation()
        translatedSigns = []
        currentSignIndex = -1
    }
}

