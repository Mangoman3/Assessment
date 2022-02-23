//
//  Constants.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/23/22.
//

import SwiftUI
import Kingfisher

struct ExerciseView: View {
    let model: ExerciseViewModel
    var body: some View {
        HStack(spacing: 25.0) {
            KFImage(model.url.url)
                .resizable()
                .placeholder { Image("img") }
                .frame(width: 80.0, height: 80.0)
            VStack(alignment: .leading, spacing: 4.0) {
                Text( model.name)
                    .font(.headline)
                    .font(.caption)
            }
            Spacer()
        }
    }
}
 

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView(model: ExerciseViewModel(name: "Pullups", url: "img"))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
