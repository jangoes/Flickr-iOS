//
//  PhotosView.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import SwiftUI

struct PhotosListView: View {
    
    @StateObject private var viewModel = PhotosListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.photos) { photos in
                photos.image
            }
            .navigationBarTitle("Photos")
        }
    }
}

struct PhotosListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosListView()
    }
}
