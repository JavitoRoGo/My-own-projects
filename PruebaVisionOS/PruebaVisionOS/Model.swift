//
//  Model.swift
//  VarianteTutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 18/6/23.
//

import Foundation

struct Empleado: Codable, Identifiable, Hashable {
    let id: Int
    let username, firstName, lastName: String
    let gender: Gender
    let email: String
    let department: Department
    let address: String
    let avatar: URL
    let zipcode: String?

    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName = "first_name"
        case lastName = "last_name"
        case gender, email, department, address, avatar, zipcode
    }
}

enum Department: String, Codable {
    case accounting = "Accounting"
    case businessDevelopment = "Business Development"
    case engineering = "Engineering"
    case humanResources = "Human Resources"
    case legal = "Legal"
    case marketing = "Marketing"
    case productManagement = "Product Management"
    case researchAndDevelopment = "Research and Development"
    case sales = "Sales"
    case services = "Services"
    case support = "Support"
    case training = "Training"
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
}

extension Empleado {
    static let test = Empleado(id: 1, username: "pperez", firstName: "Pepito", lastName: "Pérez", gender: .male, email: "pperez@pperez.es", department: .engineering, address: "Su casa", avatar: URL(string: "https://robohash.org/solutaeadolor.png")!, zipcode: nil)
}
