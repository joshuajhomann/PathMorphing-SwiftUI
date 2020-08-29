//
//  PathMorphing_SwiftUIApp.swift
//  PathMorphing-SwiftUI
//
//  Created by Joshua Homann on 8/21/20.
//

import SwiftUI

@main
struct PathMorphing_SwiftUIApp: App {
  var body: some Scene {
    WindowGroup {
      RootView().environmentObject(DrawingViewModel())
    }
  }
}
