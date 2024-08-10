//
//  ExpandedImageView.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import SwiftUI

struct ExpandedImageView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let url : URL
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            CachedAsyncImage(url: url)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .cornerRadius(8)
            
            Button {
                withAnimation(.smooth) {
                    dismiss()
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    .padding()
            }

        }
    }
}

//#Preview {
//    ExpandedImageView(catModel: CatModel, breedDetails: )
//}
