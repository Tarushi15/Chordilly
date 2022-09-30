//
//  ChordillyApp.swift
//  Chordilly
//
//  Created by Tarushi Goyal on 01/07/21.
//

import SwiftUI

@main
struct ChordillyApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(viewModel: SongListViewModel())
        }
    }
}
