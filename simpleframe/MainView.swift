//
//  MainView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 28/09/2021.
//

import SwiftUI

struct MainView: View {
    @State private var imageSelected = false
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView()
//                    .background(Rectangle().fill(Color.red))
                Spacer()
                
                Button {
                    imageSelected.toggle()
                } label: {
                    VStack {
                        Image(systemName: "plus.viewfinder")
                            .font(.system(size: 64, weight: .thin))
                        Text("Choose image")
                    }
                }
//                .background(Rectangle().fill(Color.green))
                
                Spacer()
                
                NavigationLink(isActive: $imageSelected) {
                    TestNavigationView()
                } label: {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
//            .navigationTitle("SimpleFrame")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .bottomBar) {
//                    Button {
//                        print("abc")
//                    } label: {
//                        Image(systemName: "info.circle")
//                    }
//                }
//            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
