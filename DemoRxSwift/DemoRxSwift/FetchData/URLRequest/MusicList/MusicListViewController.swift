//
//  MusicListViewController.swift
//  DemoRxSwift
//
//  Created by MAC on 7/31/22.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MusicListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let urlMusic = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/25/albums.json"
    private let musicsFileURL = cachedFileURL("musics.json")
    private let bag = DisposeBag()
    private var musics = BehaviorRelay<[Music]>(value: [])
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
        // read musics file
       
        if let musicsData = try? Data(contentsOf: musicsFileURL),
           let preMusics = try? JSONDecoder().decode([Music].self, from: musicsData) {
            self.musics.accept(preMusics)
        }
        
        loadAPI()
        
        
    }
    
    func getDatabydecode(){
        guard let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/25/albums.json") else {
            print("URL khong ton tai")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // neu co loi xay ra
                print(error.localizedDescription)
            } else {
                
                //                c1 : đọc dữ liệu bằng decode
                do {
                    
                    let result = try! JSONDecoder().decode(FeedResult.self, from: data!)
                    //let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(result.feed)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
        
    }
    
    // MARK: - Private Methods
    private func configUI() {
        title = "New Music"
        
        let nib = UINib(nibName: "MusicCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func processMusics(newMusics: [Music]) {
        // update UI
        DispatchQueue.main.async {
            self.musics.accept(newMusics)
            self.tableView.reloadData()
        }
        
        // save to file
        if let musicData = try? JSONEncoder().encode(newMusics){
            try? musicData.write(to: musicsFileURL, options: .atomicWrite)
        }
        
    }
    
    // MARK: - API
    private func loadAPI() {
        let response = Observable<String>.of(urlMusic)
            .map { urlString -> URL in  //convert from string to Url
                return URL(string: urlString)!
            }
            .map { url -> URLRequest in   // url -> urlrequest
                let request = URLRequest(url: url)
                
                // modified Header here
                
                return request
            }
            
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            /*Với flatMap:
             
             Không những giúp cho việc biến đổi dữ liệu mà còn biến đổi luôn của Observable này thành Observable khác
             Nó phù hợp với cách tương tác bất đồng bộ (vì 2 bước biến đổi trên vẫn toàn là đồng bộ)
             Nó sẽ chờ phản hồi đầy đủ từ server trả về. Sau đó sẽ thực thi các đoạn code tiếp theo
             
             Với URLSession:
             
             Bạn đang dùng các thuộc tính mới được thêm vào từ RxCocoa
             share.rx sẽ gọi toán tử response với tham số là request từ trên
             Kết quả trả về là 1 Observable, với kiểu giá trị của phần tử bao gồm HTTPURLResponse và Data cho body
             
             */
            
            .share(replay: 1)
        
    /*   Để cho phép có nhiều subscriptions tới Observable đó và kết quả sẽ được lưu lại ở bộ đệm. Khi đó đảm bảo sẽ    có được dữ liệu cho các Subscriber.
         Để tránh việc làm tốn tài nguyên và công sức như thế này. Thì sử dụng toán tử share(replay:scope). Toán tử sẽ giữ lại phần tử cuối cùng trong bộ đệm. Cứ như vậy, các Subscriber tiếp theo khi đăng kí tới, thì sẽ nhận được dữ liệu ngay lập tức và không cần phải thực hiện lại đám lệnh kết nối tới API ở trên.
         
         Về scopes thì bạn có 2 lựa chọn
         
         .forever bộ đệm sẽ lưu lại mãi mãi. Chờ người đăng ký mới.
         .whileConnected bộ đệm sẽ giữ lại cho đến khi không còn người nào đăng kí tới và loại bỏ bộ đệm ngay sau đó. Các đăng ký tiếp theo thì sẽ load lại từ đầu.
         Tuỳ thuộc vào ý đồ bạn muốn sử dụng việc load API đó ra sao. Mà có cách sử dụng share  phù hợp.
         
         */
        
        
        // subscription #1
        response
            .filter { response, _ -> Bool in
                return 200..<300 ~= response.statusCode
            }
            .map { _, data -> [Music] in
                let decoder = JSONDecoder()
                let results = try? decoder.decode(FeedResult.self, from: data)
                return results?.feed.results ?? []
            }
            .filter { objects in
                return !objects.isEmpty
            }
            .subscribe(onNext: { musics in
                self.processMusics(newMusics: musics)
            })
            .disposed(by: bag)
        
    }
    
    // MARK: File plist
    static func cachedFileURL(_ fileName: String) -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .allDomainsMask)
            .first!
            .appendingPathComponent(fileName)
    }
    
}

extension MusicListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musics.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MusicCell
        
        let item = musics.value[indexPath.row]
        cell.nameLabel.text = item.name
        cell.artistNameLabel.text = item.artistName
        cell.thumbnailImageView.kf.setImage(with: URL(string: item.artworkUrl100!)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
