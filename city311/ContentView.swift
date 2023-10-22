//
//  ContentView.swift
//  city311
//
//  Created by Alexandria Rohn on 10/22/23.
//

import SwiftUI

struct ContentView: View {
  @State private var inputText = ""
  
  var body: some View {
    IssuesGrid()
    TextField("Hello world", text: self.$inputText)
      .padding()
      .padding(.horizontal)
  }
}

#Preview {
  ContentView()
}
