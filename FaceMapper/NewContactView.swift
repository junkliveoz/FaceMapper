//
//  NewContact.swift
//  FaceMapper
//
//  Created by Adam on 23/8/2024.
//

import PhotosUI
import SwiftData
import SwiftUI


struct NewContact: View {
    @Binding var isPresented: Bool
    
    @State private var viewModel: NewContactViewModel
    
    init(isPresented: Binding<Bool>, modelContext: ModelContext) {
        self._isPresented = isPresented
        self._viewModel = State(initialValue: NewContactViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(selection: $viewModel.selectedImage) {
                    if let selectedImageData = viewModel.selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                    } else {
                        ContentUnavailableView("Add Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: viewModel.selectedImage) { oldValue, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            viewModel.selectedImageData = data
                        }
                    }
                }
                
                
                Form {
                    TextField("Name", text: $viewModel.name)
                    // If you have a custom textInput function, use it here instead
                    // textInput("Name", $name)
                }
                
            }
            .navigationTitle("New Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveContact()
                        isPresented = false
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }
        }
    }
}

#Preview {
    NewContact(isPresented: .constant(true), modelContext: ModelContext(try! ModelContainer(for: Contact.self)))
}
