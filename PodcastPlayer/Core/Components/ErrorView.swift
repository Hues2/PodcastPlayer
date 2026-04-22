//
//  ErrorView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI

struct ErrorView: View {
    let error: AppError
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 12) {
            if let title = error.errorTitle {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }

            if let description = error.errorDescription {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let action {
                Button(action: action) {
                    Text("Try Again")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            }
        }
        .padding()
    }
}

#Preview("With action") {
    ErrorView(error: .default) {
        print("Retry tapped")
    }
}

#Preview("Without action") {
    ErrorView(error: .noPodcastsAvailable)
}
