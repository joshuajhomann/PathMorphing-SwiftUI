//
//  Shapes.swift
//  PathMorphing-SwiftUI
//
//  Created by Joshua Homann on 8/22/20.
//

import SwiftUI

struct Grid: Shape {
  let gridSpacing: CGFloat = 24
  func path(in rect: CGRect) -> Path {
    Path { path in
      stride(from: 0, to:rect.width, by: gridSpacing).forEach { x in
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: rect.height))
      }
      stride(from: 0, to: rect.height, by: gridSpacing).forEach { y in
        path.move(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: rect.width, y: y))
      }
    }
  }
}

struct VertexShape: Shape {
  var vertices: [CGPoint]
  let vertexRadius: CGFloat
  func path(in rect: CGRect) -> Path {
    Path { path in
      vertices
        .map { point in
          CGRect(
            x: point.x - vertexRadius,
            y: point.y - vertexRadius,
            width: vertexRadius * 2,
            height: vertexRadius * 2
          )
        }
        .forEach { path.addEllipse(in: $0) }
    }
  }
}

struct ScaledPolygon: View {
  var polygon: Polygon
  var body: some View {
    GeometryReader { geometry in
      polygon.makePath().scale(scale(for: geometry.frame(in: .local))).fill()
    }
  }
  private func scale(for rect: CGRect) -> CGFloat {
    let maxX = polygon.vertices.max(by: { $0.x < $1.x })?.x ?? 0
    let maxY = polygon.vertices.max(by: { $0.y < $1.y })?.y ?? 0
    return min(rect.width / maxX, rect.height / maxY)
  }
}

struct InterpolatedPolygon: Shape {
  var polygons: [Polygon]
  var proportion: CGFloat
  var animatableData: CGFloat {
    get { proportion }
    set { proportion = newValue }
  }

  func path(in rect: CGRect) -> Path {
    let fractionalIndex = proportion * CGFloat(polygons.count - 1)
    let lowerIndex = floor(fractionalIndex)
    let upperIndex = ceil(fractionalIndex)
    let intraPolygonProportion = fractionalIndex - lowerIndex
    let source = polygons[Int(lowerIndex)]
    let destination = polygons[Int(upperIndex)]
    return Path { path in
      let lines = [CGPoint].lerp(from: source.vertices, to: destination.vertices, by: intraPolygonProportion)
      if lines.count > 1 {
        path.addLines(lines)
      }
      if source.isClosed && destination.isClosed {
        path.closeSubpath()
      }
    }
  }
}

