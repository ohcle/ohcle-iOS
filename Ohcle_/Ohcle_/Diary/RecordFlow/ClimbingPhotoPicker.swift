//
//  ClimbingPhotoPicker.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/03/01.
//

import SwiftUI
import PhotosUI

class ClimbingImagePicker: ObservableObject {
    @Published var image: Image?
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await self.loadTrnasferable(from: imageSelection)
                }
            }
        }
    }
    
    @MainActor func loadTrnasferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                let uiImage = UIImage(data: data) ?? UIImage()
                let image = Image(uiImage: uiImage)
                self.image = image

                DataController.shared.saveTemporaryPhotoData(data)
            }
        } catch {
            self.image = nil
            print("error message: \(error.localizedDescription)")
        }
    }
}

