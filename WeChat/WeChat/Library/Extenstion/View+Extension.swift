//
//  View+Extension.swift
//  WeChat
//
//  Created by Tema.Tian on 2020/5/19.
//  Copyright © 2020 Tema.Tian. All rights reserved.
//

import SwiftUI

extension View {

  func navigationLink<Destination: View>(destination: Destination) -> some View {
    background(NavigationLink(destination: destination) {
        EmptyView()
      }
        .frame(width: 0, height: 0)
        .opacity(0))
  }
}

