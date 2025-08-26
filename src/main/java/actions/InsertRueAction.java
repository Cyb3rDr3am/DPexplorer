package actions;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

import ilidpe.persistence.BatimentTDG;
import ilidpe.persistence.Rue;
import ilidpe.persistence.RueTDG;

public class InsertRueAction extends ActionSupport {
    private String nom;
    private String errorMessage;

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    @Override
    public String execute() {
        try {
        	RueTDG rtdg = (RueTDG) ServletActionContext.getServletContext().getAttribute("rtdg");
        	Rue r = new Rue(nom);
        	rtdg.insert(r);
            return SUCCESS;
        } catch (Exception e) {
            setErrorMessage("Erreur lors de l'insertion de la rue");
            return ERROR;
        }
    }

	public String getNom() {
		return nom;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}
}
