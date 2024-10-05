//
//  CardView.swift
//  ExpandableSearchBar
//
//  Created by Mohammed Rokon Uddin on 10/1/24.
//

import SwiftUI

struct CardView: View {
  @Binding var landmark: Landmark
  @Environment(LandmarksViewModel.self) private var viewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      GeometryReader {
        let size = $0.size
        AsyncImage(url: landmark.imageURL) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipped()
            .overlay {
              ZStack(alignment: .bottomLeading) {
                Rectangle()
                  .fill(
                    .linearGradient(
                      colors: [
                        .black.opacity(0),
                        .black.opacity(0.1),
                        .black.opacity(0.3),
                        .black.opacity(0.5),
                        .black.opacity(0.8),
                        .black.opacity(1),
                      ], startPoint: .top, endPoint: .bottom)
                  )
                Text(landmark.name)
                  .font(.title3)
                  .fontWeight(.bold)
                  .foregroundStyle(.white)
                  .padding()
              }
            }
            .onAppear {
              viewModel.addImage(image, for: landmark.id)
            }
        } placeholder: {
          ProgressView()
        }
      }
      .frame(height: 220)
    }
  }
}

#Preview {
  @Previewable @State var viewModel = LandmarksViewModel()
  CardView(landmark: .constant(.init(id: 1001, name: "Turtle Rock", subtitle: "Turtle Rock", imageName: "turtlerock")))
    .environment(viewModel)
}
