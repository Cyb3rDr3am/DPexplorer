package actions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

import jakarta.servlet.http.HttpServletResponse;

public class CoordinatesMapAction extends ActionSupport {
	private String adresse;
	private String coordinates;
	
	public String execute() {
        try {
            String encodedAddress = java.net.URLEncoder.encode(adresse, "UTF-8");
            String apiUrl = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodedAddress;
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
 
            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line;

            while ((line = reader.readLine()) != null) {
                if (line.contains("lat") && line.contains("lon")) {
                	String lat = line.split("lat\":\"")[1].split("\"")[0];
                	String lon = line.split("lon\":\"")[1].split("\"")[0];
                	coordinates = "{\"lat\": " + lat + ", \"lon\": " + lon + "}";
                	break;
                }
            }
            reader.close();
            if (coordinates == null) coordinates = "{\"lat\": -1, \"lon\": -1}";

        } catch (Exception e) {
        	coordinates = "{\"lat\": -1, \"lon\": -1}";
        }
        HttpServletResponse httpResponse = ServletActionContext.getResponse();
        httpResponse.setContentType("application/json");
        try {
            httpResponse.getWriter().write(coordinates);
        } catch (IOException e) {
            return ""; 
        }
        return null;
    }
    
    public String getCoordinates() {
        return coordinates;
    }
    public String getAdresse() {
        return adresse;
    }
    public void setAdresse(String adresse) {
        this.adresse= adresse;
    }
}
