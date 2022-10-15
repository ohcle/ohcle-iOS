//
//  ReadViewSize.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/15.
//

import Foundation
import SwiftUI

struct GeometryGetterMod: ViewModifier {
    
    @Binding var rect: CGRect
    
    func body(content: Content) -> some View {
        print(content)
        return GeometryReader { (g) -> Color in // (g) -> Content in - is what it could be, but it doesn't work
            DispatchQueue.main.async { // to avoid warning
                self.rect = g.frame(in: .global)
            }
            return Color.clear // return content - doesn't work
        }
    }
}

struct ContentView: View {
    @State private var rect1 = CGRect()
    var body: some View {
        let t = HStack {
            // make two texts equal width, for example
            // this is not a good way to achieve this, just for demo
            Text("Long text").overlay(Color.clear.modifier(GeometryGetterMod(rect: $rect1)))
            // You can then use rect in other places of your view:

            Text("text").frame(width: rect1.width, height: rect1.height).background(Color.green)
            Text("text").background(Color.yellow)
        }
        print(rect1)
        return t
    }
}

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

private struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
