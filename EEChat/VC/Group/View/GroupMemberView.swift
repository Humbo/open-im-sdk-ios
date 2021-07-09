//
//  GroupMemberView.swift
//  EEChat
//
//  Created by Snow on 2021/7/6.
//

import UIKit
import OpenIM

class GroupMemberView: UIView {
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(GroupMemberCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return collectionView
    }()
    
    var didSelectUser: ((OIMUser) -> Void)?
    private var users: [OIMUser] = []
    
    func add(user: OIMUser) {
        collectionView.performBatchUpdates {
            users.append(user)
            collectionView.insertItems(at: [IndexPath(row: users.count - 1, section: 0)])
        }
    }
    
    func remove(user: OIMUser) {
        if let index = users.firstIndex(of: user) {
            collectionView.performBatchUpdates {
                users.remove(at: index)
                collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
    
    
    var members: [OIMGroupMember] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var addBlock: (() -> Void)?
    var removeBlock: (() -> Void)?
    
}

extension GroupMemberView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch true {
        case indexPath.row < users.count:
            didSelectUser?(users[indexPath.row])
            collectionView.performBatchUpdates {
                users.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
            }
        case indexPath.row < members.count:
            break
        case indexPath.row == members.count:
            addBlock?()
        case indexPath.row == members.count + 1:
            removeBlock?()
        default:
            fatalError()
        }
    }
}

extension GroupMemberView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !members.isEmpty {
            return members.count + 2
        }
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GroupMemberCell
        switch true {
        case indexPath.row < users.count:
            cell.model = users[indexPath.row]
        case indexPath.row < members.count:
            cell.model = members[indexPath.row]
        case indexPath.row == members.count:
            cell.model = UIImage(named: "group_setting_icon_add")
        case indexPath.row == members.count + 1:
            cell.model = UIImage(named: "group_setting_icon_remove")
        default:
            fatalError()
        }
        return cell
    }
}
