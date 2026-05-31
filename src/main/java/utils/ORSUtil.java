package utils;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


public class ORSUtil {
    private static final String API_KEY = "eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjQxMmE1MzRkZjA3ZjRiODU5ZjhmMTgzMTFiY2VhMjMzIiwiaCI6Im11cm11cjY0In0=";
    private static final String URL = "https://api.openrouteservice.org/v2/directions/driving-car";
    private static final HttpClient client = HttpClient.newHttpClient();
    private static final Map<Integer,double[]> routeCache= new ConcurrentHashMap<>();

    public static void clearCache(int addressId){
        routeCache.remove(addressId);
    }
    public static double[] getCached(int addressId){
        return routeCache.get(addressId);
    }
    public  static double[] getRoute(int addressId,double fromLat, double fromLng, double toLat, double toLng){
        if(routeCache.containsKey(addressId)){
            return routeCache.get(addressId);
        }
        try {
            String body =String.format(java.util.Locale.US, "{\"coordinates\": [[%f,%f],[%f,%f]]}",
                    fromLng, fromLat, toLng, toLat);
            HttpRequest request = HttpRequest.newBuilder().uri(URI.create(URL)).timeout(Duration.ofSeconds(8))
                    .header("Authorization",API_KEY).header("Content-Type","application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(body)).build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());


            JsonObject root = JsonParser.parseString(response.body()).getAsJsonObject();
            JsonObject summary = root.getAsJsonArray("routes").get(0).getAsJsonObject().getAsJsonObject("summary");

            double distanceKm = summary.get("distance").getAsDouble()/1000.0;
            double durationMin = summary.get("duration").getAsDouble()/60.0;

            double[] result = new double[]{distanceKm,durationMin};

            if(addressId>0){
                routeCache.put(addressId, result);
            }
            return result;

        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }



}
