//
//  ViewController.swift
//  GaoDeMapDemo
//
//  Created by cc on 2024/3/29.
//

import UIKit
import MapKit
import SnapKit

let TOP_INSET = 50.0//search bar距离顶部间距
let SEARCH_BAR_HEIGHT = 50.0//search bar高度
let BOTTOM_FOOTER_HEIGHT = 60.0//滑动view滑动到最下面，以最小方式显示时的高度
let SCROLL_VIEW_HEIGHT = SCREEN_HEIGHT - TOP_INSET - SEARCH_BAR_HEIGHT - BOTTOM_INSET_HEIGHT//滑动view的最大高度
let TOP_CRITICA_HEIGHT = TOP_INSET + SEARCH_BAR_HEIGHT + SCROLL_VIEW_HEIGHT/3//轻扫手势慢速停止时，滑动view动画回到顶部的临界位置
let BOTTOM_CRITICAL_HEIGHT = TOP_INSET + SEARCH_BAR_HEIGHT + SCROLL_VIEW_HEIGHT*5/6//轻扫手势慢速停止时，滑动view动画回到底部的临界位置

class GDMapViewController: UIViewController {
    
    private var curScrollTopInset = SCROLL_VIEW_HEIGHT*2/3
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.barTintColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.backgroundImage = UIImage.imageWithColor(color: .white, rect: CGRectMake(0, 0, SCREEN_WIDTH-20, SEARCH_BAR_HEIGHT))
        searchBar.placeholder = "查找地点，公交，地铁"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var scrollView: GDMapScrollView = {
        let view = GDMapScrollView()
        view.backgroundColor = .lightGray
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(panGes)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatas()
        setupSubviews()
        setupLayouts()
    }
    
    func setupDatas() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupSubviews () {
        view.addSubview(mapView)
        view.addSubview(scrollView)
        view.addSubview(searchBar)
    }
    
    func setupLayouts() {
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-BOTTOM_INSET_HEIGHT)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(TOP_INSET)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(SEARCH_BAR_HEIGHT)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(curScrollTopInset)
            make.leading.trailing.bottom.equalTo(mapView)
        }
    }
}

//MARK: -- Actions
extension GDMapViewController {
    @objc func panAction(panGesRecger: UIPanGestureRecognizer) {
        let p = panGesRecger.translation(in: scrollView)
        switch(panGesRecger.state) {
        case .began:
            view.endEditing(true)
        case .changed:
            panMove(p)
        case .ended:
            panEnd(panGesRecger)
        default:
            break
        }
    }
    
    func panMove(_ touchPoint: CGPoint) {
        let newTopInset = curScrollTopInset + touchPoint.y
        scrollView.snp.updateConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(newTopInset)
        }
    }
    
    func panEnd(_ panGesRecger: UIPanGestureRecognizer) {
        let endVelocity = panGesRecger.velocity(in: scrollView)
        if abs(endVelocity.y) < 100 {
            panEndLowVelocity()
        } else {
            panEndHeightVelocity(endVelocity)
        }
    }
    
    func panEndLowVelocity() {
        if CGRectGetMinY(scrollView.frame) < TOP_CRITICA_HEIGHT {
            animateToTop()
        } else if CGRectGetMinY(scrollView.frame) > BOTTOM_CRITICAL_HEIGHT {
            animateToBottom()
        } else {
            animateToMid()
        }
    }
    
    func panEndHeightVelocity(_ velocity: CGPoint) {
        if CGRectGetMinY(scrollView.frame) < TOP_INSET + SEARCH_BAR_HEIGHT + SCROLL_VIEW_HEIGHT*2/3 {
            if velocity.y > 0 {
                animateToMid()
            } else {
                animateToTop()
            }
        } else {
            if velocity.y > 0 {
                animateToBottom()
            } else {
                animateToMid()
            }
        }
    }
    
    func animateToTop() {
        UIView.animate(withDuration: 0.15) {
            self.scrollView.snp.updateConstraints { make in
                make.top.equalTo(self.searchBar.snp.bottom)
            }
            self.view.layoutIfNeeded()
        } completion: { com in
            self.curScrollTopInset = 0
        }
    }
    
    func animateToMid() {
        UIView.animate(withDuration: 0.15) {
            self.scrollView.snp.updateConstraints { make in
                make.top.equalTo(self.searchBar.snp.bottom).offset(SCROLL_VIEW_HEIGHT*2/3)
            }
            self.view.layoutIfNeeded()
        } completion: { com in
            self.curScrollTopInset = SCROLL_VIEW_HEIGHT*2/3
        }
    }
    
    func animateToBottom() {
        UIView.animate(withDuration: 0.15) {
            self.scrollView.snp.updateConstraints { make in
                make.top.equalTo(self.searchBar.snp.bottom).offset(SCROLL_VIEW_HEIGHT - BOTTOM_FOOTER_HEIGHT)
            }
            self.view.layoutIfNeeded()
        } completion: { com in
            self.curScrollTopInset = SCROLL_VIEW_HEIGHT - BOTTOM_FOOTER_HEIGHT
        }
    }
}

//MARK: -- UISearchBarDelegate
extension GDMapViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        animateToTop()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        animateToMid()
    }
}

//MARK: -- MKMapViewDelegate
extension GDMapViewController: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        view.endEditing(true)
    }
}

//MARK: -- CLLocationManagerDelegate
extension GDMapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate  = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
}



