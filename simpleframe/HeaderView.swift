//
//  HeaderView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 29/09/2021.
//

import SwiftUI

struct HeaderView: View {
    @State private var showingInfo = false
    
    var body: some View {
        HStack {
            Text("SimpleFrame").font(.system(size: 30, weight: .bold))
            Spacer()
            Button {
                showingInfo.toggle()
            } label: {
                Image(systemName: "info.circle")
                    .imageScale(.large)
            }
        }
        .padding()
        .alert(isPresented: $showingInfo) {
            Alert(title: Text("About"), message: Text("Text etc"), dismissButton: .default(Text("Ok")))
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
