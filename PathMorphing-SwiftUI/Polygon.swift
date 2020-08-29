//
//  Polygon.swift
//  PathMorphing-SwiftUI
//
//  Created by Joshua Homann on 8/22/20.
//

import SwiftUI

@discardableResult public func with<T>(_ item: T, update: (inout T) throws -> Void) rethrows -> T {
  var copy = item
  try update(&copy)
  return copy
}

struct Polygon: Identifiable {
  var id = UUID()
  var name: String = ""
  var vertices: [CGPoint] = []
  var isClosed: Bool = false
  func makeCopy() -> Polygon {
    with(self) {
      $0.id = .init()
      $0.name = name + " copy"
    }
  }
  func makePath() -> Path {
    Path { path in
      if vertices.count > 1 {
        path.addLines(vertices)
        if isClosed {
          path.closeSubpath()
        }
      }
    }
  }
}
