//
//  UserInfoViewController.swift
//  KarooooSampleApp
//
//  Created by Halcyon Tek on 11/03/23.
//

import UIKit
import CoreLocation
import MapKit

class UserInfoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    // MARK: - Variable declarations
    @IBOutlet weak var tblUser: UITableView?
    var userModel = [UserModel]()
    var userViewModel = UserViewModel()
    var manager: CLLocationManager?
    var currentLocation: CLLocation?
    var mapView = MKMapView()
    
    // MARK: -View Life cycle methods
    /**
    * This method is to load the view
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        generalMethodsToHandelNavigationBar()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //designMapViewProgramatically()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
    }
    
   @objc func designMapViewProgramatically() {
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width-20
        let mapHeight:CGFloat = view.frame.size.height-140
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
        view.addSubview(mapView)
    }
    
    // MARK - CLLocationManagerDelegate
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        let index = IndexPath(row: 0, section: 0)
        let cell: UserInfoTableViewCell = self.tblUser?.cellForRow(at: index) as! UserInfoTableViewCell

        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location: location)
        }
   }
   // 17.455259695359736, 78.37253460155728
    func render(location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: (location.coordinate.longitude))
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        
    }
    
    func generalMethodsToHandelNavigationBar(){
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.systemMint
    }
    
    
    func initialSetup(){
        userViewModel.delegate = self
        userViewModel.onShowError = {[weak self] message in
            self?.showToast(message: message, seconds: 1.0)
        }
        callUserSerice(userName: "aniketk561@gmail.com", password: "123456Aa")
    }
    
    // MARK: - Calling service
    func callUserSerice(userName:String,password:String){
        userViewModel.userService (username: userName, password: password){[weak self] response in
            guard let self = self else {return}
            self.userModel = response
            self.tblUser?.reloadData()
        }}}


//MARK: - Tableview Delegate and Datasource mothods
extension UserInfoViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as? UserInfoTableViewCell
        cell?.userModel = userModel[indexPath.row]
        cell?.configure()
        // Enable User Interaction
        cell?.lblGeoLocation.isUserInteractionEnabled = true
        // Create and add the Gesture Recognizer
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelGeoLocationClicked(_:)))
        cell?.lblGeoLocation.addGestureRecognizer(guestureRecognizer)
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        280
    }
    
    @objc func labelGeoLocationClicked(_ sender: Any) {
        //            print("UILabel clicked")
        //            let lat1 : NSString = "-37.31"
        //        let lng1 : NSString = "81.14"
        //
        //            let latitude:CLLocationDegrees =  lat1.doubleValue
        //            let longitude:CLLocationDegrees =  lng1.doubleValue
        //
        //            let regionDistance:CLLocationDistance = 10000
        //            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        //        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        //            let options = [
        //                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
        //                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        //            ]
        //            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        //            let mapItem = MKMapItem(placemark: placemark)
        //           mapItem.name = "London"
        //        }
        self.designMapViewProgramatically()
        
    }}
//MARK: - Loader delegate
extension UserInfoViewController:LoaderDelegate{
    func isLoad(loading: Bool) {
        loading ? LoadingOverlay.shared.showOverlay(view: self.view, infoText: "Loading") : LoadingOverlay.shared.hideOverlayView()
    }
    
    
}


//MARK: - Show Toast Alert
extension UIViewController{
    func showToast(message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.frame.size.height = 20
        alert.view.layer.cornerRadius = 8
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: false)
        }
    }
    
}



