<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>City of Houston Nuisance Tracker</title>

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

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>

    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
    <script src="js/mustache.js"></script>
    <script type="text/javascript" src="Scripts/Queries.js"></script>
    <script type="text/javascript" src="Scripts/shrink.js"></script>
    <script type="text/javascript" src="Scripts/initialize.js"></script>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=places"></script>

</head>
<body onload="initialize()">

    <div id="wrap">
        <div id="load_image"></div>
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
                        <li class="active"><a href="http://houstontx.gov/">Home</a></li>
                        <li><a href="http://houstontx.gov/iwantto/">I want to...</a></li>
                        <li><a href="http://houstontx.gov/residents/">Government</a></li>
                        <li><a href="http://houstontx.gov/residents/">Residents</a></li>
                        <li><a href="http://houstontx.gov/business/">Business</a></li>
                        <li><a href="http://houstontx.gov/departments">Departments</a></li>
                        <li><a href="http://houstontx.gov/visitors/">Visitors</a></li>
                        <li><a href="http://houstontx.gov/espanol/">En Espanol</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="#myModal" data-toggle="modal" data-target="#myModal">About This Site</a></li>
                    </ul>
                </div>
                <!-- /.navbar-collapse -->
            </div>
            <!-- /.container-fluid -->
        </nav>
        <div class="container-fluid blight-text" style="text-align: center;">City of Houston Nuisance Tracker</div>
               
        <div class="container-fluid" style="padding: 0px;">

                <div class="overall-container">

                    <div class="instructions-container pull-left" id="instructions-container">

                        <!-- create tabs -->
                        <div class="text-center" style="border-width: 1px 0px 1px; border-style: outset none inset;">
                            <ul class="nav nav-pills center-pills">
				                <li id='welcomeTab' class="active"><a onclick="selectWelcome()">Welcome</a></li>
				                <li id='filtersTab'><a onclick="selectFilters()">Filters</a></li>
                                <li class="pull-right desktop-only"><a onclick="sidebarToggle()"><img src="img/left_arrow.png" alt="Hide Panel" title="Hide Panel" height="21"></a></li>
			                </ul>
                            
                        </div>

                        <div id="welcomeContent" style="padding: 10px">
                            <h4>How to use this site:</h4>
                            <p class="welcome-text">The Department of Neighborhoods Inspections & Public Service (IPS) enforces <a href="https://library.municode.com/HTML/10123/level2/COOR_CH10BUNEPR.html">Chapter 10</a> of the City of Houston Code of Ordinances. Violations under this section include Open and vacant buildings, nuisances on private property, junk motor vehicles, weeded lots, and graffiti.</p>
                            <p class="welcome-text">You use this map to see open code enforcement violations in the City of Houston. You can either use the search bar to center on an address to get started, or you can pan and zoom like you normally would in Google Maps. Once you get down to a propert you want to learn more about, click on the marker to see the property history.</p>

                            <button type="button" class="btn btn-primary" onclick="selectFilters()">Onward to filters!</button>
                        </div>
                        <form runat="server" role="form">
                            <div id="filtersContent" style="padding: 10px; display:none;" class="panel-group">
                                <p>Use the collapsible menus below to filter the map. </p>

                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h4 class="panel-title"><a data-toggle="collapse" data-parent="#filtersContent" href="#status_criteria">Project Status</a></h4>
                                    </div>
                                    <div id="status_criteria" class="panel-collapse collapse in">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" value="All" id="all_status" /> All
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h4 class="panel-title"><a data-toggle="collapse" data-parent="#filtersContent" href="#311_criteria">311 Service Request Search</a></h4>
                                    </div>
                                    <div class="form-group panel-collapse collapse" id="311_criteria">
                                        <input type="text" id="SR_Number" placeholder="Service Request ID" class="form-control" style="margin-top:6px;" />
                                        <p class="help-block">Enter all or part of the 311 SR number. You can use % for wildcard searches.</p>
                                        <ul class="help-block"><li>For SR numbers prior to November 2011, enter the SR number with a dash after the first two year digits. Ex. 08-00130544.</li>
                                        <li>For SR numbers from November 2011 forward, drop the leading zero and dash. Ex. 101001311366 instead of 0-101001311366.</li>
                                        <li>When in doubt, enter % before/after all or part of the SR number. Ex. %101001311366% or %11366%.</li>
                                        </ul>
                                    </div>
                                </div>

                                <div class="panel panel-primary">
                                    <div class="panel panel-heading">
                                        <h4 class="panel-title"><a data-toggle="collapse" data-parent="#filtersContent" href="#hcad_criteria">HCAD Property Account Number</a></h4>
                                    </div>

                                    <div class="form-group panel-collapse collapse" id="hcad_criteria">
                                        <input type="text" id="HCAD_account" placeholder="HCAD Account Number" class="form-control" style="margin-top:6px;" />
                                        <p class="help-block">Enter all or part of the HCAD acount number without dashes or spaces. You can use % for wildcard searches.</p>
                                    </div>
                                </div>

                                <div class="panel panel-primary">
                                    <div class="panel panel-heading">
                                        <h4 class="panel-title"><a data-toggle="collapse" data-parent="#filtersContent" href="#council_criteria">Council District</a></h4>
                                    </div>
                                    <div id="council_criteria" class="panel-collapse collapse">
                                        <div class="checkbox">
                                        <label>
                                            <input type="checkbox" value="All" id="all_districts" /> All
                                        </label>
                                        </div>
                                    </div>
                                </div>

                                <button id="filter-submit" type="button" onclick="filters_submit()" class="btn btn-primary center-block" style="margin-top:6px;">Search</button>

                                <script id="council_template" type="text/html">
                                <div class="checkbox">
                                <label>
                                    <input type="checkbox" value="{{district}}" /> {{district}}
                                </label>
                                </div>
                                </script>

                                <script id="status_template" type="text/html">
                                <div class="checkbox">
                                <label>
                                    <input type="checkbox" value="{{status}}" /> {{status}}
                                </label>
                                </div>
                                </script>

                            </div>
                        </form>
                   </div>
                
                    <div class="map-container pull-right" id="map-container">
                        <input id="pac-input" type="text" class="controls" placeholder="Enter an address to zoom to and hit enter...">
                        <img src="img/right_arrow.png" alt="Show Panel" onclick="sidebarToggle()" title="Show Panel" id="show_panel" class="show_panel">
                        <div id="map-canvas">
                        </div>
                    </div>
                
                </div>
        </div>
    </div>

    <!--*******************************************
        -------Property History Modal ------------ 
     **********************************************   
     -->

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
                                    <h3 class="text-warning text-center">
                                        Property History
                                    </h3>
                                    <div>
                                        <h4 class="text-warning text-center" id="prop-address"></h4>
                                    </div>
                                    <table class="table table-striped">
                                        <tr>
                                            <td><strong>Subdivision</strong></td>
                                            <td id="subdivision"></td>
                                            <td><strong>Council District</strong></td>
                                            <td id="council-dist"></td>
                                        </tr>
                                        <tr>
                                            <td><strong>HCAD Number</strong></td>
                                            <td id="hcad_number_display"></td>
                                            <td><strong>311 SR Number</strong></td>
                                            <td id="sr_number_display"></td>
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


    <!--*******************************************
        ------- About Us Modal ------------ 
     **********************************************   
     -->

    <div class="modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <img src="img/header.jpg" class="modal-title">
                </div>
                <div class="modal-body">
                    <h3 class="text-center">About This Site</h3>
                    <p class="text-center">
                        <a href="http://www.houstontx.gov" target="_blank">
                            <img src="img/houstonblackandbwhite.png" alt="City Seal" width="200" height="202" border="0" /></a> <a href="http://ohouston.org" target="_blank">
                                <img src="img/robot-head.png" alt="Open Houston" /></a>
                    </p>
                    <p></p>
                    <p>The City of Houston Nuisance Tracker website is an <a href="//ohouston.org" target="_blank">Open Houston</a> project that was conceptualized at a City of Houston sponsored <a href="//houstonhackathon.com" target="_blank">Hackathon</a>.</p>
                    <p>Data presented here is solely for information purposes and shall not be considered accurate, factual, or complete. Download your copy of the Department of Neighborhoods code enforcement violation files at <a href="http://data.ohouston.org/dataset/city-of-houston-building-code-enforcement-violations-don" target="_blank">http://data.ohouston.org/dataset/city-of-houston-building-code-enforcement-violations-don</a></p>
		
                    <h4 class="text-center">
                        City of Houston 2nd Annual Open Innovation Hackathon Team Members<br/>May 31 - June 1, 2014
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

</body>
</html>
