//
//  ContentView.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = PhotosListViewModel()
    
    var body: some View {
        TabView {
            PhotosListView()
                .tabItem {
                    SystemImage.photo.image
                    Text("Photos")
                }
                .environmentObject(viewModel)
            
            FavouritesView()
                .tabItem {
                    SystemImage.starCirle.image
                    Text("Favourites")
                }
                .environmentObject(viewModel)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
