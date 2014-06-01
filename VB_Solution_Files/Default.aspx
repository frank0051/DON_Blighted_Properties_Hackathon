<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Houston Hackathon Blight Status</title>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <%--<link rel="stylesheet" href="css/bootstrap-theme.min.css">--%>
    <link rel="stylesheet" href="css/main.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
    <div id="wrap">
        <img src="img/header.jpg" alt="Header Image" class="header-img">
        <nav class="navbar navbar-inverse" role="navigation">
            <div class="container-fluid">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <!--<a class="navbar-brand" href="#">Brand</a>-->
                </div>

                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="index.html">Home</a></li>
                        <li><a href="#">I want to...</a></li>
                        <li><a href="#">Government</a></li>
                        <li><a href="#">Residents</a></li>
                        <li><a href="#">Business</a></li>
                        <li><a href="#">Departments</a></li>
                        <li><a href="#">Visitors</a></li>
                        <li><a href="#">En Espanol</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="#myModal" data-toggle="modal" data-target="#myModal">About This Site</a></li>
                    </ul>
                </div>
                <!-- /.navbar-collapse -->
            </div>
            <!-- /.container-fluid -->
        </nav>

        <div class="modal fade bs-example-modal-lg" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <img src="img/header.jpg" class="modal-title">
                    </div>
                    <div class="modal-body">
                        <h3 align="center">About This Site</h3>
                        <p align="center">
                            <a href="http://www.houstontx.gov" target="_blank">
                                <img src="img/houstonblackandbwhite.png" alt="City Seal" width="200" height="202" border="0" /></a> <a href="http://ohouston.org" target="_blank">
                                    <img src="img/robot-head.png" alt="Open Houston" /></a>
                        </p>
                        <p></p>
                        <p>The City of Houston Blighted Properties website is an <a href="//ohouston.org" target="_blank">Open Houston</a> project that was conceptualized at a City of Houston sponsored <a href="//houstonhackathon.com" target="_blank">Hackathon</a>.</p>
                        Data presented here is solely for information purposes and shall not be considered accurate, factual, or complete. Download your copy of the Department of Neighborhoods code enforcement violation files at <a href="http://data.ohouston.org/dataset/city-of-houston-building-code-enforcement-violations-don" target="_blank">http://data.ohouston.org/dataset/city-of-houston-building-code-enforcement-violations-don</a></p>
		
		<h4>
            <center>City of Houston 2nd Annual Open Innovation Hackathon Team Members<br/>May 31 - June 1, 2014</center>
        </h4>
                        <ul>
                            <li>Frank Bracco - City of Houston, Texas</li>
                            <li>Jonathan Farmer - City of Stafford, Texas</li>
                            <li>Reza H. Teshnizi - Texas A&M University</li>
                            <li>Raghuveer Modala - Texas A&M University</li>
                            <li>Elvis Takow - Texas A&M University</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            <span class="blight-text">
                <center>City of Houston Blighted Properties</center>
            </span>
            <div class="row">
                <div class="overall-container">
                    <div class="navbar-form">
                        <form role="search">
                            <div class="form-group">
                                <input type="text" class="form-control search-form" placeholder="Enter An Address...">
                            </div>
                            <a href="http://www.hcad.org/records/recorddetails.asp?taxyear=2014&acct=1158160010016" class="search-btn">
                                <button type="submit" class="btn btn-primary">
                                Search</a></button>
                        </form>
                    </div>
                    <div class="map-container pull-left">
                        <div id="map-canvas"></div>
                    </div>
                    <div class="instructions-container pull-right">
                        <h4>How to use this site:</h4>
                        <p>The Department of Neighborhoods Inspections & Public Service (IPS) enforces <a href="https://library.municode.com/HTML/10123/level2/COOR_CH10BUNEPR.html">Chapter 10</a> of the City of Houston Code of Ordinances. Violations under this section include Open and vacant buildings, nuisances on private property, junk motor vehicles, weeded lots, and graffiti.</p>
                        <p>You use this map to see open code enforcement violations in the City of Houston. You can either use the search bar to center on an address to get started, or you can pan and zoom like you normally would in Google Maps. Once you get down to a propert you want to learn more about, click on the marker to see the property history.</p>
                        <div class="modal fade bs-example-modal-lg" id="historymodal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <img src="img/header.jpg" class="modal-title">
                                    </div>
                                    <div class="modal-body">
                                        <div class="container">
                                            <div class="row">
                                                <div class="overall-container">
                                                    <div class="map-container-history">
                                                        <iframe src="https://maps.google.com/maps?q=29.6779632551104,-95.4769135246223&layer=c&z=17&sll=%3CLatitude%3E,%3CLongitude%3E&cbp=13,276.3,0,0,0&cbll=29.6779632551104,-95.4769135246223&hl=en&ved=0CAoQ2wU&sa=X&output=svembed&layer=c" id="map-canvas-history"></iframe>
                                                        <a id="hcad-link" class="btn btn-primary btn-block hcad-button" href="#" target="_blank">View Property Information on HCAD</a>
                                                    </div>
                                                    <div class="history-container">
                                                        <h3 class="text-warning">
                                                            <center>Property History</center>
                                                        </h3>
                                                        <div>
                                                            <h4 class="text-warning">
                                                                <center id="prop-address"></center>
                                                            </h4>
                                                        </div>
                                                        <table class="table table-striped">
                                                            <tr>
                                                                <td><strong>Subdivision</strong></td>
                                                                <td id="subdivision"></td>
                                                                <td><strong>Council District</strong></td>
                                                                <td id="council-dist"></td>
                                                            </tr>
                                                            <tr>

                                                            </tr>
                                                        </table>

                                                        <h3 class="text-primary">Cases</h3>
                                                        <div class="panel-group" id="accordions"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="footer">
            <div class="container">
                <ul class="nav navbar-nav">
                    <li><a href="index.html">Home</a></li>
                    <li><a href="#">311 Help and Info</a></li>
                    <li><a href="#">En Espanol</a></li>
                    <li><a href="#">Contact Us</a></li>
                    <li><a href="#">FAQs</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Citizens Net</a></li>
                    <li><a href="#">Login</a></li>
                </ul>
            </div>
        </div>

    </div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="Scripts/Queries.js"></script>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
    <script type="text/javascript">
        var map;
        var queries;
        function initialize() {
            var mapOptions = { zoom: 10, center: new google.maps.LatLng(29.762354, -95.365586) };
            map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
            queries = new Queries();
            setTimeout(queries.queryClusters.bind(queries), 500);
        }
        google.maps.event.addDomListener(window, 'load', initialize);
        Date.prototype.getShortDate = function () {
            return this.getMonth() +
            "/" + this.getDate() +
            "/" + this.getFullYear();
        }
    </script>
</body>
</html>
