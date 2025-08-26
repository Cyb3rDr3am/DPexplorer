package actions;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

import ilidpe.persistence.BatimentTDG;

public class DeleteDPEAction extends ActionSupport {
    private long id;
    private String errorMessage;
    

    // Getters and setters
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
            BatimentTDG btdg = (BatimentTDG) ServletActionContext.getServletContext().getAttribute("btdg");
            btdg.delete(btdg.findById(id));
            return SUCCESS;
        } catch (Exception e) {
            setErrorMessage("Erreur lors de la suppression du DPE");
            return ERROR;
        }
    }
}
