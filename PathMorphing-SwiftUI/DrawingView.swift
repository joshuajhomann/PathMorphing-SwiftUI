//
//  ContentView.swift
//  PathMorphing-SwiftUI
//
//  Created by Joshua Homann on 8/21/20.
//

import SwiftUI

struct DrawingView: View {
  @EnvironmentObject private var viewModel: DrawingViewModel
  @State private var dragStartTime: Date?
  @State private var indexOfPointBeingDragged: Int?
  @State private var isAnimating: Bool = false
  @State private var proportion: CGFloat = 0
  var body: some View {
    ZStack {
      if isAnimating {
        InterpolatedPolygon(polygons: viewModel.polygons, proportion: proportion)
          .fill(Color.green)
          .opacity(0.6)
      }
      else {
        Grid().stroke(Color.gray, lineWidth: 1)
        ForEach(viewModel.previousPolygons) { polygon in
          if polygon.isClosed {
            polygon.makePath().fill(Color.gray).opacity(0.2)
          } else {
            polygon.makePath().stroke(Color.gray, lineWidth: 4).opacity(0.2)
          }
        }
        if viewModel.selectedPolygon.isClosed {
          viewModel.selectedPolygon.makePath().fill(Color.blue).opacity(0.5)
        } else {
          viewModel.selectedPolygon.makePath().stroke(Color.blue, lineWidth: 4)
        }
        viewModel.selectedPolygon.vertices.first.map {
          VertexShape(vertices: [$0], vertexRadius: DrawingViewModel.Constant.vertexRadius)
            .fill(Color.red)
            .opacity(0.6)
        }
        VertexShape(
          vertices: Array(viewModel.selectedPolygon.vertices.dropFirst()),
          vertexRadius: DrawingViewModel.Constant.vertexRadius
        )
        .fill(Color.yellow)
        .opacity(0.6)
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        HStack {
          Button {
            viewModel.tapBack()
          } label: {
            Image(systemName: "backward.frame")
          }
          .disabled(!viewModel.canGoBack || isAnimating)
          Button {
            viewModel.tapForward()
          } label: {
            Image(systemName: viewModel.canGoForward
                    ? "forward.frame"
                    : "plus.circle"
            )
          }
          .disabled(isAnimating)
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          isAnimating.toggle()
          proportion = 0
          withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            proportion = 1
          }
        } label: {
          Image(systemName: "playpause.fill")
        }
      }
    }
    .navigationBarTitle("Path Animation", displayMode: .inline)
    .gesture(DragGesture(minimumDistance: 0)
              .onChanged({ value in
                dragStartTime = dragStartTime ?? value.time
                if let index = indexOfPointBeingDragged {
                  viewModel.updateVertex(at: index, to: value.location)
                } else {
                  indexOfPointBeingDragged = viewModel.indexOfVertex(for: value.startLocation)
                }
              })
              .onEnded({ value in
                defer {
                  dragStartTime = nil
                  indexOfPointBeingDragged = nil
                }
                guard let startTime = dragStartTime,
                      value.time.timeIntervalSince(startTime) < 0.25 &&
                        abs(value.translation.width) < 2 &&
                        abs(value.translation.height) < 2 else {
                  return
                }
                viewModel.tap(value.startLocation)
              })
    )
  }
}

struct DrawingView_Previews: PreviewProvider {
  static var previews: some View {
    DrawingView()
  }
}
