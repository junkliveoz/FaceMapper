//
//  M_Contact.swift
//  FaceMapper
//
//  Created by Adam on 23/8/2024.
//

import Foundation
import SwiftData

@Model
final class Contact {
    @Attribute(.unique) let id: UUID
    var name: String
    @Attribute(.externalStorage) var photoData: Data?
    
    init(id: UUID = UUID(), name: String, photoData: Data?) {
        self.id = id
        self.name = name
        self.photoData = photoData
    }
}

extension Contact: Comparable {
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        lhs.name < rhs.name
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}
