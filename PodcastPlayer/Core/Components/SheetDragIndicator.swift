//
//  SheetDragIndicator.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI

struct SheetDragIndicator: View {
    var body: some View {
        Capsule()
            .fill(.secondary.opacity(0.4))
            .frame(width: 36, height: 5)
            .padding(.top, 10)
            .padding(.bottom, 6)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    SheetDragIndicator()
}
