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
      if true {
        return Color.red
      } else {
        return Text("")
      }
    }
  }
}

extension View {
  func eraseToAnyView() -> AnyView {
    AnyView(self)
  }
}

