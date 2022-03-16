//
//  SessionDelegate.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

class SessionDelegate: NSObject, URLSessionDelegate {
    var cerResource: String?
    var p12Resource: String?
    var fileType: String!
    
    fileprivate struct IdentityAndTrust {
        var identityRef: SecIdentity
        var trust: SecTrust
        var certArray: AnyObject
    }
    /// Use local .cer certificate
    init(cerResource: String) {
        super.init()
        self.fileType = "cer"
        self.cerResource = cerResource
    }
    /// Use local .p12 file
    init(p12Resource: String) {
        super.init()
        self.fileType = ".p12"
        self.p12Resource = p12Resource
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == (NSURLAuthenticationMethodServerTrust) {
            // Get remote certificate
            guard let serverTrust: SecTrust = challenge.protectionSpace.serverTrust,
                let certificate: SecCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0)else{
                    print("[Warning] SSL(cer) remote certificate is nil")
                    completionHandler(.cancelAuthenticationChallenge, nil)
                    return
            }
            // Get local Certificate
            guard let remoteCertificateData = CFBridgingRetain(SecCertificateCopyData(certificate)),
                let cerPath: String = Bundle.main.path(forResource: cerResource, ofType: fileType),
                let localCertificateData = NSData(contentsOfFile:cerPath) else{
                    print("[Warning] SSL(cer) local certificate is nil")
                    completionHandler(.cancelAuthenticationChallenge, nil)
                    return
            }
            
            if (remoteCertificateData.isEqual(localCertificateData as Data) == true) {
                print("[Success] remoteCertificate & localCertidicate is equal")
                let credential: URLCredential = URLCredential(trust: serverTrust)
                
                challenge.sender?.use(credential, for: challenge)
                completionHandler(.useCredential, credential)
            } else {
                print("[Error] remoteCertificate & localCertidicate isn't equal")
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate{
            // Use client certificate authentication for this protection space. [.p12]
            guard let path: String = Bundle.main.path(forResource: p12Resource, ofType: fileType),
                let PKCS12Data = NSData(contentsOfFile: path) else{
                    print("[Warning] SSL(p12) local certificate is nil")
                    completionHandler(.cancelAuthenticationChallenge, nil)
                    return
            }
            
            let identityAndTrust: IdentityAndTrust = self.extractIdentity(certData: PKCS12Data);
            
            let urlCredential: URLCredential = URLCredential(
                identity: identityAndTrust.identityRef,
                certificates: identityAndTrust.certArray as? [AnyObject],
                persistence: URLCredential.Persistence.forSession)
            print("[Success] send \(String(describing: fileType)) to remote")
            completionHandler(.useCredential, urlCredential)
        }else{
            print("[Warning] hasn't certificate authentication")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    // MARK: private
    fileprivate func extractIdentity(certData: NSData) -> IdentityAndTrust {
        var identityAndTrust: IdentityAndTrust!
        var securityError: OSStatus = errSecSuccess
        
        guard let path: String = Bundle.main.path(forResource: p12Resource, ofType: fileType),
            let PKCS12Data = NSData(contentsOfFile: path) else{
                fatalError("[Error] PKCS12Data is nil")
        }
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : "xyz"]
        //create variable for holding security information
//        var privateKeyRef: SecKey? = nil
        
        var items : CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess, let items = items {
            let certItems: CFArray = items
            let certItemsArray: Array = certItems as Array
            let dict: AnyObject? = certItemsArray.first
            if let certEntry: Dictionary = dict as? Dictionary<String, AnyObject> {
                
                // grab the identity
                let identityPointer: AnyObject? = certEntry["identity"];
                let secIdentityRef: SecIdentity = identityPointer as! SecIdentity
                print("\(String(describing: identityPointer))  :::: \(secIdentityRef)")
                
                // grab the trust
                let trustPointer: AnyObject? = certEntry["trust"];
                let trustRef: SecTrust = trustPointer as! SecTrust;
                print("\(String(describing: trustPointer))  :::: \(trustRef)")
                
                // grab the cert
                let chainPointer:AnyObject? = certEntry["chain"]
                
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef, trust: trustRef, certArray:  chainPointer!);
            }
        }
        return identityAndTrust;
    }
}
