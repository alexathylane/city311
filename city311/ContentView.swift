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
  @FocusState private var isFocused: Bool
  
  var body: some View {
    ScrollViewReader { proxy in
      List {
        ForEach(self.vm.messages) { message in
          MessageView(message: message)
            .id(message.id)
        }
      }
      .listStyle(.plain)
      .onChange(of: self.vm.messages) { oldValue, newValue in
        guard let lastMessage = newValue.last else { return }
        withAnimation {
          proxy.scrollTo(lastMessage.id)
        }
      }
    }
    
    Spacer()
    
    HStack {
      TextField("Enter details about the issue", text: self.$inputText, axis: .vertical)
        .focused($isFocused)
        .onAppear {
          DispatchQueue.main.async {
            self.isFocused = true
          }
        }
        .textFieldStyle(.roundedBorder)
        .lineLimit(4)
        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
        .padding()
        .onChange(of: self.inputText) { input in
          if input.last == "\n" {
            self.vm.onSubmitMessage(self.inputText)
            self.inputText = ""
          }
        }
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
        let name = message.userId.contains("City") ? "🤖 \(message.userId)" : message.userId
        Text(name)
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
