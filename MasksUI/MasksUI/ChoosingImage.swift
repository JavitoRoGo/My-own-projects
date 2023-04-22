//
//  ChoosingImage.swift
//  MasksUI
//
//  Created by Javier Rodríguez Gómez on 16/12/21.
//

import SwiftUI

struct ChoosingImage: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Pulsa para seleccionar una imagen")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                Button("Guardar imagen", action: save)
            }
            .padding()
            .frame(width: 400, height: 350)
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
    }
    
    func save() {
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct ChoosingImage_Previews: PreviewProvider {
    static var previews: some View {
        ChoosingImage()
            .previewLayout(.fixed(width: 400, height: 350))
    }
}
