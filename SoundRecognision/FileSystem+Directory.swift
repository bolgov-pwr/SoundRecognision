//
//  FileSystem+Directory.swift
//  SoundRecognision
//
//  Created by Ivan Bolhov on 17.06.2022.
//

import Foundation

extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
