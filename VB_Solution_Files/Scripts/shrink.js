function sidebarToggle() {
    if (document.getElementById('instructions-container').style.width=='25%') {
        document.getElementById('instructions-container').style.width = '0%';
        $('#instructions-container').hide();
        document.getElementById('map-container').style.width = '100%';
        google.maps.event.trigger(map, "resize");
        $('#show_panel').show();
    }
    else {
        document.getElementById('instructions-container').style.width = '25%';
        $('#instructions-container').show();
        document.getElementById('map-container').style.width = '75%';
        google.maps.event.trigger(map, "resize");
        $('#show_panel').hide();
    }
}

//Function to toggle on Services tab
function selectWelcome() {
    $('#welcomeContent').show();
    document.getElementById('welcomeTab').className = 'active';
    $('#filtersContent').hide();
    document.getElementById('filtersTab').className = '';
    $('#layersContent').hide();
    document.getElementById('layersTab').className = '';
}

//Function to toggle on Locations tab
function selectFilters() {
    $('#filtersContent').show();
    document.getElementById('filtersTab').className = 'active';
    $('#welcomeContent').hide();
    document.getElementById('welcomeTab').className = '';
    $('#layersContent').hide();
    document.getElementById('layersTab').className = '';
}

//Function to toggle on Locations tab
function selectLayers() {
    $('#layersContent').show();
    document.getElementById('layersTab').className = 'active';
    $('#filtersContent').hide();
    document.getElementById('filtersTab').className = '';
    $('#welcomeContent').hide();
    document.getElementById('welcomeTab').className = '';
}