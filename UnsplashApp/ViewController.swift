//
//  ViewController.swift
//  UnsplashApp
//
//  Created by Oleksandr Kachkin on 09.06.2022.
//  https://www.youtube.com/watch?v=dND9iNMzeKs

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  
  let networker = NetworkManager.shared
  
  var posts: [Post] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // #1 Комнплишен Клоужер нам нужно убедится, что self является weak.
    // Если ВьюКонтроллер (он же self) выйдет из памяти, когда выполняется сетевой запрос, NetworkManager сохранили бы этот ВьюКонтроллер в памяти (если у него strong ссылка на него).
    // Поэтому пометив ВьюКонтроллер как weak - ничего не изменится, кроме того что NetworkManager больше не может хранить ссылку на ВьюКонтроллер
    
    networker.posts(query: "puppies") { [weak self] posts, error in
      if let error = error {
        print("error", error)
        return
      }
      
    // #2 Мы сохраняем posts в массиве posts и затем перезагружаем CollectionView в основном потоке, потому что это обновление UI
      self?.posts = posts!
      DispatchQueue.main.async {
        self?.collectionView.reloadData()
      }
    }
  }


}

extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
    
    let post = posts[indexPath.item]
    cell.title = post.description
    
    return cell
  }
  
  
}

