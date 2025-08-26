package actions;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

import ilidpe.persistence.BatimentTDG;
import ilidpe.persistence.Rue;
import ilidpe.persistence.RueTDG;

public class RueAction extends ActionSupport {
	List<Rue> rues;
	private String error;
    @Override
    public String execute() throws Exception {
    	RueTDG rtdg = (RueTDG) ServletActionContext.getServletContext().getAttribute("rtdg");
    	rues = rtdg.selectWhere("ID >= 0");
        Collections.sort(rues, new Comparator<Rue>() {
            @Override
            public int compare(Rue rue1, Rue rue2) {
                return rue1.getNom().compareTo(rue2.getNom());
            }
        });
        return SUCCESS;
    }
    public List<Rue> getRues() {
    	return rues;
    }
    public String getError() {
    	return error;
    }
    public void setError(String error) {
    	this.error = error;
    }
}
