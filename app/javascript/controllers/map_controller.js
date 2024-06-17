import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"


// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["mapContainer", "mainSearch", "searchcardList"]
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    this.insertMap()
    this.addMarkersToMap()
    this.addGeocoder()
    this.addHeatMap()
  }

  insertMap() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.mapContainerTarget,
      style: "mapbox://styles/mapbox/outdoors-v12",
      language: 'pt-BR'
    })
  }

  addMarkersToMap(markers = null) {
    if (markers) {
      this.markerArray = markers
    } else {
      this.markerArray = this.markersValue
    }

    this.markerArray.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })

    this.fitMapToMarkers(markers)
  }

  fitMapToMarkers(markers = null) {
    if (markers) {
      this.markerArray = markers
    } else {
      this.markerArray = this.markersValue
    }

    const bounds = new mapboxgl.LngLatBounds()
    this.markerArray.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: markers ? 1000 : 0 })
  }

  addGeocoder() {
    this.geocoder = new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      types: "country,region,place,postcode,locality,neighborhood,address",
      language: 'pt-BR',
      placeholder: 'Search'
    })

    this.map.addControl(this.geocoder)
    this.geocoder.addTo(this.mainSearchTarget)

    this.geocoder.on("result", (event) => {
      this.cleanupMarkers()
      this.setQueryString()


      const lat = event.result.center[1]
      const lng = event.result.center[0]

      this.map.once('moveend', () => {
        this.calculateRange()

        const url = `/search?${this.query}lat=${lat}&lng=${lng}&range=${this.range}`
        const options = {
          headers: { "Accept": "application/json" }
        }

        fetch(url, options)
          .then(response => response.json())
          .then((data) => {
            const newMarkers = data.markers
            if (newMarkers.length > 0) {
              this.addMarkersToMap(newMarkers)
            }

            this.searchcardListTarget.innerHTML = data.searchcard_html
          })
      });
    })
  }

  setQueryString() {
    const searchParams = new URLSearchParams(window.location.search);
    const newParams = new URLSearchParams("");

    searchParams.entries().forEach (([key, value] ) => {
      if (key.includes('interest') && value != '') {
        newParams.append(key, value);
      }
    });

    this.query = ''
    if (newParams.toString() != '') {
      this.query = `${newParams.toString()}&`
    }
  }

  cleanupMarkers() {
    const oldMarkers = document.querySelectorAll(".mapboxgl-marker")
    oldMarkers.forEach(marker => marker.classList.add("d-none"))
  }

  calculateRange() {
    // Get the new bounds
    const bounds = this.map.getBounds()
    const ne = bounds.getNorthEast()
    const sw = bounds.getSouthWest()
    this.range = this.distanceBetweenPoints(ne.lat, ne.lng, sw.lat, sw.lng) / 2
  }

  distanceBetweenPoints(lat1, lon1, lat2, lon2) {
    const R = 6371; // Earth's radius in kilometers
    const toRadians = Math.PI / 180;

    const dLat = (lat2 - lat1) * toRadians;
    const dLon = (lon2 - lon1) * toRadians;

    const lat1Rad = lat1 * toRadians;
    const lat2Rad = lat2 * toRadians;

    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(lat1Rad) * Math.cos(lat2Rad) *
              Math.sin(dLon / 2) * Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c;
  }

  addHeatMap() {
    this.map.on('load', () => {
      this.map.addSource('users', {
        type: 'geojson',
        data: this.geoJsonFormat()
      });
      console.log(this.geoJsonFormat());
      this.addHeatMapLayer();
      this.addCircleHeatMap();
      this.cleanupMarkers();
    });
  }

  geoJsonFormat() {
    const arrayOfPoints = [];
    this.markerArray.forEach((marker) => {
      arrayOfPoints.push({ "type": "Feature","properties":{"dbh":5}, "geometry": { "type": "Point", "coordinates": [marker.lng, marker.lat] }, "properties": {}});
    })
    const geoUserJson = {"type":"FeatureCollection","features": arrayOfPoints}
    return geoUserJson;
  }

  addHeatMapLayer() {
    this.map.addLayer(
      {
        id: 'users-point',
        type: 'heatmap',
        source: 'users',
        maxzoom: 15,
        paint: {
          // increase weight as diameter breast height increases
          'heatmap-weight': 1,
          // increase intensity as zoom level increases
          'heatmap-intensity': {
            stops: [
              [11, 1],
              [15, 3]
            ]
          },
          // assign color values be applied to points depending on their density
          'heatmap-color': [
            'interpolate',
            ['linear'],
            ['heatmap-density'],
            0,
            'rgba(236,222,239,0)',
            0.2,
            'rgb(208,209,230)',
            0.4,
            'rgb(166,189,219)',
            0.6,
            'rgb(103,169,207)',
            0.8,
            'rgb(28,144,153)'
          ],
          // increase radius as zoom increases
          'heatmap-radius': 50,
          // decrease opacity to transition into the circle layer
          'heatmap-opacity': {
            default: 1,
            stops: [
              [14, 1],
              [15, 0]
            ]
          }
        }
      }
    );
  }

  addCircleHeatMap() {
    this.map.addLayer(
      {
        id: 'users-circle',
        type: 'circle',
        source: 'users',
        minzoom: 14,
        paint: {
          // increase the radius of the circle as the zoom level and dbh value increases
          'circle-radius': {
            property: 'dbh',
            type: 'exponential',
            stops: [
              [{ zoom: 15, value: 1 }, 5],
              [{ zoom: 15, value: 62 }, 10],
              [{ zoom: 22, value: 1 }, 20],
              [{ zoom: 22, value: 62 }, 50]
            ]
          },
          'circle-color': {
            property: 'dbh',
            type: 'exponential',
            stops: [
              [0, 'rgba(236,222,239,0)'],
              [10, 'rgb(236,222,239)'],
              [20, 'rgb(208,209,230)'],
              [30, 'rgb(166,189,219)'],
              [40, 'rgb(103,169,207)'],
              [50, 'rgb(28,144,153)'],
              [60, 'rgb(1,108,89)']
            ]
          },
          'circle-stroke-color': 'white',
          'circle-stroke-width': 1,
          'circle-opacity': {
            stops: [
              [14, 0],
              [15, 1]
            ]
          }
        }
      },
      'waterway-label'
    );
  }
}
