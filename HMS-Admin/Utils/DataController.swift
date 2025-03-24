//
//  DataController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 20/03/25.
//

import Foundation

struct Token: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user = "user"
    }

    var accessToken: String
    var tokenType: String = "bearer"
    var user: Admin?
}

struct UserLogin: Codable {
    enum CodingKeys: String, CodingKey {
        case emailAddress = "email_address"
        case password
    }

    var emailAddress: String
    var password: String
}

struct ServerResponse: Codable {
    var success: Bool
}

struct ChangePassword: Codable {
    enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case newPassword = "new_password"
    }

    var oldPassword: String
    var newPassword: String
}

class DataController {

    // MARK: Lifecycle

    private init() {
        Task {
            _ = await autoLogin()
        }
    }

    // MARK: Public

    public private(set) var admin: Admin?
    public private(set) var hospital: Hospital?

    // MARK: Internal

    @MainActor static let shared: DataController = .init()

    func login(emailAddress: String, password: String) async -> Bool {
        let userLogin = UserLogin(emailAddress: emailAddress, password: password)
        guard let userLoginData = userLogin.toData() else {
            fatalError("Could not convert userLogin to Data")
        }

        let token: Token? = await MiddlewareManager.shared.post(url: "/admin/login", body: userLoginData)
        guard let accessToken = token?.accessToken, let admin = token?.user else {
            return false
        }
        self.accessToken = accessToken
        self.admin = admin

        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(emailAddress, forKey: "emailAddress")
        UserDefaults.standard.set(password, forKey: "password")

        let hospital: Hospital? = await MiddlewareManager.shared.get(url: "/hospital/\(admin.id)")
        if let hospital {
            self.hospital = hospital
        }

        return true
    }

    func autoLogin() async -> Bool {
        guard let email = UserDefaults.standard.string(forKey: "emailAddress"),
              let password = UserDefaults.standard.string(forKey: "password") else {
            return false
        }

        return await login(emailAddress: email, password: password)
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }

    func changePassword(oldPassword: String, newPassword: String) async -> Bool {
        let changePassword = ChangePassword(oldPassword: oldPassword, newPassword: newPassword)
        guard let changePasswordData = changePassword.toData() else {
            fatalError("Could not change password: Invalid data")
        }

        let response: ServerResponse? = await MiddlewareManager.shared.patch(url: "/admin/change-password", body: changePasswordData)
        let success = response?.success ?? false

        if success {
            UserDefaults.standard.set(newPassword, forKey: "password")
        }
        return success
    }

    // MARK: Private

    private var accessToken: String = ""

}

extension DataController {
    func fetchDoctors() async -> [Staff]? {
        return await MiddlewareManager.shared.get(url: "/staff")
    }

    func addDoctor(_ doctor: Staff) async -> Staff? {
        guard let doctorData = doctor.toData() else {
            fatalError("Could not add doctor: Invalid data")
        }

        return await MiddlewareManager.shared.post(url: "/staff/create", body: doctorData)
    }
}
