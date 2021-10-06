//
//  BannerModifier.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 06/10/2021.
//

import SwiftUI

struct BannerModifier: ViewModifier {
    
    struct BannerData {
        var title: String
        var detail: String
        var type: BannerType
    }
    
    enum BannerType {
        case success
        case error
        
        var tintColor: Color {
            switch self {
            case .success:
                return Color.green
            case .error:
                return Color.red
            }
        }
    }
    
    @Binding var data: BannerData
    @Binding var show: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.detail)
                                .font(Font.system(size: 15, weight: .light, design: .default))
                        }
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(12)
                    .background(data.type.tintColor)
                    .cornerRadius(8)
//                    Spacer()
                }
                .padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            self.show = false
                        }
                    }
                })
                
            }
        }
    }
    
}
