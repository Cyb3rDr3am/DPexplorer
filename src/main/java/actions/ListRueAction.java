package actions;

import ilidpe.persistence.CodePostal;
import ilidpe.persistence.CodePostalTDG;
import ilidpe.persistence.Ville;
import ilidpe.persistence.VilleTDG;
import ilidpe.persistence.Rue;
import ilidpe.persistence.RueTDG;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import com.google.gson.Gson;


public class ListRueAction extends ActionSupport {
    private long idVille;
    private List<Rue> rues;

    public String execute() {
        VilleTDG vtdg = (VilleTDG) ServletActionContext.getServletContext().getAttribute("vtdg");
        try {
			rues = vtdg.getRuesByVilleId(idVille);
		} catch (SQLException e) {
			rues = new ArrayList<Rue>();
		}
        Gson gson = new Gson();
        String json = gson.toJson(rues);
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

    public void setIdVille(long idCodePostal) {
        this.idVille = idCodePostal;
    }

    public List<Rue> getRues() {
        return rues;
    }
}