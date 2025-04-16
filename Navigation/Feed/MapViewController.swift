//
//  MapViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 4/13/25.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

	private var currentLocation: CLLocationCoordinate2D?

	//MARK: Map UI
	private let mapView = MKMapView()

	private var locationManager = CLLocationManager()

	//MARK: Additional UI
	private lazy var configureMapButton: UIButton = {
		let button = UIButton(type: .system)
		let image = UIImage(systemName: "map.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32))
		button.setImage(image, for: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(configureMap), for: .touchUpInside)
		return button
	}()

	private lazy var moveToCurrentLocationButton: UIButton = {
		let button = UIButton(type: .system)
		let image = UIImage(systemName: "location.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32))
		button.setImage(image, for: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(showLocation), for: .touchUpInside)
		return button
	}()

	//MARK: Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()

		requestLocationAccess()
		mapView.showsUserLocation = true
		mapView.delegate = self

		locationManager.delegate = self
		locationManager.startUpdatingLocation()

		setupNavBar()
		addSubviews()
		setupLayout()
		setupGesture()
	}

	//MARK: UI Setup
	private func addSubviews() {
		view.addSubview(mapView)
		view.addSubview(configureMapButton)
		view.addSubview(moveToCurrentLocationButton)
	}

	private func setupLayout() {
		mapView.translatesAutoresizingMaskIntoConstraints = false
		configureMapButton.translatesAutoresizingMaskIntoConstraints = false
		moveToCurrentLocationButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

			configureMapButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
			configureMapButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
			configureMapButton.widthAnchor.constraint(equalToConstant: 80),
			configureMapButton.heightAnchor.constraint(equalToConstant: 80),

			moveToCurrentLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
			moveToCurrentLocationButton.bottomAnchor.constraint(equalTo: configureMapButton.topAnchor),
			moveToCurrentLocationButton.widthAnchor.constraint(equalToConstant: 80),
			moveToCurrentLocationButton.heightAnchor.constraint(equalToConstant: 80),
		])
	}

	private func setupNavBar() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Remove all pins", comment: "Remove pins button text"), style: .plain, target: self, action: #selector(removeAnnotations))
	}

	private func requestLocationAccess() {
		locationManager.requestWhenInUseAuthorization()

		if locationManager.authorizationStatus != .authorizedWhenInUse {
			let alertController = UIAlertController(title: NSLocalizedString("Provide location access", comment: "Provide location access alert title"), message: NSLocalizedString("We need location access to show your current location", comment: "Provide location access alert message"), preferredStyle: .alert)
			let settingsAction = UIAlertAction(title: "Provide access", style: .default) { _ in
				if let url = URL(string: UIApplication.openSettingsURLString),
				   UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url)
				}
			}
			let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel alert button"), style: .cancel)

			alertController.addAction(settingsAction)
			alertController.addAction(cancelAction)
			present(alertController, animated: true)
		}
	}

	//MARK: User Interaction
	private func setupGesture() {
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector (longPress))
		mapView.addGestureRecognizer(longPress)
	}

	@objc private func longPress(sender: UILongPressGestureRecognizer) {
		let point = sender.location(in: mapView)
		let location = mapView.convert(point, toCoordinateFrom: mapView)
		let annotation = MKPointAnnotation()
		annotation.coordinate = location
		annotation.title = MKPlacemark(coordinate: location, addressDictionary: nil).locality
		mapView.addAnnotation(annotation)
	}


	@objc private func configureMap() {
		let alert = UIAlertController(title: NSLocalizedString("Map Type", comment: "Map type alert title"), message: nil, preferredStyle: .actionSheet)

		let standard = UIAlertAction(title: NSLocalizedString("Standard", comment: "Standard map type"), style: .default) { _ in
				self.mapView.mapType = .standard
			}

			let satellite = UIAlertAction(title: NSLocalizedString("Satellite", comment: "Satellite map type"), style: .default) { _ in
				self.mapView.mapType = .satellite
			}

			let hybrid = UIAlertAction(title: NSLocalizedString("Hybrid", comment: "Hybrid map type"), style: .default) { _ in
				self.mapView.mapType = .hybrid
			}

			let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel alert button"), style: .cancel)

			alert.addAction(standard)
			alert.addAction(satellite)
			alert.addAction(hybrid)
			alert.addAction(cancel)

			present(alert, animated: true)
	}

	@objc func showLocation() {
		if locationManager.authorizationStatus == .authorizedWhenInUse {
			mapView.setRegion(MKCoordinateRegion(center: currentLocation!, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
		} else {
			requestLocationAccess()
		}
	}

	@objc func removeAnnotations() {
		mapView.removeAnnotations(mapView.annotations)
		mapView.removeOverlays(mapView.overlays)
	}

}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		currentLocation = locations[0].coordinate
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard let destinationCoordinates = view.annotation?.coordinate else { return }

		let alert = UIAlertController(title: NSLocalizedString("Directions", comment: "Directions alert title"), message: NSLocalizedString("Get directions to this point?", comment: "Directions alert message"), preferredStyle: .actionSheet)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		let directionsAction = UIAlertAction(title: "Get directions", style: .default) { [weak self] _ in
			guard let self else { return }
			if let currentLocation = self.locationManager.location?.coordinate {
				let transportAlert = UIAlertController(title: NSLocalizedString("Transport type", comment: "Transport type alert title"), message: nil, preferredStyle: .actionSheet)

				let car = UIAlertAction(title: NSLocalizedString("Car", comment: "Car transport type"), style: .default) { _ in
					self.getRoute(from: currentLocation, to: destinationCoordinates, transportType: .automobile)
				}
				let walk = UIAlertAction(title: NSLocalizedString("Walking", comment: "Walking transport type"), style: .default) { _ in
					self.getRoute(from: currentLocation, to: destinationCoordinates, transportType: .walking)
				}
				let transit = UIAlertAction(title: NSLocalizedString("Transit", comment: "Transit transport type"), style: .default) { _ in
					self.getRoute(from: currentLocation, to: destinationCoordinates, transportType: .transit)
				}
				let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel alert button"), style: .cancel)

				transportAlert.addAction(car)
				transportAlert.addAction(walk)
				transportAlert.addAction(transit)
				transportAlert.addAction(cancel)

				self.present(transportAlert, animated: true)
			}
		}
		
		alert.addAction(cancelAction)
		alert.addAction(directionsAction)
		present(alert, animated: true)
	}

	func getRoute(from location: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, transportType: MKDirectionsTransportType) {
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: location))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
		request.transportType = transportType

		let direction = MKDirections(request: request)

		direction.calculate { [weak self] response, error in
			guard let self else { return }
			if let response, let route = response.routes.first {
				self.mapView.removeOverlays(self.mapView.overlays)
				self.mapView.addOverlay(route.polyline)
				self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
			}
		}
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKPolyline {
			let renderer = MKPolylineRenderer(overlay: overlay)
			renderer.strokeColor = .blue
			renderer.lineWidth = 5
			return renderer
		}
		return MKOverlayRenderer()
	}
}
