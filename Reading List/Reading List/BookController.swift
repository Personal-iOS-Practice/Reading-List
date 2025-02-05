//
//  BookController.swift
//  Reading List
//
//  Created by Waseem Idelbi on 5/19/22.
//  Copyright © 2022 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class BookController {
    
//MARK: - Properties
    //All Books
    var books: [Book] = []
    //Read Books
    var readBooks: [Book] {
        var readBooks = books.filter { $0.hasBeenRead }
        readBooks.sort()
        return readBooks
    }
    //Unread Books
    var unreadBooks: [Book] {
        var unreadBooks = books.filter { !$0.hasBeenRead }
        unreadBooks.sort()
        return unreadBooks
    }
    //URL where the user's books will be saved to persist
    var readingListURL: URL? {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documents.appendingPathComponent("ReadingList.plist")
    }
    
//MARK: - Methods
    
    //MARK: CRUD Methods
    //Save
    func saveToPersistentStore() {
        let encoder = PropertyListEncoder()
        guard let url = readingListURL else { return }
        
        do {
            let data = try encoder.encode(books)
            try data.write(to: url)
        } catch {
            print("ERROR! Could not save books, error code: \(error)")
        }
    }
    //Load
    func loadFromPersistentStore() {
        do {
            let decoder = PropertyListDecoder()
            guard let url = readingListURL else { return }
            let data = try Data(contentsOf: url)
            let decodedBooks = try decoder.decode([Book].self, from: data)
            self.books = decodedBooks
        } catch {
            print("ERROR! Could not retrieve books, error code: \(error)")
        }
    }
    //Create
    func newBook(title: String, reasonToRead: String, image: UIImage?) {
        var newBook = Book(title: title, reasonToRead: reasonToRead)
        if let image = image {
            newBook.image = CodableImage(withImage: image)
        }
        books.append(newBook)
        saveToPersistentStore()
    }
    //Delete
    func removeBook(_ book: Book) {
        guard let index = books.firstIndex(of: book) else {
            print("Book not found")
            return
        }
        books.remove(at: index)
        saveToPersistentStore()
    }
    //Update
    func updateHasBeenRead(for book: inout Book) {
        guard let index = books.firstIndex(of: book) else { return }
        books.remove(at: index)
        book.hasBeenRead.toggle()
        books.insert(book, at: index)
        saveToPersistentStore()
    }
    func updateBook(book: inout Book, newTitle: String, newReasonToRead: String, image: UIImage?) {
        guard let index = books.firstIndex(of: book) else { return }
        books.remove(at: index)
        book.title = newTitle
        book.reasonToRead = newReasonToRead
        if let image = image {
            book.image = CodableImage(withImage: image)
        }
        books.insert(book, at: index)
        saveToPersistentStore()
    }
    
} //End of class
