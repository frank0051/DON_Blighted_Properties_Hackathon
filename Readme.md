# City of Houston Blighted Properties

The City of Houston Blighted Properties website is an <a href="//ohouston.org" target="_blank">Open Houston</a> project that was conceptualized at a City of Houston sponsored <a href="//houstonhackathon.com" target="_blank">Hackathon</a>.</p>
Data presented here is solely for information purposes and shall not be considered accurate, factual, or complete. Download your copy of the Department of Neighborhoods code enforcement violation files at <a href="http://data.ohouston.org/dataset/city-of-houston-building-code-enforcement-violations-don" target="_blank">http://data.ohouston.org/dataset/city-of-houston-building-code-enforcement-violations-don</a></p>

## <a name="why"></a>Why does this matter?

City Council members and citizens regularly ask for information about blighted properties and nuisances. To do so, they have to contact City staff and even wait on public records requests. Using City of Houston Blighted Properties, we wanted to allow citizens and Council members a more proactive way to see what's going on in their neighborhood.

## <a name="TeamMembers"></a>Team Members
 - City of Houston 2nd Annual Open Innovation Hackathon Team Members
 - May 31 - June 1, 2014
 - Frank Bracco - City of Houston, Texas
 - Jonathan Farmer - City of Stafford, Texas
 - Reza H. Teshnizi - Texas A&M University
 - Raghuveer Modala - Texas A&M University
 - Elvis Takow - Texas A&M University

Prototype completed in 18 1/2 hours!

## <a name="Video"></a>Video
http://www.screencast.com/t/3qKVe3vyPTP

## <a name="Technology"></a>Technology Used
- Created in Visual Studio 2012
- ASP .Net with C# is used for the server-side programming (serving out JSON data)
- Microsoft SQL Server
- HTML, CSS3, Javascript for the client-side scripting, with AJAX to call JSON web services
- Google Maps API
- Data files posted at http://data.ohouston.org/dataset/city-of-houston-building-code-enforcement-violations-don (All Projects, All Project Level Actions, All Project Inspections, and All Violations) - some additional lat and long scripting was done

## <a name="To-Do"></a>To-Do
- Clean up lat and long geocoding - NAD27 State Plane Texas S Central 4204 feet is used in DON Forms system, but the accuracy is not good
- Provide some additional search and filtering on the main page (Service Request Number, Council District, submission date, etc.)
- Code documentation and clean-up.

##<a name="Bugs"></a>Possible Bugs
- When zoomed in at the max level there appears to be a potential for a blue dot to still appear (i.e. point clustering still occurring). Need to verify and figure out how to treat.


Last Updated: June 6, 2014
