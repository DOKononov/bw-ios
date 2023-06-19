
import UIKit
import TDLibKit


protocol AuthServiceProtocol {
    func setPhoneNumber(phoneNumber: String) async throws
    func confirmPhoneNumber(code: String?) async throws
    func logout() async throws
    func getCurrentUser() async throws -> User
    func getAuthorizationState() async throws -> AuthorizationState
    func startBot() async throws
    func checkTwoStepAuth(pass: String) async throws
}

final class AuthService: AuthServiceProtocol {
    
    private let mapper: AuthMapperProtocol
    private let client: TdClientImpl
    private let api: TdApi
    private let apiId = 29367234
    private let apiHash = "a249cc54fb71f1ec7765ad1def7dde10"
    private let botUserName = "bewired_dev_serg_bot"

    init() {
        self.client = TdClientImpl()
        self.api = TdApi(client: client)
        self.mapper = AuthMapper()
        run()
        setLogVerbosityLevel()
        setTDLParameters()
    }
    
    func confirmPhoneNumber(code: String?) async throws {
        _ = try await api.checkAuthenticationCode(code: code)
    }
    
    func setPhoneNumber(phoneNumber: String) async throws {
        _ = try await api.setAuthenticationPhoneNumber(phoneNumber: phoneNumber, settings: nil)
        
    }
    
    func logout() async throws {
        _ = try await api.logOut()
        _ = try await api.destroy()

    }
    
    func getCurrentUser() async throws -> User {
        let tdUser = try await api.getMe()
        let user = mapper.map(user: tdUser)
        let profilePhotoId = tdUser.profilePhoto?.big.id
        let file = try await api.downloadFile(fileId: profilePhotoId, limit: 0, offset: 0, priority: 1, synchronous: true)
        let filePath = file.local.path
        let imageData = try Data(contentsOf: URL(fileURLWithPath: filePath))
        user.profilePhotoData = imageData
        return user
    }
    
    func startBot() async throws {
        let bot = try await api.searchPublicChat(username:  botUserName)
        let botId = bot.id
        _ = try await api.sendBotStartMessage(botUserId: botId, chatId: botId, parameter: "")
    }
    
}

//MARK: - Private funcs
private extension AuthService {
    
    private func run() {
        api.client.run { _ in }
    }
    
    private func setTDLParameters()  {
        Task.init {
            do {
                _ = try await api.setTdlibParameters(apiHash: apiHash,
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
                                                     useTestDc: false)
            } catch {
                debugPrint("###setTdlibParameters", error.localizedDescription)
            }
        }
    }
    
    private func databaseDirectory() -> String? {
        let cachesUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let tdlibPath = cachesUrl?.appendingPathComponent("tdlib", isDirectory: true).path
        return tdlibPath
    }
    
    private func setLogVerbosityLevel() {
        /*
         по умолчанию начинает спамить в консоль о всех событиях TDLib
         0 - fatal errors
         1 - errors
         2 - warnings and debug warnings
         3 - informational
         4 - debug
         5 - verbose debug, greater than 5 and up to 1023 can be used to enable even more logging
         */
        do {
            try api.setLogVerbosityLevel(newVerbosityLevel: 1) { _ in }
        } catch {
            debugPrint("###setLogVerbosityLevel",error.localizedDescription)
        }
    }
    
    private func getProfilePhoto(profilePhotoId: Int) async throws -> UIImage? {
        let file = try await api.downloadFile(fileId: profilePhotoId, limit: 0, offset: 0, priority: 1, synchronous: true)
        let imageData = try Data(contentsOf: URL(fileURLWithPath: file.local.path))
        return UIImage(data: imageData)
    }
}

// MARK: Get Authorization state

extension AuthService {
    
    func getAuthorizationState() async throws -> AuthorizationState {
        return try await api.getAuthorizationState()
    }
    
    func checkTwoStepAuth(pass: String) async throws {
        _ = try await api.checkAuthenticationPassword(password: pass)
    }
}

