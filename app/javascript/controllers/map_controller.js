import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"


// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["mapContainer", "mainSearch"]
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.mapContainerTarget,
      style: "mapbox://styles/mapbox/dark-v11",
      language: 'pt-BR'
    })
    console.log(this.map)
    this.addMarkersToMap()
    this.fitMapToMarkers()

    this.geocoder = new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      types: "country,region,place,postcode,locality,neighborhood,address"
    })
    console.log(this.geocoder);
    this.map.addControl(this.geocoder)
    this.geocoder.addTo(this.mainSearchTarget)

    this.geocoder.on("result", (event) => {
      const lat = event.result.center[1]
      const lng = event.result.center[0]

      fetch(`/search?lat=${lat}&lng=${lng}`, {
        headers: { "Accept": "application/json" }
      }).then(response => response.json())
      .then((data) => {
        console.log(data);
        // this.carListTarget.innerHTML = data.car_list_html
      })
    })
  }

  addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
