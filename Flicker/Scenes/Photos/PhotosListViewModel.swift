//
//  PhotosViewModel.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import SwiftUI

final class PhotosListViewModel: ObservableObject {
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var isLoading = false
    
    private var request: APIRequest<PhotosResource>?
    private var imageRequest: ImageRequest?
    
    init() {
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard !isLoading else { return }
        isLoading = true
        let resource = PhotosResource()
        let request = APIRequest(resource: resource)
        self.request = request
        request.execute { [weak self] wrapper in
            if let photos = wrapper?.photos.photo {
                
            }
            
            self?.isLoading = false
        }
    }
}
