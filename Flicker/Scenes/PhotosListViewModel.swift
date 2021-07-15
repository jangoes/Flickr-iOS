//
//  PhotosViewModel.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import SwiftUI
import CoreData

final class PhotosListViewModel: ObservableObject {
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var isLoading = false
    @Published private(set) var likedPhotos: [Photo] = []
    
    private var likedPhotosEntity: [LikedPhotoEntity] = []
    private var cachedPhotosEntity: [CachedPhotoEntity] = []
    private var request: APIRequest<PhotosResource>?
    private var imageRequest: ImageRequest?
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "PhotosList")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error: \(error.localizedDescription)")
            }
        }
        
        fetchLikedPhotos()
        fetchCachedPhotos()
        fetchPhotos()
    }
    
    // - Fetching of photos from the API
    func fetchPhotos() {
        guard !isLoading else { return }
        isLoading = true
        let resource = PhotosResource()
        let request = APIRequest(resource: resource)
        self.request = request
        request.execute { [weak self] wrapper in
            if let photos = wrapper?.photos.photo {
                self?.deleteAllCachedPhoto()
                
                for photo in photos {
                    var newPhoto = photo
                    
                    // - Modify fetched photo to favorite if it matches from liked photos
                    if self?.likedPhotos.filter( { $0.id == newPhoto.id }).first != nil {
                        newPhoto.isFavorite = true
                    }
                    
                    self?.savePhoto(photo: newPhoto)
                    self?.photos.append(newPhoto)
                }
            }
            
            self?.isLoading = false
        }
    }
    
    // - Fetching of cached photos
    func fetchCachedPhotos() {
        let request = NSFetchRequest<CachedPhotoEntity>(entityName: "CachedPhotoEntity")
        
        do {
            cachedPhotosEntity = try container.viewContext.fetch(request)
            parseCachedPhotos()
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    // - Fetching of liked photos
    func fetchLikedPhotos() {
        let request = NSFetchRequest<LikedPhotoEntity>(entityName: "LikedPhotoEntity")
        
        do {
            likedPhotosEntity = try container.viewContext.fetch(request)
            parseLikedPhotos()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // - Save fetched data to persistence cache
    func savePhoto(photo: Photo) {
        let newPhoto = CachedPhotoEntity(context: container.viewContext)
        newPhoto.id = photo.id
        newPhoto.title = photo.title
        newPhoto.owner = photo.owner
        newPhoto.imageUrl = photo.imageUrl
        
        saveData()
    }
    
    func deleteAllCachedPhoto() {
        for photo in cachedPhotosEntity {
            container.viewContext.delete(photo)
        }
    }
    
    // - Add liked photo
    func addLikedPhoto(photo: Photo) {
        let newPhoto = LikedPhotoEntity(context: container.viewContext)
        newPhoto.id = photo.id
        newPhoto.title = photo.title
        newPhoto.owner = photo.owner
        newPhoto.imageUrl = photo.imageUrl
        
        saveData()
    }
    
    // - Remove liked photo
    func deleteLikedPhoto(photo: Photo) {
        if let row = likedPhotosEntity.firstIndex(where: { $0.id == photo.id }) {
            let photoInfo = likedPhotosEntity[row]
            container.viewContext.delete(photoInfo)
            saveData()
        }
    }
    
    // - Save changes to persistence
    func saveData() {
        do {
            try container.viewContext.save()
            fetchLikedPhotos()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // - Parse cached photos entity to photo
    func parseCachedPhotos() {
        for photo in cachedPhotosEntity {
            if let id = photo.id, let title = photo.title, let owner = photo.owner, let url = photo.imageUrl {
                var cachedPhoto = Photo(id: id, title: title, owner: owner, imageUrl: url)
                
                if self.likedPhotos.filter( { $0.id == cachedPhoto.id }).first != nil {
                    cachedPhoto.isFavorite = true
                }
                
                photos.append(cachedPhoto)
            }
        }
    }
    
    // - Parse liked photos entity to photo
    func parseLikedPhotos() {
        likedPhotos = []
        
        for photo in likedPhotosEntity {
            if let id = photo.id, let title = photo.title, let owner = photo.owner, let url = photo.imageUrl {
                let likedPhoto = Photo(id: id, title: title, owner: owner, imageUrl: url, isFavorite: true)
                likedPhotos.append(likedPhoto)
            }
        }
    }
    
    // - Get photo at specific index
    func getPhoto(index: Int) -> Photo {
        return photos[index]
    }
    
    // - Get star icon for liked / unliked photos
    func favoriteImage(for photo: Photo) -> String {
        return photo.isFavorite ? SystemImage.starCircleFill.rawValue : SystemImage.starCirle.rawValue
    }
    
    // - Did tap like button action
    func didTapFavorite(photo: Photo) {
        if let row = photos.firstIndex(where: { $0.id == photo.id }) {
            photos[row].isFavorite = !photos[row].isFavorite
            
            if photos[row].isFavorite {
                addLikedPhoto(photo: photo)
            } else {
                deleteLikedPhoto(photo: photo)
            }
        }
    }
}
