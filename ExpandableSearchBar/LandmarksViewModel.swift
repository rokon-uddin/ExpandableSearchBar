//
//  LandmarksViewModel.swift
//  ExpandableSearchBar
//
//  Created by Mohammed Rokon Uddin on 10/1/24.
//

import Foundation

@Observable
class LandmarksViewModel {
  private let client = LandmarksClient()
  var landmarks: Landmarks = []

  func fetchLandmarks() {
    do {
      let landmarks = try client.fetchLandmarks()
      self.landmarks = landmarks
    } catch {
      print(error.localizedDescription)
    }
  }
}
