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
        ChatSheetView(vm: self.vm)
      }
    
    Spacer()
  }
}

struct ChatSheetView: View {
  @ObservedObject var vm: ViewModel
  @State private var inputText = ""
  
  var body: some View {
    List {
      ForEach(self.vm.messages) { message in
        MessageView(message: message)
      }
    }
    .listStyle(.plain)
    
    Spacer()
    
    HStack {
      TextField("Enter details about the issue", text: self.$inputText, axis: .vertical)
        .textFieldStyle(.roundedBorder)
        .lineLimit(4)
        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
        .padding()
        .onSubmit {
          self.vm.onSubmitMessage(self.inputText)
        }
      
      if self.vm.isFetchingMessages {
        ProgressView()
          .progressViewStyle(.circular)
          .padding(.trailing)
      }
    }
  }
}

struct MessageView: View {
  let message: Message
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(message.userId)
          .font(.footnote)
          .bold()
        
        Text(message.text)
          .font(.body)
      }
      
      Spacer()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
