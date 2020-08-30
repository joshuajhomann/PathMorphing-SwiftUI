//
//  RootView.swift
//  PathMorphing-SwiftUI
//
//  Created by Joshua Homann on 8/29/20.
//

import SwiftUI

struct RootView: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  var body: some View {
    Group {
      if horizontalSizeClass == .compact {
        TabView {
          NavigationView {
            DrawingList()
          }
          .tabItem {
            Image(systemName: "list.star")
            Text("Shapes")
          }
          NavigationView {
            DrawingView()
          }
          .tabItem {
            Image(systemName: "pencil.circle")
            Text("Draw")
          }
        }
      } else {
        NavigationView {
          DrawingList()
          DrawingView()
        }
      }
    }
  }
}

extension View {
  func eraseToAnyView() -> AnyView {
    AnyView(self)
  }
}

