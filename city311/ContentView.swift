//
//  ContentView.swift
//  city311
//
//  Created by Alexandria Rohn on 10/22/23.
//

import SwiftUI

struct ContentView: View {
  @State private var inputText = ""
  @StateObject private var vm = ViewModel()
  
  var body: some View {
    IssuesGrid(vm: self.vm)
      .padding(.top)
      .padding(.top)
    
    TextField("Enter details about the issue", text: self.$inputText, axis: .vertical)
      .opacity(vm.issueId != nil ? 1 : 0)
      .textFieldStyle(.roundedBorder)
      .lineLimit(5)
      .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
      .padding()
      .onSubmit {
        self.vm.onSubmitMessage(self.inputText)
      }
    
    Spacer()
  }
}

#Preview {
  ContentView()
}
