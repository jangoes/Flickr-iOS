//
//  PhotoDetailView.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import SwiftUI

struct PhotoDetailView: View {
    
    @EnvironmentObject var viewModel: PhotosListViewModel
    
    let photo: Photo
    
    private let height: CGFloat = 300
    private let buttonSize: CGFloat = 30
    private let buttonSideOffset: CGFloat = 15
    private let descriptionSideOffset: CGFloat = 10
    private let gradient = Gradient(stops: [
        .init(color: .black.opacity(0), location: 0.25),
        .init(color: .black.opacity(0.45), location: 1)
    ])
    
    var body: some View {
        ZStack {
            AsyncImage(url: photo.imageUrl.url!) {
                Color.black
            } image: { image in
                Image(uiImage: image)
                    .resizable()
            }
            
            Rectangle()
                .fill(
                    LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
                )
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        viewModel.didTapFavorite(photo: photo)
                    }, label: {
                        Image(systemName: viewModel.favoriteImage(for: photo))
                            .resizable()
                            .frame(width: buttonSize, height: buttonSize)
                            .foregroundColor(.white)
                    })
                }
                .padding([.top, .trailing], buttonSideOffset)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(photo.title)
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(photo.owner)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding([.leading, .bottom], descriptionSideOffset)
            }
        }
        .frame(height: height)
        .listRowInsets(EdgeInsets())
    }
}
