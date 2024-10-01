//
//  HomeView.swift
//  ExpandableSearchBar
//
//  Created by Mohammed Rokon Uddin on 10/1/24.
//

import SwiftUI

struct HomeView: View {
  private let viewModel = LandmarksViewModel()
  @State private var progress: CGFloat = 0
  @State var searchText = ""
  @FocusState var isFocused: Bool
  var body: some View {
    ScrollView(.vertical) {
      LazyVStack(spacing: 16) {
        ForEach(viewModel.landmarks) { landmark in
          CardView(landmark: landmark)
        }
      }
      .padding(16)
      .offset(y: isFocused ? 0 : progress * 76)
      .padding(.bottom, 76)
      .safeAreaInset(edge: .top, spacing: 0) {
        ResizableHeader(progress: progress, text: $searchText, isFocused: $isFocused)
      }
      //      .scrollTargetLayout()
    }
    //    .scrollTargetBehavior(CustomScrollTarget())
    .animation(.snappy(duration: 0.3, extraBounce: 0), value: isFocused)
    .onScrollGeometryChange(for: CGFloat.self) {
      $0.contentOffset.y + $0.contentInsets.top
    } action: { oldValue, newValue in
      progress = max(min(newValue / 76, 1), 0)
    }
    .onAppear {
      viewModel.fetchLandmarks()
    }
  }
}

#Preview {
  ContentView()
}

struct ResizableHeader: View {
  let progress: CGFloat
  @Binding var text: String
  @FocusState.Binding var isFocused: Bool

  var body: some View {
    let progress = isFocused ? 1 : progress
    VStack(spacing: 0) {
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text("Welcome Back!")
            .font(.callout)
            .foregroundStyle(.gray)
          Text("Rokon")
            .font(.title.bold())
        }
        Spacer(minLength: 0)

        Button {

        } label: {
          Image(systemName: "person.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(.circle)
        }
      }
      .frame(height: 60 - (60 * progress), alignment: .bottom)
      .padding(.horizontal, 16)
      .padding(.top, 16)
      .padding(.bottom, 16 - (16 * progress))
      .opacity(1 - progress)
      .offset(y: -10 * progress)

      HStack(spacing: 9) {
        Image(systemName: "magnifyingglass")
        TextField("Search Photos", text: $text)
          .focused($isFocused)
        Button {

        } label: {
          Image(systemName: "microphone.fill")
            .foregroundStyle(Color.red)
        }

      }
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background {
        RoundedRectangle(cornerRadius: isFocused ? 0 : 32)
          .fill(
            .background
              .shadow(.drop(color: .black.opacity(0.08), radius: 6, x: 6, y: 6))
              .shadow(.drop(color: .black.opacity(0.05), radius: 6, x: -6, y: -6))
          )
          .padding(.top, isFocused ? -100 : 0)
      }
      .padding(.horizontal, isFocused ? 0 : 16)
      .padding(.bottom, 8)
      .padding(.top, 6)
    }
    .background {
      ProgressiveBlurView()
        .blur(radius: isFocused ? 0 : 12)
        .padding(.horizontal, -16)
        .padding(.bottom, -10)
        .padding(.top, -100)
    }
    .visualEffect { content, proxy in
      content.offset(y: offsetY(proxy))
    }
  }

  nonisolated private
    func offsetY(_ proxy: GeometryProxy) -> CGFloat
  {
    let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
    return minY > 0 ? (isFocused ? -minY : 0) : -minY
  }
}
