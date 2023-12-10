.pragma library


/*
 * Librairie construite à partir du tutorial Felgo suivant:
 * https://blog.felgo.com/cross-platform-app-development/access-rest-services-qt-felgo-weather-service-example-app-open-source#spoiler-basic-rest-example-with-v-play
 */

function requestAPI()
{
    // Every REST request creates a new instance.
    const xhr = new XMLHttpRequest()

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED)
        {
            console.log(xhr.getResponseHeader("status"));
        }
        else if(xhr.readyState === XMLHttpRequest.DONE)
        {
            print('DONE')
            console.log(xhr.responseText.toString());
            // Process received data
            const response = JSON.parse(xhr.responseText.toString())
            // Set JS object as model for listview
            // view.model = response.items
            console.log(response);
        }
    }

    // Set the Target URL & Request Properties  (GET, POST, DELETE, UPDATE)
    // In the case of a GET request, the parameters are part of the URL
//    sendtoFlicker(xhr);
//    sendtoWeather(xhr);
      sendtoDeepAI(xhr);
}

/*!
 * Example 1 : Envoi d'une requète GET au site Flikr.
 * \returns a JSON document with a list of photos.
 */
function sendtoFlicker(xhr)
{
    xhr.open("GET", "http://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=Ibiza");
    xhr.send();
}



/*!
 * Example 2 : Envoi d'une requète GET au site openWeatherMap.
 * Une API KEY est nécessaire. Il faut s'incrire sur le site.
 * \returns a JSON document with the whether at the given place.
 */
function sendtoWeather(xhr)
{
    var params = "q=" + "Ibiza" + "&units=metric&appid=" + "YOUR-API-KEY"
    xhr.open("GET", "http://api.openweathermap.org/data/2.5/weather?" + params);
    xhr.send();

}

/*!
 * Example 3 : Envoi d'une requète POST au site deepAI.
 * Une API KEY est nécessaire. Il faut s'incrire sur le site.
 * \returns a JSON document with the url of the generated image.
  {
    "id": "3699d95e-xxxx-xxxx-xxxx-e3edc05f9eea",
    "output_url": "https://api.deepai.org/job-view-file/3699d95e-f61b-4c38-b1f7-e3fdc04f9eea/outputs/output.jpg"
 }
 */
function sendtoDeepAI(xhr)
{
    // exemple 3: deepAI
    var deepai_url = "https://api.deepai.org/api/";
    var deepai_style = "cyberpunk-generator";
    var url = deepai_url + deepai_style;
    console.debug(url);

    var api_key = "quickstart-QUdJIGlzIGNvbWluZy4uLi4K";
    var keywords = "sailing goelette on deep sea, at dusk, in the storm" // "Panasonic camera, DMC-TZ10 model, on a uniform light-green background";
    var params = JSON.stringify({text: keywords
                                    , grid_size: "1"
                                })

    console.debug(params);

    xhr.open("POST", url, true);   // async = true

    // Send the proper header information along with the request
    xhr.setRequestHeader("Content-type", "application/json");
//    xhr.setRequestHeader("Content-length", params.length);
    xhr.setRequestHeader("Connection", "close");
    xhr.setRequestHeader("api-key", api_key);

    xhr.send(params);

}

