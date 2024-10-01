//
//  CustomScrollTarget.swift
//  ExpandableSearchBar
//
//  Created by Mohammed Rokon Uddin on 10/1/24.
//

import SwiftUI

struct CustomScrollTarget: ScrollTargetBehavior {
  func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
    let endPoint = target.rect.minY
    if endPoint < 76 {
      if endPoint > 40 {
        target.rect.origin = .init(x: 0, y: 76)
      } else {
        target.rect.origin = .zero
      }
    }
  }
}
