function ping() 
{
    // Send a 'ping' message to the server with the current millis counter
    
    agent.send("ping", hardware.millis());
}

function return_from_imp(startMillis)
{
    // Handle a 'pong' message from the server
 
    // Get the current time
    local endMillis = hardware.millis();
    
    // Calculate how long the round trip took
    local diff = endMillis - startMillis;
    
    // Log it
    server.log("Round trip took: " + diff + "ms");
    
    // Log it to keen
    agent.send("log", diff);
    
    // Wake up in 5 seconds and ping again
    imp.wakeup(5.0, ping);
}

agent.on("pong", return_from_imp);

ping();
