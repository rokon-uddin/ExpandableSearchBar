//
//  HomeView.swift
//  ExpandableSearchBar
//
//  Created by Mohammed Rokon Uddin on 10/1/24.
//

import SwiftUI

struct HomeView: View {
  private let viewModel = LandmarksViewModel()
  @Namespace private var animation
  @State private var progress: CGFloat = 0
  @State var searchText = ""
  @FocusState var isFocused: Bool
  var body: some View {
    @Bindable var bindings = viewModel
    NavigationStack {
      ScrollView(.vertical) {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 1), count: 2), spacing: 1) {
          ForEach($bindings.landmarks) { $landmark in
            NavigationLink(value: landmark) {
              CardView(landmark: $landmark)
                .environment(viewModel)
                .matchedTransitionSource(id: landmark.id, in: animation) {
                  $0.background(.clear)
                }
            }
            .buttonStyle(CustomButtonStyle())
          }
        }
        .offset(y: isFocused ? 0 : progress * 76)
        .padding(.bottom, 76)
        .safeAreaInset(edge: .top, spacing: 0) {
          ResizableHeader(progress: progress, text: $searchText, isFocused: $isFocused)
        }
        .scrollTargetLayout()
      }
      .scrollTargetBehavior(CustomScrollTarget())
      .animation(.snappy(duration: 0.3, extraBounce: 0), value: isFocused)
      .onScrollGeometryChange(for: CGFloat.self) {
        $0.contentOffset.y + $0.contentInsets.top
      } action: { oldValue, newValue in
        progress = max(min(newValue / 76, 1), 0)
      }
      .navigationDestination(for: Landmark.self) { landmark in
        DetailView(landmark: landmark, animation: animation)
          .environment(viewModel)
          .toolbarVisibility(.hidden, for: .navigationBar)
      }
      .onAppear {
        viewModel.fetchLandmarks()
      }
    }
  }
}

#Preview {
  HomeView()
}
