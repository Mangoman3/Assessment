//
//  Constants.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/23/22.
//

import SwiftUI
import Kingfisher

struct ExerciseImageView: View {
    let url: String
    var body: some View {
        HStack(spacing: 24.0) {
            KFImage(url.url)
                .resizable()
                .placeholder { Image("img") }
                .frame(width: 80.0, height: 80.0)
                .shadow(color: .gray, radius: 10.0, x: 4.0, y: 4.0)
        }
    }
}
 

struct ExerciseImageView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseImageView(url: "")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
