package actions;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.struts2.ServletActionContext;

import com.google.gson.Gson;
import com.opensymphony.xwork2.ActionSupport;

import ilidpe.persistence.Batiment;
import ilidpe.persistence.BatimentTDG;
import jakarta.servlet.http.HttpServletResponse;

public class ListDPEAction extends ActionSupport {
    private long idVille = -1;
    private long idRue = -1;
    private int numero = -1;
    private List<Batiment> batiments;

    public String execute() {
    	BatimentTDG btdg = (BatimentTDG) ServletActionContext.getServletContext().getAttribute("btdg");
        try {
        	if (idVille == -1 && idRue == -1 && numero == -1) batiments = new ArrayList<Batiment>();
        	else if (idVille != -1 && idRue == -1 && numero == -1) 
        		batiments = btdg.selectWhere("VILLE_ID = ?", idVille);
        	else if (idVille != -1 && idRue != -1 && numero == -1)
        		batiments = btdg.selectWhere("VILLE_ID = ? AND RUE_ID = ?", idVille, idRue);
        	else batiments = btdg.selectWhere("VILLE_ID = ? AND RUE_ID = ? AND NUMERO = ?", idVille, idRue, numero);
		} catch (SQLException e) {
			batiments = new ArrayList<Batiment>();
		}
        Gson gson = new Gson();
        String json = gson.toJson(batiments);
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setContentType("application/json");
        try {
            response.getWriter().write(json);
        } catch (IOException e) {
            return "";
        }
        return null;
    }

    public long getIdVille() {
        return idVille;
    }
    public void setIdVille(long idVille) {
        this.idVille = idVille;
    }
    
    public long getIdRue() {
        return idVille;
    }
    public void setIdRue(long idRue) {
        this.idRue = idRue;
    }
    
    public long getNumero() {
        return numero;
    }
    public void setNumero(int numero) {
        this.numero= numero;
    }

    public List<Batiment> getBatiments() {
        return batiments;
    }
}
