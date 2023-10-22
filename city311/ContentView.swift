//
//  ContentView.swift
//  city311
//
//  Created by Alexandria Rohn on 10/22/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var vm = ViewModel()
  
  var body: some View {
    IssuesGrid(vm: self.vm)
      .padding(.top)
      .padding(.top)
      .sheet(isPresented: self.$vm.showChatSheet) {
        Text("Hello world")
      }
    
    Spacer()
  }
}

struct ChatSheetView: View {
  @ObservedObject var vm: ViewModel
  @State private var inputText = ""
  
  var body: some View {
    TextField("Enter details about the issue", text: self.$inputText, axis: .vertical)
      .textFieldStyle(.roundedBorder)
      .lineLimit(5)
      .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
      .padding()
      .onSubmit {
        self.vm.onSubmitMessage(self.inputText)
      }
  }
}

#Preview {
  ContentView()
}
