//
//  DocumentPickerTest.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 16/09/2023.
//

import Foundation
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var fileContent: String
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(fileContent: $fileContent)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let controller: UIDocumentPickerViewController
        controller = UIDocumentPickerViewController(forOpeningContentTypes: [.text, .pdf, .folder, .jpeg, .png, .gif, .exe, .data], asCopy: true)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    @Binding var fileContent: String
    
    init(fileContent: Binding<String>) {
        _fileContent = fileContent
    }
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let fileURL = urls[0]

        guard fileURL.startAccessingSecurityScopedResource() else {
            // Handle denied access
            return
        }
        defer { fileURL.stopAccessingSecurityScopedResource() }

        do {
            fileContent = try String(contentsOf: fileURL, encoding: .utf8)
            print("The URL::::: \(fileURL)::::::::")
        } catch let error {
            print("error: \(error)")
        }
    }
}
