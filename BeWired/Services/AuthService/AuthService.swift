//
//  AuthService.swift
//  BeWired
//
//  Created by Dmitry Kononov on 5.05.23.
//

import UIKit
import TDLibKit


protocol AuthServiceProtocol {
    typealias AuthCompletion<T> = (Result<T, AuthError>) -> Void
    func setPhoneNumber(phoneNumber: String, completion: @escaping AuthCompletion<Void>)
    func confirmPhoneNumber(code: String?, completion: @escaping AuthCompletion<Void>)
    func logout(completion: @escaping AuthCompletion<Void>)
    func getCurrentUser(completion: @escaping AuthCompletion<User>)
    func getAuthorizationState(complition: @escaping AuthCompletion<AuthorizationState>)
}

final class AuthService: AuthServiceProtocol {

    private let mapper: AuthMapperProtocol
    
    private let client: TdClientImpl
    private let api: TdApi
    private let apiId = 29367234
    private let apiHash = "a249cc54fb71f1ec7765ad1def7dde10"
    
    init() {
        self.client = TdClientImpl()
        self.api = TdApi(client: client)
        self.mapper = AuthMapper()
        run()
        setLogVerbosityLevel()
        setTDLParameters()
    }
    
    func confirmPhoneNumber(code: String?, completion: @escaping AuthCompletion<Void>) {
        Task.init {
            do {
                _ = try await api.checkAuthenticationCode(code: code)
                completion(.success(()))
            } catch {
                completion(.failure(.confirmPhoneNumberError))
            }
        }
    }
    

   
    func setPhoneNumber(phoneNumber: String, completion: @escaping AuthCompletion<Void>) {
        Task.init {
            do {
                _ = try await api.setAuthenticationPhoneNumber(phoneNumber: phoneNumber, settings: nil)
                completion(.success(()))
            } catch {
                completion(.failure(.setPhoneNumberError))
            }
        }
    }
    
    func logout(completion: @escaping AuthCompletion<Void>) {
        Task.init {
            do {
                _ = try await api.logOut()
                completion(.success(()))
            } catch {
                completion(.failure(.logoutError))
            }
        }
    }
    
    func getCurrentUser(completion: @escaping AuthCompletion<User>) {
        Task.init {
            do {
                let tdUser = try await api.getMe()
                let user = mapper.map(user: tdUser)
                
                if let profilePhotoId = tdUser.profilePhoto?.big.id {
                    do {
                        let file = try await api.downloadFile(fileId: profilePhotoId, limit: 0, offset: 0, priority: 1, synchronous: true)
                        let filePath = file.local.path
                        let imageData = try Data(contentsOf: URL(fileURLWithPath: filePath))
                        user.profilePhotoData = imageData
                    } catch {
                        completion(.success(user))
                        return
                    }
                }
                completion(.success(user))
            } catch {
                completion(.failure(AuthError.getCurrentUserError))
            }
        }

    }
}

//MARK: - Private funcs
private extension AuthService {
    
    private func run() {
        api.client.run { _ in }
    }
    
    private func setTDLParameters() {
        try? api.setTdlibParameters(apiHash: apiHash,
                                    apiId: apiId,
                                    applicationVersion: "1.0",
                                    databaseDirectory: databaseDirectory(),
                                    databaseEncryptionKey: nil,
                                    deviceModel: "iOS",
                                    enableStorageOptimizer: true,
                                    filesDirectory: "",
                                    ignoreFileNames: true,
                                    systemLanguageCode: "en",
                                    systemVersion: "Unknown",
                                    useChatInfoDatabase: true,
                                    useFileDatabase: true,
                                    useMessageDatabase: true,
                                    useSecretChats: true,
                                    useTestDc: false) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func databaseDirectory() -> String? {
        let cachesUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let tdlibPath = cachesUrl?.appendingPathComponent("tdlib", isDirectory: true).path
        return tdlibPath
    }
    
    private func setLogVerbosityLevel() {
        // по умолчанию начинает спамить в консоль о всех событиях TDLib
        //0 - fatal errors, 1 - errors, 2 - warnings and debug warnings, 3 - informational, 4 - debug, 5 - verbose debug, greater than 5 and up to 1023 can be used to enable even more logging.
        do {
            try api.setLogVerbosityLevel(newVerbosityLevel: 1) { _ in }
        } catch {
            print(AuthError.setLogVerbosityLevelError.localizedDescription)
        }
    }
    
   private func getProfilePhoto(profilePhotoId: Int, completion: @escaping ((UIImage?) -> Void)) {
        Task.init {
            do {
                guard let file = try? await api.downloadFile(fileId: profilePhotoId, limit: 0, offset: 0, priority: 1, synchronous: true),
                      let imageData = try? Data(contentsOf: URL(fileURLWithPath: file.local.path))
                else {  return }
                
                let image = UIImage(data: imageData)
                completion(image)
                
            }
        }
    }
}

// MARK: Get Authorization state

extension AuthService {
    
    func getAuthorizationState(complition: @escaping AuthCompletion<AuthorizationState>) {
        Task.init() {
            do {
                let state = try await api.getAuthorizationState()
                complition(.success(state))
            } catch {
                complition(.failure(.autorizationStateError))
            }
        }
    }
    
}
