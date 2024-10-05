//
//  DetailView.swift
//  ExpandableSearchBar
//
//  Created by Mohammed Rokon Uddin on 10/6/24.
//

import SwiftUI

struct DetailView: View {
  var landmark: Landmark
  var animation: Namespace.ID
  @State var showHeader = true
  @State var hidesThumbnail = false
  @State var scrollId: Int?
  @Environment(LandmarksViewModel.self) private var viewModel
  @Environment(\.dismiss) var dismiss

  var body: some View {
    GeometryReader {
      let size = $0.size
      Color.black
      ScrollView(.vertical) {
        LazyVStack(spacing: 0) {
          ForEach(viewModel.landmarks) { landmark in
            if let image = viewModel.images[landmark.id] {
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 16))
            }
          }
        }
        .scrollTargetLayout()
      }
      .onTapGesture {
        showHeader.toggle()
      }
      .animation(.easeInOut(duration: 0.6), value: showHeader)
      .overlay(alignment: .topTrailing) {
        if showHeader {
          ZStack(alignment: .topTrailing) {
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
                  ], startPoint: .bottom, endPoint: .top)
              )
            HStack(spacing: 0) {
              Text(landmark.name)
                .font(.title2)
                .foregroundStyle(.white)

              Spacer()
              Button {
                dismiss()
              } label: {
                Image(systemName: "x.circle.fill")
                  .font(.title)
                  .foregroundStyle(.white)
              }
            }
            .padding([.leading, .trailing], 16)
            .padding(.top, 44)
          }
          .frame(height: 160)
        }
      }
      .scrollPosition(id: $scrollId)
      .scrollTargetBehavior(.paging)
      .scrollIndicators(.hidden)
      .zIndex(hidesThumbnail ? 1 : 0)
      .task {
        try? await Task.sleep(for: .seconds(2.0))
        showHeader = false
      }

      if let image = viewModel.images[landmark.id], !hidesThumbnail {
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: size.width, height: size.height)
          .clipShape(.rect(cornerRadius: 16))
          .task {
            scrollId = landmark.id
            try? await Task.sleep(for: .seconds(0.16))
            hidesThumbnail = true
          }
      }

    }
    .ignoresSafeArea()
    .navigationTransition(.zoom(sourceID: hidesThumbnail ? scrollId ?? landmark.id : landmark.id, in: animation))
  }
}
