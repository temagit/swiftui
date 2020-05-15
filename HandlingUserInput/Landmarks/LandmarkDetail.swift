//
//  ContentView.swift
//  Landmarks
//
//  Created by Tema.Tian on 2020/5/15.
//  Copyright © 2020 Tema.Tian. All rights reserved.
//

import SwiftUI

struct LandmarkDetail: View {
  
  @EnvironmentObject var userData: UserData
  var landmark: Landmark
  
  var landmarkIndex: Int {
    userData.landmarks.firstIndex(where: {$0.id == landmark.id}) ?? 0
  }
  
  var body: some View {
    VStack {
      MapView(locationCoordinate: landmark.locationCoordinate)
        .frame(height: 300)
        .edgesIgnoringSafeArea(.top)
      
      CircleImage(image: landmark.image)
        .offset(y: -130)
        .padding(.bottom, -130)
      
      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          Text(landmark.name)
            .font(.title)
          Button(action: {
            self.userData.landmarks[self.landmarkIndex].isFavorite.toggle()
          }) {
            if (userData.landmarks[landmarkIndex].isFavorite) {
              Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            } else {
              Image(systemName: "star")
                .foregroundColor(.gray)
            }
          }
        }
        HStack(alignment: .top) {
          Text(landmark.park)
            .font(.subheadline)
          Spacer()
          Text(landmark.state)
            .font(.subheadline)
        }
      }
      .padding()
      Spacer()
    }
    .navigationBarTitle(Text(landmark.name), displayMode: .inline)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    LandmarkDetail(landmark: landmarkData[1])
//      .environmentObject(UserData())
  }
}


