package actions;

import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

import ilidpe.persistence.Ville;
import ilidpe.persistence.VilleTDG;

public class MapAction extends ActionSupport  {
	private String actionName;
	
	private String classEnergySelect;
	private Integer villeSelected;
	private Integer rueSelected;
	private int numeroSelected;
	
	private List<Ville> listVilles;
	
	private String path;
	

	public String execute() throws SQLException {
		path = ServletActionContext.getRequest().getContextPath();
		VilleTDG vtdg = (VilleTDG) ServletActionContext.getServletContext().getAttribute("vtdg");
		listVilles = vtdg.selectWhere("ID >= 0");
		Collections.sort(listVilles, (v1, v2) -> v1.getcPostal().getCode().compareTo(v2.getcPostal().getCode()));
		return SUCCESS;
//		return ActionManager.mapSuccessResponse.get(String.valueOf(actionName));
	}
	
	public void setActionName(String actionName) {
        this.actionName = actionName;
    }
	public String getClassEnergySelect() {
        return this.classEnergySelect;
    }
    public void setClassEnergySelect(String classEnergySelect) {
        this.classEnergySelect = classEnergySelect;
    }
	public Integer getVilleSelected() {
        return this.villeSelected;
    }
    public void setVilleSelected(Integer villeSelected) {
        this.villeSelected = villeSelected;
    }
	public Integer getRueSelected() {
        return this.rueSelected;
    }
    public void setRueSelected(Integer rueSelected) {
        this.rueSelected = rueSelected;
    }
    public int getNumeroSelected() {
        return this.numeroSelected;
    }
    public void setNumeroSelected(int numeroSelected) {
        this.numeroSelected = numeroSelected;
    }
    public List<Ville> getListVilles() {
    	return this.listVilles;
    }
    public String getPath() {
    	return this.path;
    }
}
