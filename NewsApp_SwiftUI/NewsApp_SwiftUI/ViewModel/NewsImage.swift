//
//  NewsImage.swift
//  NewsApp_SwiftUI
//
//  Created by Stanislav Avramenko on 23.11.2020.
//

import SwiftUI

struct ArticleImage: View {
    @ObservedObject var imageLoader: ImageLoader
    @State private var animate = false

    var body: some View {
        Group {
            if !imageLoader.noData {
             ZStack {
                if self.imageLoader.image != nil {
                    Image(uiImage: self.imageLoader.image!)
                    .resizable()
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width) * 1,
                               height: UIScreen.main.bounds.width  * 0.30,
                                             alignment: .center)
                } else {
                    if imageLoader.url != nil {
                        Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: (UIScreen.main.bounds.width) * 0.3,
                               height: UIScreen.main.bounds.width  * 0.3,
                               alignment: .center)
                        .scaledToFit()
                        .overlay(
                            Text("Loading...")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: animate ? 60 : -60))
                            .onAppear {
                              withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                                            self.animate = true
                              }
                            }
                         )
                    } else {
                        EmptyView()
                    }
                }
             }
            } else {
                EmptyView()
            }
        }
    }
}

struct ArticleImage_Previews: PreviewProvider {
    static var previews: some View {
        ArticleImage(imageLoader: ImageLoader (url: URL(string: "https://fainaidea.com/wp-content/uploads/2019/06/acastro_190322_1777_apple_streaming_0003.0.jpg")))

    }
}
