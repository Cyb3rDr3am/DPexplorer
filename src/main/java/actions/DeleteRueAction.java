package actions;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

import ilidpe.persistence.BatimentTDG;
import ilidpe.persistence.RueTDG;

public class DeleteRueAction extends ActionSupport {
    private long id;
    private String errorMessage;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

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
            rtdg.delete(rtdg.findById(id));
            return SUCCESS;
        } catch (Exception e) {
            setErrorMessage("Erreur lors de la suppression de la rue");
            return ERROR;
        }
    }
}
