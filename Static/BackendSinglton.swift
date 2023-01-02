//
//  BackendSinglton.swift
//  SuperSearch
//
//  Created by Clarke Kent on 1/1/23.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class BackendSinglton {
    private init () {}
    static var s = BackendSinglton()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let auth = Auth.auth()
    var userId : String?
    var userProfileImage : UIImage?
    var userBackgroundImage : UIImage?
    
    func checkIfSignedIn() {
        auth.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.userId = user!.uid
            }
        }
    }
    
    func SignUp(email : String, password : String) {
        auth.createUser(withEmail: email, password: password)
        { authResult, error in
            if let user = authResult?.user {
                self.userId = user.uid
            }
        }
    }
        
    func SignIn(email : String, password : String) {
        auth.signIn(withEmail: email, password: password)
        { authResult, error in
            if let user = authResult?.user {
                self.userId = user.uid
            }
        }
    }
    
    func SignOut() {
        // https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html
        do {
            try auth.signOut()
        } catch {
            print("Error While Attepting to Sign Out")
        }
    }
    
    func uploadImage(imageType : userImageType, image : UIImage) {
        if userId != nil {
            let imagePath : String = (imageType == userImageType.userProfileImage) ? AppConstants.s.profileImagePath : AppConstants.s.userbackgroundImagePath
            let storageRef = storage.reference().child("\(imagePath)/\(userId!)")
            let compressionQuality : CGFloat = (imageType == userImageType.userProfileImage) ? 0.1 : 0.85
            let data = image.jpegData(compressionQuality: compressionQuality)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            print("userId = \(userId)")
            print("storageRef = \(storageRef)")
            print("Image Data = \(data)")
            if data != nil {
                storageRef.putData(data!, metadata: nil) { (metadata, error) in
                    print("\(error)")
                    guard let metadata = metadata else {
                      return
                    }
                    let size = metadata.size
                    storageRef.downloadURL { (url, error) in
                      guard let downloadURL = url else {
                        return
                      }
                    }
                }
            }
        }
    }
        
    func getImage(imageType : userImageType) {
        if userId != nil {
            let imagePath : String = (imageType == userImageType.userProfileImage) ? AppConstants.s.profileImagePath : AppConstants.s.userbackgroundImagePath
            let storageRef = storage.reference().child("\(imagePath)/\(userId!)")
            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
              if let error = error {
                  print(error)
              } else {
                  if imageType == userImageType.userProfileImage {
                      self.userProfileImage = UIImage(data: data!)
                  } else {
                      self.userBackgroundImage = UIImage(data: data!)
                  }
              }
            }
        }
    }
}

enum userImageType {
    case userProfileImage
    case userBackgroundImage
}
