//
//  Views:Translation:SignImageView.swift
//  HandSignTranslator2
//
//  Created by Elisa Guadalupe Alejos Torres on 16/11/25.
//

import SwiftUI


struct SignImageView: View {
    let character: String
    private let imageName: String
    private let imageExists: Bool
    
    init(character: String) {
        self.character = character.uppercased()
        self.imageName = SignNameUtility.imageName(for: character)
        self.imageExists = SignNameUtility.imageExists(for: character) 
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Group {
                if imageExists {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray5))
                        VStack(spacing: 8) {
                            Image(systemName: "hand.raised.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            Text("No Image")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .frame(maxWidth: 200, maxHeight: 200)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            
            Text(character)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
