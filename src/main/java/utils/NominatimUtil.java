package utils;

import com.google.gson.JsonArray;
import com.google.gson.JsonParser;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

public class NominatimUtil {
    private static final String BASE_URL =  "https://nominatim.openstreetmap.org/search";
    private static final HttpClient client = HttpClient.newHttpClient();
    private static  long lastCallTime = 0;

    public static double[] geocode(String addressDetail,String ward,String district,String province) {
        String[][] attemps = {{addressDetail,ward,district,province,"Vietnam"},
                {ward,district,province,"Vietnam"},
                {district,province,"Vietnam"},
                {province,district,"Vietnam"}};
        for(String[] parts :attemps) {
            try {
                long elapsed = System.currentTimeMillis() - lastCallTime;
                if (elapsed < 10000) {
                    Thread.sleep(10000 - elapsed);
                }
                lastCallTime = System.currentTimeMillis();
                String q = String.join(", ", parts);
                String url = BASE_URL + "?q=" + URLEncoder.encode(q, StandardCharsets.UTF_8) + "&format=json&limit=1";
                HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).header("User-Agent", "SweetOvenBakery/1.0(sweetoven@gmail.com").GET().build();

                HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
                JsonArray arr = JsonParser.parseString(response.body()).getAsJsonArray();
                if (arr.size() > 0) {
                    double lat = arr.get(0).getAsJsonObject().get("lat").getAsDouble();
                    double lng = arr.get(0).getAsJsonObject().get("lon").getAsDouble();
                    return new double[]{lat, lng};
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }
}
