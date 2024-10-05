//
//  LandmarksViewModel.swift
//  ExpandableSearchBar
//
//  Created by Mohammed Rokon Uddin on 10/1/24.
//

import SwiftUI

@Observable
class LandmarksViewModel {
  var landmarks: Landmarks = []
  private let client = LandmarksClient()
  var images: [Int: Image] = [:]

  func addImage(_ image: Image, for id: Int) {
    images[id] = image
  }

  func fetchLandmarks() {
    do {
      let landmarks = try client.fetchLandmarks()
      self.landmarks = landmarks
    } catch {
      print(error.localizedDescription)
    }
  }
}
