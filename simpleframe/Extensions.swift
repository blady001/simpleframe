//
//  Extensions.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 06/10/2021.
//

import SwiftUI

extension View {
    func banner(data: Binding<BannerModifier.BannerData>, show: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(data: data, show: show))
    }
}

extension Color {
    func forcedCgColor() -> CGColor {
        UIColor(self).cgColor
    }
}
