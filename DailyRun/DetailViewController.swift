//
//  DetailViewController.swift
//  DailyRun
//
//  Created by GuoCheng on 15/8/16.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import MapKit
import IQKeyboardManager
class DetailViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTextView:UITextView!
    var runData:RunData?
    
    override func viewDidLoad() {
        IQKeyboardManager.sharedManager().enable = true
        super.viewDidLoad()
        mapView.delegate = self
        noteTextView.text = "说两句感想不..."
        noteTextView.textColor = UIColor.lightGrayColor()
        noteTextView.layer.borderColor = UIColor.grayColor().CGColor
        noteTextView.layer.borderWidth = 1.0;
        noteTextView.layer.cornerRadius = 8;
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer.enabled = false
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "finishRunning")
        navigationItem.rightBarButtonItem = closeBarButton
        loadMap()
        configureView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
    }
    
    internal func finishRunning()
    {
        RunDataManager.sharedInstance.realm.beginWriteTransaction()
        runData?.note = noteTextView.text
        RunDataManager.sharedInstance.realm.commitWriteTransaction()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func loadMap()
    {
        if runData?.locations.count >= 2
        {
            mapView.addOverlay(polyline())
            mapView.region = mapRegion()
            //            mapView.region = mapRegion()
            //            let locations = runData?.locations
            //            var coordinates = [CLLocationCoordinate2D]()
            //            for var i:UInt = 0;i<locations!.count;i++
            //            {
            //                let location = locations![i] as! Locations
            //                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            //                coordinates.append(coordinate)
            //            }
            //            let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
            //            mapView.addOverlay(polyline)
        }
    }
    
    func configureView() {
        paceLabel.text = "配速:" + String(format: "%.2f", runData!.pace)
        distanceLabel.text = String(format: "%.2f公里", runData!.distance)
        timeLabel.text = "时间:" + runData!.duration.timeFormatted
        dateLabel.text = runData?.date.dateString
    }
    
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc = runData?.locations.firstObject() as! Locations
        
        var minLat = initialLoc.latitude
        var minLng = initialLoc.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = runData?.locations
        for var i:UInt = 0;i < locations!.count; i++
        {
            let location = locations![i] as! Locations
            minLat = min(minLat, location.latitude)
            minLng = min(minLng, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLng = max(maxLng, location.longitude)
        }
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
                longitudeDelta: (maxLng - minLng)*1.1))
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "说两句感想不..."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
}

// MARK: - MKMapViewDelegate
extension DetailViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if !overlay.isKindOfClass(MKPolyline)
        {
            return nil
        }
        println("poly")
        let polyLine = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = UIColor.greenColor()
        renderer.lineWidth = 4
        return renderer
    }
    
    func polyline()->MKPolyline
    {
        var coordinates = [CLLocationCoordinate2D]()
        let locations = runData?.locations
        for var i:UInt = 0;i < locations!.count; i++
        {
            let location = locations![i] as! Locations
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            coordinates.append(coordinate)
        }
        //        for location in locations
        //        {
        //            let coordinate = CLLocationCoordinate2D(latitude: location.latitude.doubleValue, longitude: location.longitude.doubleValue)
        //            coordinates.append(coordinate)
        //        }
        let polyline = MKPolyline(coordinates: &coordinates, count: Int(coordinates.count))
        return polyline
    }
    
}
