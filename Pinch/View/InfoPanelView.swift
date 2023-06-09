//
//  InfoPanelView.swift
//  Pinch

//
//  Created by Lori Rothermel on 6/8/23.
//

import SwiftUI

struct InfoPanelView: View {
    @State private var isInfoPanelVisable: Bool = false
    
    
    var scale: CGFloat
    var offset: CGSize
    
    
    
    var body: some View {
        HStack {
            // MARK - HOTSPOT
            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 30, height: 30)
                .onLongPressGesture(minimumDuration: 1) {
                    withAnimation(.easeOut) {
                        isInfoPanelVisable.toggle()
                    }  // withAnimation
                }  // .onLongPressGesture
            
            Spacer()
                        
            // MARK - INFO PANEL
            HStack(spacing: 2) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text("\(scale)")
                
                Spacer()
                
                Image(systemName: "arrow.left.and.right")
                Text("\(offset.width)")
                
                Spacer()
                
                Image(systemName: "arrow.up.and.down")
                Text("\(offset.height)")
                
                Spacer()
            }  // HStack
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .frame(maxWidth: 420)
            .opacity(isInfoPanelVisable ? 1 : 0)
            
            Spacer()
            
        }  // HStack
    }  // some View
}  // InfoPanelView

struct InfoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPanelView(scale: 1, offset: .zero)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
