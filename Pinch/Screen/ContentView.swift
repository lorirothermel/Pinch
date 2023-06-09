//
//  ContentView.swift
//  Pinch
//
//  Created by Lori Rothermel on 6/7/23.
//

import SwiftUI

struct ContentView: View {
    // MARK: Property
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    @State private var pageIndex: Int = 1
    
    let pages: [Page] = pagesData
    
    
    // MARK: Function
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }  // withAnimation
        
    }  // resetImageState
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }  // currentPage
    
    
    // MARK: Content
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.clear
                
                // MARK: Page Image
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                // MARK: 1 - Double Tap Gesture
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }  // withAnimation
                        } else {
                           resetImageState()
                        }  // if
                    })  // .onTapGesture
                // MARK: 2 - Drag Gesture
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation
                                }  // withAnimation
                            }  // .onChanged
                            .onEnded({ _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }  // if
                            })
                    )  // .gesture
                // MARK: 3 - Magnification
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }  // if
                                }  // withAnimation
                            })  // .onChanged
                            .onEnded({ _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }  // if
                            })  // .onEnded
                    )  // .gesture
            }  // ZStack
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1.5)) {
                    isAnimating = true
                }  // withAnimation
            }  // .onAppear
            
            // MARK: - Info Panel
            .overlay(alignment: .top) {
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
            }  // .overlay
            
            // MARK: - Controls
            .overlay(alignment: .bottom) {
                Group {
                    HStack {
                        // Scale Down
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                }  // if
                                
                                if imageScale <= 1 {
                                    resetImageState()
                                }  // if
                            }  // withAnimation
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }  // Button - Scale Down

                        // Reset
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }  // Button - Reset
                        
                        // Scale Up
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                }  // if
                                
                                if imageScale > 5 {
                                    imageScale = 5
                                }  // if
                            }  // withAnimation
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }  // Button - Scale Up
                        
                    }  // HStack
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }  // Group
                .padding(.bottom)
            }  // .overlay
            
            // MARK: 4 - Drawer
            .overlay(alignment: .topTrailing) {
                HStack(spacing: 12) {
                    // MARK: - Drawer Handle
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation((.easeOut)) {
                                isDrawerOpen.toggle()
                            }  // withAnimation
                        }  // .onTapGesture
                    
                    // MARK: - Thumbnails
                    ForEach(pages) { item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = item.id
                                withAnimation(.easeOut(duration: 0.75)) {
                                    isDrawerOpen = false
                                }  // withAnimation
                            }  // .onTapGesture
                    }  // ForEach
                    
                    Spacer()
                }  // HStack
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, UIScreen.main.bounds.height / 12)
                .offset(x: isDrawerOpen ? 20 : 215)
            }  // .overlay
        }  // NavigationStack
        .navigationViewStyle(.stack)
        
    }  // some View
}  // ContentView



// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
