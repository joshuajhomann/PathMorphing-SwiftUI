//
//  PolygonViewModel.swift
//  PathMorphing-SwiftUI
//
//  Created by Joshua Homann on 8/22/20.
//

import SwiftUI
import Combine

final class DrawingViewModel: ObservableObject {
  @Published private(set) var selectedPolygonIndex: Int = 0
  @Published private(set) var polygons: [Polygon] = [.init()]
  @Published private(set) var previousPolygons: [Polygon] = []

  var selectedPolygon: Polygon {
    get { polygons[selectedPolygonIndex] }
    set { polygons[selectedPolygonIndex] = newValue }
  }
  
  var canGoBack: Bool {
    selectedPolygonIndex > 0
  }

  var canGoForward: Bool {
    polygons.indices.contains(selectedPolygonIndex + 1)
  }

  enum Constant {
    static let vertexRadius: CGFloat = 12
  }

  private var subscriptions = Set<AnyCancellable>()

  init() {
    Publishers.CombineLatest($polygons, $selectedPolygonIndex)
      .map { polygons, index -> [Polygon] in
        Array(polygons[(0..<index).suffix(5)])
      }
      .assign(to: \.previousPolygons, on: self)
      .store(in: &subscriptions)
  }

  func tap(_ location: CGPoint) {
    if let index = indexOfVertex(for: location) {
      if index == 0 && selectedPolygon.isClosed {
        selectedPolygon.isClosed = false
      } else if index == 0 {
        selectedPolygon.isClosed = true
      } else {
        selectedPolygon.vertices.remove(at: index)
      }
    } else if !selectedPolygon.isClosed {
      selectedPolygon.vertices.append(location)
    }
    if selectedPolygon.vertices.count < 3 {
      selectedPolygon.isClosed = false
    }
  }

  func updateVertex(at index: Int, to location: CGPoint) {
    selectedPolygon.vertices[index] = location
  }

  func indexOfVertex(for location: CGPoint) -> Int? {
    selectedPolygon.vertices.firstIndex(where: { $0.distance(to: location) <  Constant.vertexRadius * 1.5 })
  }

  func tapForward() {
    if canGoForward {
      selectedPolygonIndex += 1
    } else {
      polygons.append(polygons.last?.makeCopy() ?? .init())
      selectedPolygonIndex += 1
    }
  }

  func tapBack() {
    guard canGoBack else { return }
    selectedPolygonIndex -= 1
  }

  func select(id: UUID) {
    guard let index = polygons.firstIndex(where: { $0.id == id }) else { return }
    selectedPolygonIndex = index
  }

}
