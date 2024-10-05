//
//  ProgressiveBlurView.swift
//  ExpandableSearchBar
//
//  Created by Mohammed Rokon Uddin on 10/1/24.
//

import SwiftUI

struct ProgressiveBlurView: UIViewRepresentable {
  func makeUIView(context: Context) -> CustomBlurView {
    let view = CustomBlurView()
    view.backgroundColor = .clear
    return view
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {

  }
}

class CustomBlurView: UIVisualEffectView {

  init() {
    super.init(effect: UIBlurEffect(style: .systemThinMaterial))

    registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _) in
      DispatchQueue.main.async {
        self.removeFilter()
      }
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func removeFilter() {
    if let filterLayer = layer.sublayers?.first {
      filterLayer.filters = []
    }
  }
}
