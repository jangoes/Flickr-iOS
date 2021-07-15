//
//  FavouritesView.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var viewModel: PhotosListViewModel
    
    private let title = "Favourites"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.likedPhotos) { photo in
                    PhotoDetailView(photo: photo)
                        .environmentObject(viewModel)
                }
            }
            .navigationBarTitle(title)
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
