struct AppConfig: Decodable {
    let dbHost: String
    let dbUser: String
    let dbPassword: String
    let dbName: String
    let smtpHost: String
    let smtpUser: String
    let smtpPassword: String
    let jwtSecret: String
    let relyingPartyID: String // "your-domain.com"
    let relyingPartyName: String // "Your App Name"
    let relyingPartyOrigin: String // "https://your-domain.com"
    
    static var tls: TLSConfiguration {
        var tls = TLSConfiguration.makeClientConfiguration()
        tls.certificateVerification = .none
        return tls
    }
}