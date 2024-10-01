//
//  CardView.swift
//  ExpandableSearchBar
//
//  Created by Mohammed Rokon Uddin on 10/1/24.
//

import SwiftUI

struct CardView: View {
  let landmark: Landmark

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      GeometryReader {
        let size = $0.size

        AsyncImage(url: landmark.imageURL) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipShape(.rect(cornerRadius: 16))
        } placeholder: {
          ProgressView()
        }
      }
      .frame(height: 220)

      Text(landmark.name)
        .font(.callout)
        .foregroundStyle(.primary.secondary)
    }
  }
}
