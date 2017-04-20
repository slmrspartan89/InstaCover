//
//  HomeController.swift
//  InstaCover
//
//  Created by Juan M Mariscal on 4/17/17.
//  Copyright © 2017 Mariscal Development. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItem()
        
        fetchPosts()
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(dictionary: userDictionary)
            
            let ref = FIRDatabase.database().reference().child("posts").child(uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot.value)
                
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                dictionaries.forEach({ (key, value) in
                    //print("Key \(key), Value: \(value)")
                    guard let dictionary = value as? [String: Any] else { return }
                    
                    let post = Post(user: user, dictionary: dictionary)
                    self.posts.append(post)
                })
                
                self.collectionView?.reloadData()
                
            }) { (err) in
                print("Failed to fetch posts:", err)
            }
            
        }) { (err) in
            
            print("Failed to fetch user for posts:", err)
        }
        
    }
    
    func setupNavigationItem() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
}
