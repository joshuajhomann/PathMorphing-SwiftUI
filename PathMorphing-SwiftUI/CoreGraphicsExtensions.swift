//
//  CoreGraphicsExtensions.swift
//  PathMorphing-SwiftUI
//
//  Created by Joshua Homann on 8/22/20.
//

import CoreGraphics

protocol Interpolatable {
  associatedtype Interpolated
  associatedtype Ratio
  static func lerp(from: Interpolated, to: Interpolated, by: Ratio) -> Interpolated
}

extension Interpolatable where Interpolated: BinaryFloatingPoint, Ratio == Interpolated {
  static func lerp(from: Interpolated, to: Interpolated, by: Ratio) -> Interpolated {
    from + (to - from) * by
  }
}

extension CGFloat: Interpolatable {
  public typealias Interpolated = Self
  public typealias Ratio = Self
}

extension CGPoint: Interpolatable {
  static func lerp(from source: CGPoint, to destination: CGPoint, by proportion: CGFloat) -> CGPoint {
    .init(
      x: CGFloat.lerp(from: source.x, to: destination.x, by: proportion),
      y: CGFloat.lerp(from: source.y, to: destination.y, by: proportion)
    )
  }
}

extension Array: Interpolatable where Element == CGPoint {
  static func lerp(from source: [CGPoint], to destination: [CGPoint], by proportion: CGFloat) -> [CGPoint] {
    guard source.count > 0 && destination.count > 0 else { return []}
    let count = Swift.max(source.count, destination.count)
    return (0..<count).map { index in
      CGPoint.lerp(
        from: source[index % source.count],
        to: destination[index % destination.count],
        by: proportion
      )
    }
  }
}


extension CGPoint {
  func distance(to point: CGPoint) -> CGFloat {
    hypot(x-point.x, y-point.y)
  }
}
