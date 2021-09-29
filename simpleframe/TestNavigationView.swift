//
//  TestNavigationView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 28/09/2021.
//

import SwiftUI

struct TestNavigationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingDismissAlert = false
    
    var body: some View {
        VStack {
            Text("In the second view!")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    showingDismissAlert.toggle()
                } label: {
                    Image(systemName: "chevron.backward").imageScale(.large)
                }
            }
        }
        .alert(isPresented: $showingDismissAlert) {
            Alert(
                title: Text("Dismiss?"),
                primaryButton: .default(Text("Cancel")),
                secondaryButton: .destructive(Text("Ok")) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct TestNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TestNavigationView()
    }
}
