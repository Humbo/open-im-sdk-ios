//
//  OIMManager+Friendship.swift
//  OpenIM
//
//  Created by Snow on 2021/6/15.
//

import Foundation
import OpenIMCore

public protocol OIMFriendshipListener: AnyObject {
    func onFriendApplicationListAdded(_ user: OIMUserInfo)
    func onFriendApplicationListDeleted(_ uid: String)
    func onFriendApplicationListRead()
    func onFriendApplicationListReject(_ uid: String)
    func onFriendApplicationListAccept(_ user: OIMUserInfo)
    func onFriendListAdded()
    func onFriendListDeleted(_ uid: String)
    func onBlackListAdded(_ user: OIMUserInfo)
    func onBlackListDeleted(_ uid: String)
    func onFriendProfileChanged(_ user: OIMUserInfo)
}

extension OIMManager {
    
    public static func setFriendListener(_ listener: OIMFriendshipListener) {
        shared.friendshipListener = listener
    }
    
    // MARK: - Friend
    
    public static func getFriendList(_ callback: @escaping (Result<[OIMUserInfo], Error>) -> Void) {
        Open_im_sdkGetFriendList(CallbackArgsProxy(callback))
    }
    
    public static func getFriendsInfo(_ uids: [String], callback: @escaping (Result<[OIMUserInfo], Error>) -> Void) {
        getFriendList { result in
            if case let .success(array) = result {
                let array = array.filter{ uids.contains($0.uid) }
                callback(.success(array))
            } else {
                callback(result)
            }
        }
    }
    
    public static func setFriendInfo(_ uid: String, comment: String, callback: @escaping (Result<Void, Error>) -> Void) {
        struct Param: Encodable {
            let uid: String
            let comment: String
        }
        Open_im_sdkSetFriendInfo(Param(uid: uid, comment: comment).toString(), CallbackProxy(callback))
    }
    
    public static func addFriend(_ param: OIMFriendAddApplication, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkAddFriend(CallbackProxy(callback), param.toString())
    }
    
    public static func deleteFromFriendList(_ uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        struct Param: Encodable {
            let uid: String
        }
        Open_im_sdkDeleteFromFriendList(Param(uid: uid).toString(), CallbackProxy(callback))
    }
     
    // MARK: - FriendApplication
    
    public static func getFriendApplicationList(_ callback: @escaping (Result<[OIMFriendApplicationModel], Error>) -> Void) {
        Open_im_sdkGetFriendApplicationList(CallbackArgsProxy(callback))
    }
    
    public static func acceptFriendApplication(uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        struct Param: Encodable {
            let uid: String
        }
        Open_im_sdkAcceptFriendApplication(CallbackProxy(callback), Param(uid: uid).toString())
    }
    
    public static func refuseFriendApplication(uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        struct Param: Encodable {
            let uid: String
        }
        Open_im_sdkRefuseFriendApplication(CallbackProxy(callback), Param(uid: uid).toString())
    }
    
    // deleteFriendApplication
    // setFriendApplicationRead
    
    // MARK: - BlackList
    
    public static func getBlackList(_ callback: @escaping (Result<[OIMUserInfo], Error>) -> Void) {
        Open_im_sdkGetBlackList(CallbackArgsProxy(callback))
    }
    
    public static func addToBlackList(uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        struct Param: Encodable {
            let uid: String
        }
        Open_im_sdkAddToBlackList(CallbackProxy(callback), Param(uid: uid).toString())
    }
    
    public static func deleteFromBlackList(uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        struct Param: Encodable {
            let uid: String
        }
        Open_im_sdkDeleteFromBlackList(CallbackProxy(callback), Param(uid: uid).toString())
    }
    
}

public class OIMFriendAddApplication: NSObject, Encodable {
    public var uid: String
    public var reqMessage: String
    
    public init(uid: String, reqMessage: String) {
        self.uid = uid
        self.reqMessage = reqMessage
        super.init()
    }
}

// MARK: - Open_im_sdkOnFriendshipListenerProtocol

extension OIMManager: Open_im_sdkOnFriendshipListenerProtocol {
    
    public func onBlackListAdd(_ info: String?) {
        let model: OIMUserInfo = decodeModel(info)
        self.friendshipListener?.onBlackListAdded(model)
    }
    
    public func onBlackListDeleted(_ info: String?) {
        let model: OIMUserInfo = decodeModel(info)
        self.friendshipListener?.onBlackListDeleted(model.uid)
    }
    
    public func onFriendApplicationListAccept(_ info: String?) {
        let model: OIMUserInfo = decodeModel(info)
        self.friendshipListener?.onFriendApplicationListAccept(model)
    }
    
    public func onFriendApplicationListAdded(_ info: String?) {
        let model: OIMUserInfo = decodeModel(info)
        self.friendshipListener?.onFriendApplicationListAdded(model)
    }
    
    public func onFriendApplicationListDeleted(_ info: String?) {
        let model: OIMUserInfo = decodeModel(info)
        self.friendshipListener?.onFriendApplicationListDeleted(model.uid)
    }
    
    public func onFriendApplicationListReject(_ info: String?) {
        let model: OIMUserInfo = decodeModel(info)
        self.friendshipListener?.onFriendApplicationListReject(model.uid)
    }
    
    public func onFriendListAdded(_ info: String?) {
        self.friendshipListener?.onFriendListAdded()
    }
    
    public func onFriendInfoChanged(_ info: String?) {
        let model: OIMUserInfo = decodeModel(info)
        self.friendshipListener?.onFriendProfileChanged(model)
    }
    
    public func onFriendListAdded() {
        self.friendshipListener?.onFriendListAdded()
    }
    
    public func onFriendListDeleted(_ info: String?) {
        let model: OIMUserInfo = decodeModel(info)
        self.friendshipListener?.onFriendListDeleted(model.uid)
    }
}