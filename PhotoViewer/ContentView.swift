//
//  ContentView.swift
//  PhotoViewer
//
//  Created by Mark DiFranco on 2024-05-06.
//

import SwiftUI

struct ContentView: View {

    //Current Value of Gestures
    @GestureState private var isDragging: CGSize = .zero
    @GestureState private var magnifyAmount:  CGFloat = 1
    @GestureState private var rotateAmount: Angle = .degrees(0.0)
    
    //Initial State of Image
    @State private var offSet: CGSize = .zero
    @State private var scale: CGFloat = 1
    @State private var rotation: Angle = .degrees(0)
    
    
    //DragGesture
    var dragGesture: some Gesture{
        DragGesture()
            .updating($isDragging) { value, state, _ in
                state = value.translation
            }
            .onEnded{value in
                offSet = CGSize (
                    width: offSet.width + value.translation.width,
                    height: offSet.height + value.translation.height
                )
            }
    }
    
    //Magnify
    var magnifyGesture: some Gesture {
        MagnifyGesture()
            .updating($magnifyAmount){
                value, state, _ in state = value.magnification
            }
          
            .onEnded { value in
                scale *= value.magnification
            }
    }
    
    //Rotation Gesture
    var rotationGesture: some Gesture {
        RotateGesture()
            .updating($rotateAmount) {
                value, state, _ in
                state = value.rotation
            }
        
            .onEnded{ value in
                rotation += value.rotation
                
            }
    }
    
    var body: some View {
        VStack {
            Image(.cliffside)
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                // add gestures here
                // Add Drag, Pinch, Rotate gestures
                // Use .simultanesousGesture when using
                // multiple gestueres
                .offset(
                    x: offSet.width + isDragging.width,
                    y: offSet.height + isDragging.height
                )
                .scaleEffect(scale * magnifyAmount)
                .rotationEffect(rotation + rotateAmount)
                .simultaneousGesture(dragGesture)
                .simultaneousGesture(magnifyGesture)
                .simultaneousGesture(rotationGesture)
            
        }
    }
}

#Preview {
    ContentView()
}
