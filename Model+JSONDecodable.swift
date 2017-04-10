//
//  Model+JSONDecodable.swift
//  Placeholder
//
//  Created by Todd Olsen on 4/6/17.
//  Copyright © 2017 proxpero. All rights reserved.
//

extension User: JSONDecodable {

    public init?(json: JSONDictionary) {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let username = json["username"] as? String,
            let email = json["email"] as? String,
            let addressDict = json["address"] as? JSONDictionary, let address = Address(json: addressDict),
            let phone = json["phone"] as? String,
            let website = json["website"] as? String,
            let companyDict = json["company"] as? JSONDictionary, let company = Company(json: companyDict)
            else { return nil }
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }

}

extension User.Address: JSONDecodable {

    public init?(json: JSONDictionary) {
        guard
            let street = json["street"] as? String,
            let suite = json["suite"] as? String,
            let city = json["city"] as? String,
            let zipcode = json["zipcode"] as? String,
            let geoDict = json["geo"] as? JSONDictionary, let geo = Geo(json: geoDict)
            else { return nil }
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = geo
    }

}

extension User.Address.Geo: JSONDecodable {

    public init?(json: JSONDictionary) {
        guard let lat = json["lat"] as? String, let lng = json["lng"] as? String else { return nil }
        self.lat = lat
        self.lng = lng
    }

}

extension User.Company: JSONDecodable {

    public init?(json: JSONDictionary) {
        guard let name = json["name"] as? String,
            let catchPhrase = json["catchPhrase"] as? String,
            let bs = json["bs"] as? String
            else { return nil }
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs 
    }
    
}

extension Album: JSONDecodable {

    public init?(json: JSONDictionary) {
        guard
            let userId = json["userId"] as? Int,
            let id = json["id"] as? Int,
            let title = json["title"] as? String
        else { return nil }
        self.userId = userId
        self.id = id
        self.title = title
    }

}

extension Photo: JSONDecodable {

    public init?(json: JSONDictionary) {
        guard
            let id = json["id"] as? Int,
            let albumId = json["albumId"] as? Int,
            let title = json["title"] as? String,
            let url = json["url"] as? String,
            let thumbnailUrl = json["thumbnailUrl"] as? String
            else { return nil }
        self.id = id
        self.albumId = albumId
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }

}

extension Post: JSONDecodable {

    public init?(json: JSONDictionary) {
        guard
            let id = json["id"] as? Int,
            let userId = json["userId"] as? Int,
            let title = json["title"] as? String,
            let body = json["body"] as? String
            else { return nil }
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }

}

extension Comment: JSONDecodable {

    public init?(json: JSONDictionary) {
        guard
            let id = json["id"] as? Int,
            let postId = json["postId"] as? Int,
            let name = json["name"] as? String,
            let email = json["email"] as? String,
            let body = json["body"] as? String
            else { return nil }
        self.id = id
        self.postId = postId
        self.name = name
        self.email = email
        self.body = body
    }

}

extension Todo: JSONDecodable {

    public init?(json: JSONDictionary) {
        guard
            let id = json["id"] as? Int,
            let userId = json["userId"] as? Int,
            let title = json["title"] as? String,
            let isCompleted = json["completed"] as? Bool
            else { return nil }
        self.id = id
        self.userId = userId
        self.title = title
        self.isCompleted = isCompleted
    }

}
