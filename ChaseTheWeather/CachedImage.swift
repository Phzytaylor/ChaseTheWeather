//
//  CachedImage.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/26/23.
//

import SwiftUI

struct CachedImage<Content: View>: View {
    @StateObject private var manager = CahcedImageManger()
    let url: String
    @ViewBuilder let content: (AsyncImagePhase) -> Content
    var body: some View {
        ZStack {
            switch manager.currentState {
            case.loading:
                content(.empty)
            case .success(data: let data):
                if let image = UIImage(data: data) {
                    content(.success(Image(uiImage: image)))
                } else {
                    content(.failure(CachedImageError.invalidData))
                }
            case .failed(let error):
                content(.failure(error))
            default:
                content(.empty)
            }
        }.task {
            await manager.load(url)
        }
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedImage(url: "") {_ in
            EmptyView()
        }
    }
}

extension CachedImage {
    enum CachedImageError: Error {
        case invalidData
    }
}
