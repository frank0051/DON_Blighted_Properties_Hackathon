
    var map;
    var queries;
    function initialize() {

        var mapOptions = { zoom: 10, center: new google.maps.LatLng(29.762354, -95.365586) };
        map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
        queries = new Queries();
        setTimeout(queries.queryClusters.bind(queries), 500);

        // Create variable for the address search
        var input = /** @type {HTMLInputElement} */(document.getElementById('pac-input'));
        map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

        //Pass input variable to autocomplete search and bias autocomplete to map bounds
        var autocomplete = new google.maps.places.Autocomplete(input);
        autocomplete.bindTo('bounds', map);

        //Create a marker and infobox variable so the autocomplete has something to fill
        var infowindow = new google.maps.InfoWindow();
        var marker = new google.maps.Marker({
            map: map,
            anchorPoint: new google.maps.Point(0, -29)
        });

        //**Add listener for zoom change
        google.maps.event.addListener(map, 'zoom_changed', function () {
            queries.queryClusters();
        });
        ////**End listener for zoom change

        //**Autocomplete listener and zoom
        google.maps.event.addListener(autocomplete, 'place_changed', function () {
            //infowindow.close();
            marker.setVisible(false);
            var place = autocomplete.getPlace();
            if (!place.geometry) {
                return;
            }

            // If the place has a geometry, then present it on a map.
            if (place.geometry.viewport) {
                map.fitBounds(place.geometry.viewport);
            } else {
                map.setCenter(place.geometry.location);
                map.setZoom(15);  // Why 17? Because it looks good.
            }
            marker.setIcon(/** @type {google.maps.Icon} */({
                url: place.icon,
                size: new google.maps.Size(71, 71),
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(35, 35)
            }));
            marker.setPosition(place.geometry.location);
            marker.setVisible(true);

            var address = '';
            if (place.address_components) {
                address = [
                    (place.address_components[0] && place.address_components[0].short_name || ''),
                    (place.address_components[1] && place.address_components[1].short_name || ''),
                    (place.address_components[2] && place.address_components[2].short_name || '')
                ].join(' ');
            }

            queries.queryClusters();
            infowindow.setContent('<div><strong>' + place.name + '</strong><br>' + address);
            infowindow.open(map, marker);
        });
        //**End Autocomplete listener and zoom
    }
    google.maps.event.addDomListener(window, 'load', initialize);
    //window.onload = initialize;
    Date.prototype.getShortDate = function () {
        return this.getMonth() +
        "/" + this.getDate() +
        "/" + this.getFullYear();
    }