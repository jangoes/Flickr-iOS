//
//  PhotosView.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import SwiftUI

struct PhotosListView: View {
    
    @EnvironmentObject var viewModel: PhotosListViewModel
    
    private let title = "Photos"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.photos) { photo in
                    PhotoDetailView(photo: photo)
                        .environmentObject(viewModel)
                }
            }
            .navigationBarTitle(title)
        }
    }
}

struct PhotosListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosListView()
    }
}
