//
//  File.swift
//  UnsplashApp
//
//  Created by Oleksandr Kachkin on 09.06.2022.
//

import Foundation

struct PostUserProfileImage: Codable {
  let medium: String
}

struct PostUser: Codable {
  let profile_image: PostUserProfileImage
}

struct PostUrls: Codable {
  let regular: String
}

struct Post: Codable {
  let id: String
  let description: String?
  let user: PostUser
  let urls: PostUrls
}
