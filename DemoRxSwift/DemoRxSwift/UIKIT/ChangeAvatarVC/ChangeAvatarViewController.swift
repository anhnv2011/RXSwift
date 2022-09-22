//
//  ChangeAvatarViewController.swift
//  DemoRxSwift
//
//  Created by MAC on 8/2/22.
//

import UIKit
import RxSwift
import RxCocoa

class ChangeAvatarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectIndex = -1
    private let bag = DisposeBag()
    private let selectedPhotoSubject = PublishSubject<UIImage>()  // Không cần cung cấp giá trị ban đầu cho nó
    var selectPhoto: Observable<UIImage>{
        return selectedPhotoSubject.asObserver()
    }
    /*
    selectedPhotosSubject là một Subject, nó sẽ emit dữ liệu và không cần thiết phải khai báo thêm giá trị ban đầu cho nó.
    Vì lúc hiển thị ViewController lên, thì người dùng chưa có sự lựa chọn nào hết.
    Quan trọng nhất là nó private
    selectedPhotos đây là phát ngôn viên của ViewController.
    Để bên ngoài (các đối tượng khác) có thể subscribe tới thuộc tính này của ViewController.
    Thực chất là việc biến đổi subject kia thành 1 observable
    Và cả 2 đều có kiểu dữ liệu Output khi emit là UIImage.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.selectedPhotoSubject.onCompleted()
        }
        
//        Với toán tử .onCompleted() thì subject sẽ kết thúc. Và không bao giờ emit ra nữa. Đồng nghĩa với các đăng ký từ các subscriber tới nó cũng bị huỷ. Test lại app, chúng ta đã thấy xuất hiện dòng print ở onDispose rồi.
    }
    
    func configCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AvatarCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }

}
extension ChangeAvatarViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AvatarCell
        cell.thumbnailImageView.image = UIImage(named: "avatar_\(indexPath.row + 1)")
        if indexPath.row == selectIndex {
            cell.backgroundColor = .blue
        } else {
            cell.backgroundColor = .gray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        collectionView.reloadData()
        
        if let image = UIImage(named: "avatar_\(indexPath.row + 1)") {
            selectedPhotoSubject.onNext(image)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32) / 3
        return CGSize(width: width , height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
}
