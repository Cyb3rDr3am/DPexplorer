package actions;

import ilidpe.persistence.CodePostal;
import ilidpe.persistence.CodePostalTDG;
import ilidpe.persistence.Ville;
import ilidpe.persistence.VilleTDG;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import com.google.gson.Gson;


public class ListVilleAction extends ActionSupport {
    private long idCodePostal;
    private List<Ville> villes;

    public String execute() {
        VilleTDG vtdg = (VilleTDG) ServletActionContext.getServletContext().getAttribute("vtdg");
        try {
			villes = vtdg.selectWhere("CODE_POSTAL_ID = ?", idCodePostal);
		} catch (SQLException e) {
			villes = new ArrayList<Ville>();
		}
        Gson gson = new Gson();
        String json = gson.toJson(villes);
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setContentType("application/json");
        try {
            response.getWriter().write(json);
        } catch (IOException e) {
            return "";
        }
        return null;
    }

    public long getIdCodePostal() {
        return idCodePostal;
    }

    public void setIdCodePostal(long idCodePostal) {
        this.idCodePostal = idCodePostal;
    }

    public List<Ville> getVilles() {
        return villes;
    }
}