class KeenIO {
    _baseUrl = "https://api.keen.io/3.0/projects/";
    
    _projectId = null;
    _apiKey = null;
    
    constructor(projectId, apiKey) {
        _projectId = projectId;
        _apiKey = apiKey;
    }
    
    /***************************************************************************
    * Parameters: 
    *   eventCollection - the name of the collection you are pushing data to
    *   data - the data you are pushing
    *   cb - an optional callback to execute upon completion
    *
    * Returns: 
    *   HTTPResponse - if a callback was NOT specified  
    *   None - if a callback was specified
    ***************************************************************************/
    function sendEvent(eventCollection, data, cb = null) {
        local url = _buildUrl(eventCollection);
        local headers = {
            "Content-Type": "application/json"
        };
        local encodedData = http.jsonencode(data);
        server.log(encodedData);
        
        local request = http.post(url, headers, encodedData);
        
        // if a callback was specificed
        if (cb == null) {
            return request.sendsync();
        } else {
            request.sendasync(cb);
        }
    }
    
    /***************************************************************************
    * Parameters: 
    *   ts - the unix timestamp of the event
    *   millis - optional parameter to specify the milliseconds of the timestamp
    *
    * Returns: 
    * 	A formated KeenIO timestamp that can be inserted into the Keen event
    ***************************************************************************/    
    function getTimestamp(ts, millis = 0) {
        local m = ((millis % 1000) + "000000").slice(0, 6);
        local d = date(ts);
    
        return format("%04i-%02i-%02iT%02i:%02i:%02i.%sZ", d.year, d.month+1, d.day, d.hour, d.min, d.sec, m);
    }
    

    /*************** Private Functions - (DO NOT CALL EXTERNALLY) ***************/
    function _buildUrl(eventCollection, projectId = null, apiKey = null) {
        if (projectId == null) projectId = _projectId;
        if (apiKey == null) apiKey = _apiKey;
        
        
        local url = _baseUrl + projectId + "/events/" + eventCollection + "?api_key=" + apiKey;
        return url;
    }
}
