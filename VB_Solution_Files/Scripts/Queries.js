////////////////////////REZA H. TESHNIZI/////////////////////////
////////////////////r.teshnizi@cse.tamu.edu//////////////////////

/////////////////////////////////////////////////////////////////
/////////////////////THE AJAX CALL FUNCTIONS/////////////////////
/////////////////////////////////////////////////////////////////
function AjaxCall(dataobj, webservicelocation, funcSuccess, funcFail) {
    var data = { jsonobj: JSON.stringify(dataobj) };
    var asyncVal = true; // Ajax Default
    var cacheVal = true; // Ajax Default
    $.ajax({
        type: 'post',
        cache: false,
        url: webservicelocation,
        success: funcSuccess,
        fail: funcFail,
        error: function () {
            alert("----------------AJAX FAILED------------------\n" + webservicelocation + "\n" + arguments[0].responseText)
        },
        data: JSON.stringify(data),
        dataType: "text", // REZA: IMPRTANT -- Do not set dataType to "json". It will cause json parse problem in JQuery 1.5 and higher
        contentType: "application/json",
        dataFilter: function (data) {
            var msg;
            if (typeof (JSON) !== 'undefined' && typeof (JSON.parse) === 'function')
                msg = JSON.parse(data);
            else
                msg = eval('(' + data + ')');
            if (msg.hasOwnProperty('d'))
                return msg.d;
            else
                return msg;
        }
    })
}

/////////////////////////////////////////////////////////////////
///////////////////////THE QUERY OBJECT//////////////////////////
/////////////////////////////////////////////////////////////////
function Query(neLat, neLon, swLat, swLon, HCAD, Status) {
    this.NELat = neLat;
    this.NELon = neLon;
    this.SWLat = swLat;
    this.SWLon = swLon;
    this.HCAD = "";
    if (HCAD)
        this.HCAD = HCAD;
    this.Status = true;
    if (Status)
        this.Status = Status;
}

/////////////////////////////////////////////////////////////////
//////////////////////THE QUERIES OBJECT/////////////////////////
/////////////////////////////////////////////////////////////////
function Queries() {
    this.dots = new Object();
    this.infoWindowIndex = null;
}

Queries.prototype.queryClusters = function () {
    this.clearMap();
    //var query = new Query(map.getBounds().getNorthEast().lat(), map.getBounds().getNorthEast().lng(), map.getBounds().getSouthWest().lat(), map.getBounds().getSouthWest().lng(), "0121440000061");
    var query = new Query(map.getBounds().getNorthEast().lat(), map.getBounds().getNorthEast().lng(), map.getBounds().getSouthWest().lat(), map.getBounds().getSouthWest().lng());
    AjaxCall(query, "GetHData.asmx/GetRecords", this.success.bind(this), this.fail.bind(this));
}

Queries.prototype.success = function (results) {
    if (results[0] === "1") {
        var data = JSON.parse(results[1]);
        //alert(data.length);
        for (var i in data) {
            var position = new google.maps.LatLng(data[i].Centroid.Lat, data[i].Centroid.Lon);
            if (data[i].Projects.length === 1) {
                var marker = new google.maps.Marker({
                    position: position,
                    icon: "http://kel.tamu.edu/IconGenerator/IconGenerator.aspx?size=" + 20 + "&fill=BB6666&border=EE5555&borderW=2",
                    map: map,
                    //title: "ID: " + results[el].id + "\nLat: " + position.lat().toFixed(5) + ", Lon: " + position.lng().toFixed(5),
                });
                var infoWindow = this.setInfoWindowContentDiv(data[i], marker.getPosition());
                this.dots[marker.getPosition().lat().toFixed(5) + "_" + marker.getPosition().lng().toFixed(5)] = new Pin(marker, infoWindow, this.onMouseOverPin.bind(this, marker, infoWindow));
            } else {
                var marker = new google.maps.Marker({
                    position: position,
                    icon: "http://kel.tamu.edu/IconGenerator/IconGenerator.aspx?size=" + Math.max(35, parseInt(data[i].Projects.length / 100)) + "&fill=6666BB&border=5555EE&borderW=2&text=" + data[i].Projects.length,
                    map: map,
                    //title: "ID: " + results[el].id + "\nLat: " + position.lat().toFixed(5) + ", Lon: " + position.lng().toFixed(5),
                });
                google.maps.event.addListener(marker, 'click', this.handleDotOnClick.bind(this, data[i].Centroid));
                this.dots[marker.getPosition().lat().toFixed(5) + "_" + marker.getPosition().lng().toFixed(5)] = new Pin(marker);
            }
        }
    }
}

Queries.prototype.closeInfoWindow = function (index) {
    if (index === null || index === "")
        return;
    if (this.dots[index]) {
        this.dots[index].infoWindow.close();
        this.infoWindowIndex = "";
    }
}

Queries.prototype.setInfoWindowContentDiv = function (data, position) {
    var div = document.createElement("div");
    div.style.height = "50px";
    var span = document.createElement("span");
    span.innerHTML = "Address: " + data.Projects[0].Address + ", " + data.Projects[0].ZipCode;
    div.appendChild(span);
    
    var a = document.createElement("a");
    
    a.innerHTML = "<br/>Show Details";
    a.setAttribute("data-toggle", "modal");
    a.setAttribute("data-target", "#historymodal");
    div.appendChild(a);
    a.onclick = this.queryViolations.bind(this, data.Projects[0].HCAD);
    var infowindow = new google.maps.InfoWindow({ position: position, content: div });
    return infowindow;
}

Queries.prototype.fail = function (results) {
    alert("SHAME!");
}

/////////////////////////////////////////////////////////////////
/////////////////////Map Management Funcs////////////////////////
/////////////////////////////////////////////////////////////////

Queries.prototype.handleDotOnClick = function (LatLon) {
    //this.queryClusters(); Don't need because listener on zoom change handles
    map.setZoom(map.getZoom() + 1);
    map.panTo(new google.maps.LatLng(LatLon.Lat, LatLon.Lon));
}

Queries.prototype.clearMap = function () {
    this.closeInfoWindow(this.infoWindowIndex);
    for (var i in this.dots) {
        this.dots[i].marker.setMap(null);
    }
}

Queries.prototype.onMouseOverPin = function (marker, infoWindow) {
    this.closeInfoWindow(this.infoWindowIndex);
    this.infoWindowIndex = marker.getPosition().lat().toFixed(5) + "_" + marker.getPosition().lng().toFixed(5);
    infoWindow.open(map);
}

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
// This object stores a marker on the map and its associated info window.
function Pin(marker, infoWindow, onMouseOver) {
    this.marker = marker;
    this.infoWindow = infoWindow;
    if (onMouseOver)
        google.maps.event.addListener(this.marker, 'mouseover', onMouseOver);
};


/////////////////////////////////////////////////////////////////
//For populating the status list via the statuses available in the database
/////////////////////////////////////////////////////////////////

Queries.prototype.queryStatusList = function (HCAD) {
    AjaxCall(null,"GetHData.asmx/GetStatusList",this.populateStatusList.bind(this), this.fail.bind(this));
}

Queries.prototype.populateStatusList = function (results) {
    if (results[0] = "1") {
        var all_status = JSON.parse(results[1]);
        var status_container = $('#status_criteria');
        var status_template = Mustache.compile($.trim($("#status_template").html()));

        $.each(all_status, function (i, g) {
            status_container.append(status_template({ status: all_status[i].Project_Status }))
        });

        $('#status_criteria :checkbox').prop('checked', true);

        function handle_status() {
            $('#all_status').on('click', function (e) {
                $('#status_criteria :checkbox:gt(0)').prop('checked', $(this).is(':checked'));
            });
        }

        handle_status();
    }
}

/////////////////////////////////////////////////////////////////
//Modal stuff
/////////////////////////////////////////////////////////////////
Queries.prototype.queryViolations = function (HCAD) {
    var query = new Query(map.getBounds().getNorthEast().lat(), map.getBounds().getNorthEast().lng(), map.getBounds().getSouthWest().lat(), map.getBounds().getSouthWest().lng(), HCAD);
    AjaxCall(query, "GetHData.asmx/GetViolations", this.populateViolations.bind(this, HCAD), this.fail.bind(this));
}

Queries.prototype.populateViolations = function (HCAD, results) {
    if (results[0] = "1") {
        var div = document.getElementById("accordions");
        div.innerHTML = "";
        var data = JSON.parse(results[1]);

        var tmp = document.getElementById("prop-address");
        tmp.innerHTML = data[0].Merged_Situs + ", HOUSTON, TX " + data[0].ZipCode;
        var tmp = document.getElementById("subdivision");
        tmp.innerHTML = data[0].Subdivision;
        var tmp = document.getElementById("council-dist");
        tmp.innerHTML = data[0]["Council District"];
        var tmp = document.getElementById("map-canvas-history");
        tmp.src = "https://maps.google.com/maps?q=" + data[0].Merged_Situs + ", HOUSTON, TX " + data[0].ZipCode + "+(" + parseFloat(data[0].Latitude).toFixed(2) + "," + parseFloat(data[0].Longitude).toFixed(2) + ")@" + data[0].Latitude + "," + data[0].Longitude + "&layer=c&z=17&cbll=" + data[0].Latitude + "," + data[0].Longitude + "&cbp=13,276.3,0,0,0&output=svembed";
        var tmp = document.getElementById("hcad-link");
        tmp.href = "http://www.hcad.org/records/recorddetails.asp?taxyear=2014&acct=" + HCAD;


        var ids = new Object();
        for (var i in data) {
            if (ids[data[i].NPPRJId])
                continue;
            else {
                ids[data[i].NPPRJId] = true;
                this.injectAccordions(data, i, data[i].NPPRJId);
            }
        }
        this.queryActions(HCAD);
    }
}

Queries.prototype.queryActions = function (HCAD) {
    var query = new Query(map.getBounds().getNorthEast().lat(), map.getBounds().getNorthEast().lng(), map.getBounds().getSouthWest().lat(), map.getBounds().getSouthWest().lng(), HCAD);
    AjaxCall(query, "GetHData.asmx/GetActions", this.populateActions.bind(this), this.fail.bind(this));
}

Queries.prototype.populateActions = function (results) {
    if (results[0] = "1") {
        var data = JSON.parse(results[1]);
        for (var i in data) {
            this.getActionsTBody(data, i);
        }
    }
}

Queries.prototype.injectAccordions = function (data, ind, id) {
    var div = document.getElementById("accordions");
    var tb1 = this.getViolationsTBody(data, id);

    var type = "panel-info";
    if (data[ind].Project_Status == "OPEN")
        type = "panel-danger";

    var html =      '<div class="panel ' + type + '">' +
                        '<div class="panel-heading">' +
                            '<h4 class="panel-title"><a class="panel-toggle" data-toggle="collapse" data-parent="#accordions" href="#collapse-' + ind + "-" + id + '" id="case-num-' + ind + "-" + id + '">' + data[ind].NPPRJId + '</a></h4>' +
                        '</div>' +
                        '<div id="collapse-' + ind + "-" + id + '" class="panel-body collapse">' +
                            '<table class="table table-striped">' +
                                '<tr>' +
                                    '<td><strong>Project Date</strong></td>' +
                                    '<td><strong>Method Received</strong></td>' +
                                    '<td><strong>Status</strong></td>' +
                                '</tr>' +
                                '<tr>' +
                                    '<td>' +
                                        '<div id="project-date-' + data[ind].NPPRJId + '">' + parseDate(data[ind].RecordCreateDate) + '</div>' +
                                    '</td>' +
                                    '<td>' +
                                        '<div id="method-rec-' + data[ind].NPPRJId + '">' + data[ind].Received_Method + '</div>' +
                                    '</td>' +
                                    '<td>' +
                                        '<div id="status-' + data[ind].NPPRJId + '">' + data[ind].Project_Status + '</div>' +
                                    '</td>' +
                                '</tr>' +
                            '</table>' +
                            '<div class="panel-inner">' +

                                //<!-- Here we insert another nested accordion -->

                                '<div class="panel-group" id="accordion2">' +
                                    '<div class="panel ' + type + '">' +
                                        '<div class="panel-heading">' +
                                            '<h4 class="panel-title"><a class="panel-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseInner1-' + ind + "-" + id + '">Violations</a></h4>' +
                                        '</div>' +
                                        '<div id="collapseInner1-' + ind + "-" + id + '" class="panel-body collapse">' +
                                            '<div class="panel-inner">' +
                                                '<table class="table table-striped">' +
                                                '<thead>' +
                                                    '<tr>' +
                                                        '<td><strong>Violation Category</strong></td>' +
                                                        '<td><strong>Ordinance Violated</strong></td>' +
                                                        '<td><strong>Ordinance Description</strong></td>' +
                                                        '<td><strong>Deadline Date</strong></td>' +
                                                        '<td><strong>Check Back Date</strong></td>' +
                                                    '</tr>' +
                                                    '</thead>' +
                                                    tb1 +
                                                '</table>' + 
                                            '</div>' + 
                                        '</div>' + 
                                    '</div>' +


                                    '<div class="panel ' + type + '">' + 
                                        '<div class="panel-heading">' +
                                            '<h4 class="panel-title"><a class="panel-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseInner2-' + ind + "-" + id + '">Actions</a></h4>' +
                                        '</div>' +
                                        '<div id="collapseInner2-' + ind + "-" + id + '" class="panel-body collapse">' +
                                            '<div class="panel-inner">' + 
                                                '<table class="table table-striped"><thead>' + 
                                                    '<tr>' +
                                                        '<td><strong>Action Type</strong></td>' + 
                                                        '<td><strong>Date</strong></td>' +
                                                        '<td><strong>Action Description</strong></td>' + 
                                                        '<td><strong>Comments</strong></td>' + 
                                                    '</tr></thead>' +
                                                    '<tbody id="actions-' + id + '"></tbody>' +
                                                '</table>' +
                                            '</div>' +
                                        '</div>' + 
                                    '</div>' + 
                                '</div>'+ 

                                //<!-- Inner accordion ends here -->

                            '</div>' + 
                        '</div>' +
                    '</div>';
    div.innerHTML += html;
}

Queries.prototype.getViolationsTBody = function (data, id) {
    var tbody = document.createElement("tbody");
    for (var i in data) {
        if (data[i].NPPRJId === id) {
            var tr = document.createElement("tr");
            tbody.appendChild(tr);

            var td = document.createElement("td");
            td.innerHTML = data[i].Violation_Category;
            tr.appendChild(td);
            var td = document.createElement("td");
            td.innerHTML = data[i].Ordno;
            tr.appendChild(td);
            var td = document.createElement("td");
            td.innerHTML = data[i].ShortDes;
            tr.appendChild(td);
            var td = document.createElement("td");
            td.innerHTML = parseDate(data[i].DeadLineDate);
            tr.appendChild(td);
            var td = document.createElement("td");
            td.innerHTML = parseDate(data[i].CheckBackDate);
            tr.appendChild(td);
        }
    }
    return tbody.outerHTML;
}

Queries.prototype.getActionsTBody = function (data, ind) {
    var tbody = document.getElementById("actions-" + data[ind].NPPRJId);
    var tr = document.createElement("tr");
    tbody.appendChild(tr);

    var td = document.createElement("td");
    td.innerHTML = data[ind].Action_Type;
    tr.appendChild(td);
    var td = document.createElement("td");
    td.innerHTML = parseDate(data[ind].Date);
    tr.appendChild(td);
    var td = document.createElement("td");
    td.innerHTML = data[ind].Action;
    tr.appendChild(td);
    var td = document.createElement("td");
    td.innerHTML = data[ind].Comments;
    tr.appendChild(td);
}

function parseDate(date) {
    return date.split(" ")[0];
}