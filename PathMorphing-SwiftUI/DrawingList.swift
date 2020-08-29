//
//  DrawingList.swift
//  PathMorphing-SwiftUI
//
//  Created by Joshua Homann on 8/28/20.
//

import SwiftUI

struct DrawingList: View {
  @EnvironmentObject private var viewModel: DrawingViewModel
  var body: some View {
    List {
      ForEach(viewModel.polygons) { polygon in
        HStack {
          ScaledPolygon(polygon: polygon)
            .offset(x: -25, y: -25)
            .frame(width: 50, height: 50)
            .background(
              RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue)
            )
          if polygon.id == viewModel.selectedPolygon.id {
            TextField("Name your shape...", text: $viewModel.selectedPolygon.name)
              .font(.largeTitle)
          } else {
            Text(polygon.name)
              .font(.largeTitle)
          }
        }
        .onTapGesture {
          viewModel.select(id: polygon.id)
        }
        .listRowBackground(
          polygon.id == viewModel.selectedPolygon.id
            ? Color.green
            : Color.clear
        )
      }
    }
    .listStyle(GroupedListStyle())
    .navigationTitle("Shapes")
  }
}
