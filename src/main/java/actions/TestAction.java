package actions;

import com.opensymphony.xwork2.ActionSupport;

import java.util.List;

import org.apache.struts2.ServletActionContext;
import ilidpe.persistence.*;


public class TestAction extends ActionSupport  {
    private String message;
    private List<Batiment> batiments;

    @Override
    public String execute() throws Exception {
    	BatimentTDG btdg = (BatimentTDG) ServletActionContext.getServletContext().getAttribute("btdg");
    	
        message = "Hello World";
        batiments = btdg.selectWhere("ID >= 1");
        message = "" + batiments.size();
        return SUCCESS;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
    public List<Batiment> getBatiments() {
        return batiments;
    }
}
