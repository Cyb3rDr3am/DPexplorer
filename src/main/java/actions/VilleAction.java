package actions;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

import ilidpe.persistence.BatimentTDG;
import ilidpe.persistence.Rue;
import ilidpe.persistence.RueTDG;
import ilidpe.persistence.Ville;
import ilidpe.persistence.VilleTDG;

public class VilleAction extends ActionSupport {
	private List<Ville> villes;
	private String error;
    @Override
    public String execute() throws Exception {
    	VilleTDG vtdg = (VilleTDG) ServletActionContext.getServletContext().getAttribute("vtdg");
    	villes = vtdg.selectWhere("ID >= 0");
        Collections.sort(villes, new Comparator<Ville>() {
            @Override
            public int compare(Ville ville1, Ville ville2) {
                return ville1.getNom().compareTo(ville2.getNom());
            }
        });
        return SUCCESS;
    }
    public List<Ville> getVilles() {
    	return villes;
    }
    public String getError() {
    	return error;
    }
    public void setError(String error) {
    	this.error = error;
    }
}
